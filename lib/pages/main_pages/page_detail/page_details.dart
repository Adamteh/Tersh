import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:intl/intl.dart';

import '../../../models/item.dart';
import '../../../widgets/form_inputs/map.dart';
import './item_fab.dart';
import '../../../scoped-models/main.dart';
import './pic_view.dart';

class DetailsPage extends StatelessWidget {
  final Item item;

  DetailsPage(this.item);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        var f = NumberFormat("###,###.0#", "en_US");
        var formatedPrice = f.format(int.parse(item.price));
        List<Item> all = model.allProducts +
            model.allAccommodation +
            model.allJobs +
            model.allEvents;

        var selectedItem = all.firstWhere(
          (Item item) {
            return item.id == model.selectedItemId;
          },
        );

        void favoriteStatus(Item item) {
          model.favoriteAccommodationStatus(item);
          model.favoriteProductStatus(item);
          model.favoriteJobStatus(item);
          model.favoriteEventStatus(item);
        }

        final myDeviceWidth = MediaQuery.of(context).size.width;
        return WillPopScope(
          onWillPop: () {
            Navigator.pop(context, false);
            return Future.value(false);
          },
          child: Scaffold(
            body: Scrollbar(
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    backgroundColor: Colors.white.withOpacity(0.5),
                    expandedHeight: 250.0,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text(
                        item.title,
                        //style: TextStyle(color: Colors.black),
                      ),
                      background: GestureDetector(
                        child: Hero(
                          tag: item.id,
                          child: FadeInImage(
                            fit: BoxFit.cover,
                            width: myDeviceWidth,
                            image: NetworkImage(
                              item.image,
                            ),
                            fadeInDuration: Duration(milliseconds: 380),
                            fadeOutDuration: Duration(seconds: 0),
                            placeholder:
                                AssetImage('assets/placeholderimage.png'),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PicViewPage(item)),
                          );
                        },
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            item.userPhotoUrl != null
                                ? CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(item.userPhotoUrl),
                                    radius: 18,
                                  )
                                : CircleAvatar(
                                    backgroundImage: AssetImage(
                                        'assets/person-placeholder-portrait.png'),
                                    radius: 18,
                                  ),
                            SizedBox(width: 20),
                            Text(item.userName),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.all(10.0),
                          alignment: Alignment.center,
                          child: Text(
                            item.title,
                            softWrap: true,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: myDeviceWidth > 700 ? 26.0 : 15.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            'GH₵ ' + formatedPrice.toString(),
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ItemMap(item)),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.location_on,
                                color: Colors.green,
                              ),
                              //Address
                              Flexible(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 6.0, vertical: 2.5),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey, width: 1.0),
                                      borderRadius: BorderRadius.circular(6.0)),
                                  child: Text(
                                    item.locationAddress,
                                    softWrap: true,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            item.description,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            floatingActionButton:
                ProductFab(item, favoriteStatus, selectedItem),
          ),
        );
      },
    );
  }
}
