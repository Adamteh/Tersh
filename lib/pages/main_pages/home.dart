import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';

import '../../models/item.dart';
import '../../models/user.dart';
import '../../scoped-models/main.dart';
import '../../widgets/ui_elements/platform_progress_indicator.dart';
import '../../main.dart';
import '../../widgets/ui_elements/title_default.dart';
import '../../widgets/ui_elements/price_tag.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  Widget _buildItemsList() {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      List<Item> allItems = model.allProducts +
          model.allAccommodation +
          model.allJobs +
          model.allEvents;

      List<UsersData> allUserNames = model.allUsersName;

      List<UsersPhoto> allUserPhotos = model.allUsersPhoto;

      for (var x = 0; x < allItems.length; x++) {
        for (var y = 0; y < allUserNames.length; y++) {
          if (allItems[x].userId == allUserNames[y].id) {
            allItems[x].userName = allUserNames[y].userName;
          }
        }
      }

      for (var x = 0; x < allItems.length; x++) {
        for (var y = 0; y < allUserPhotos.length; y++) {
          if (allItems[x].userId == allUserPhotos[y].id) {
            allItems[x].userPhotoUrl = allUserPhotos[y].userPhotoUrl;
          }
        }
      }
      //sorting the items according to the time it was posted, new to old
      allItems.sort((a, b) => b.timeStamp.compareTo(a.timeStamp));

      Future refreshing() {
        return model.fetchProductsRefreshed().then((_) {
          model.fetchAccommodationRefreshed();
          model.fetchJobRefreshed();
          model.fetchEventRefreshed();
          model.fetchUsers();
          model.fetchUsersPhoto();
          model.fetchAgents();
          model.fetchNewUser();
          model.fetchUserPhoto();
          model.fetchAgent();
          Fluttertoast.showToast(msg: "Refreshed");
        });
      }

      Future refreshIfDataNotfetched() {
        return model.fetchProducts().then((_) {
          model.fetchProducts();
          model.fetchAccommodation();
          model.fetchJob();
          model.fetchEvent();
          model.fetchUsers();
          model.fetchUsersPhoto();
          model.fetchAgents();
          model.fetchNewUser();
          model.fetchUserPhoto();
          model.fetchAgent();
        });
      }

      Widget content = Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('No Items Found'),
          IconButton(
            tooltip: 'Refresh',
            iconSize: 45,
            icon: Icon(Icons.refresh),
            onPressed: () {
              refreshIfDataNotfetched();
            },
          )
        ],
      ));
      if (allItems.length > 0 && !model.isLoading) {
        content = _Home(allItems);
      } else if (model.isLoading) {
        content = Center(child: PlatformProgressIndicator());
      }
      return RefreshIndicator(
        onRefresh: refreshing,
        child: content,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: _buildItemsList(),
    );
  }
}

class _Home extends StatelessWidget {
  final List<Item> item;

  _Home(this.item);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        final orientation = MediaQuery.of(context).orientation;

        void favIconPressed(Item item) {
          model.favoriteAccommodationStatus(item);
          model.favoriteProductStatus(item);
          model.favoriteJobStatus(item);
          model.favoriteEventStatus(item);
        }

        Widget itemCard;
        if (item.length > 0) {
          itemCard = StaggeredGridView.countBuilder(
            crossAxisCount: 4,
            itemCount: item.length,
            itemBuilder: (BuildContext context, int index) =>
                _ItemCard(item[index], favIconPressed),
            staggeredTileBuilder: (int index) => new StaggeredTile.fit(
                orientation == Orientation.portrait ? 2 : 1),
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
          );
        }
        return itemCard;
      },
    );
  }
}

class _ItemCard extends StatelessWidget {
  final Item item;

  final Function favIconPressed;

  _ItemCard(this.item, this.favIconPressed);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return GestureDetector(
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Column(
              children: <Widget>[
                ListTile(
                  dense: true,
                  leading: item.userPhotoUrl != null
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(item.userPhotoUrl),
                          radius: 20,
                        )
                      : CircleAvatar(
                          backgroundImage: AssetImage(
                              'assets/person-placeholder-portrait.png'),
                          radius: 20,
                        ),
                  title: TitleDefault(item.title),
                  subtitle: Text(item.userName),
                ),
                Hero(
                  tag: item.id,
                  child: FadeInImage(
                    fit: BoxFit.fitWidth,
                    width: 500,
                    // height: 100,
                    image: NetworkImage(item.image),
                    fadeInDuration: Duration(milliseconds: 380),
                    fadeOutDuration: Duration(seconds: 0),
                    placeholder: AssetImage('assets/placeholderimage.png'),
                  ),
                ),
                PriceTag(item.price),
                SizedBox(height: 10),
                Text(
                  DateFormat('dd MMM kk:mm').format(
                      DateTime.fromMillisecondsSinceEpoch(
                          int.parse(item.timeStamp.toString()))),
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12.0,
                      fontStyle: FontStyle.italic),
                ),
                IconButton(
                  icon: Icon(
                    item.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: MyAppState.darkmode == false
                        ? Colors.red
                        : Colors.black,
                  ),
                  onPressed: () {
                    favIconPressed(item);
                    // Pass the item used in this card
                  },
                ),
              ],
            ),
          ),
          onTap: () {
            model.selectItem(item.id);
            Navigator.pushNamed(context, '/detailpage/' + item.id)
                .then((_) => model.selectItem(null));
          },
        );
      },
    );
  }
}
