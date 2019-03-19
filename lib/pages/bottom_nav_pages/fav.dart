import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../models/item.dart';
import '../../scoped-models/main.dart';
import '../../widgets/ui_elements/platform_progress_indicator.dart';

import '../../widgets/ui_elements/item_card.dart';

class Fav extends StatefulWidget {
  final MainModel model;

  Fav(this.model);

  @override
  State<StatefulWidget> createState() {
    return _FavState();
  }
}

class _FavState extends State<Fav> {
  @override
  initState() {
    widget.model.toggleProductDisplayMode();
    widget.model.toggleAccommodationDisplayMode();
    widget.model.toggleJobDisplayMode();
    widget.model.toggleEventDisplayMode();
    super.initState();
  }

  Widget _buildFavList() {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      List<Item> allItems = model.displayFavoriteProducts +
          model.displayFavoriteAccommodation +
          model.displayFavoriteJobs +
          model.displayFavoriteEvent;

      //sorting the items according to the time it was posted, new to old
      allItems.sort((a, b) => b.timeStamp.compareTo(a.timeStamp));

      Future refreshing() {
        return model.fetchProductsRefreshed().then((_) {
          model.fetchAccommodationRefreshed();
          model.fetchJobRefreshed();
          model.fetchEventRefreshed();
          model.toggleProductDisplayMode();
          model.toggleAccommodationDisplayMode();
          model.toggleJobDisplayMode();
          model.toggleEventDisplayMode();
        });
      }

      Widget content = Center(child: Text('No Items Found'));
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
    return Scrollbar(child: _buildFavList());
  }
}

class _Home extends StatelessWidget {
  final List<Item> item;

  _Home(this.item);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        void cardPressed(Item item) {
          model.favoriteAccommodationStatus(item);
          model.favoriteProductStatus(item);
          model.favoriteJobStatus(item);
          model.favoriteEventStatus(item);
        }

        Widget itemCard;
        if (item.length > 0) {
          itemCard = ListView.builder(
            itemBuilder: (BuildContext context, int index) =>
                ItemCard(item[index], cardPressed),
            itemCount: item.length,
          );
        }
        return itemCard;
      },
    );
  }
}
