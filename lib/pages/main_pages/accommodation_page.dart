import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../models/item.dart';
import '../../scoped-models/main.dart';
import '../../widgets/ui_elements/platform_progress_indicator.dart';

import '../../widgets/ui_elements/item_card.dart';

class AccommodationsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AccommodationsPageState();
  }
}

class _AccommodationsPageState extends State<AccommodationsPage> {
  Widget _buildAccommodationList() {
    return ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainModel model) {
      Future refreshAccommodation() {
        return model.fetchAccommodationRefreshed().then((_) {
           model.fetchUsers();
           model.fetchUsersPhoto();
          Fluttertoast.showToast(msg: "Accommodation Refreshed");
        });
      }
       for (var x = 0; x < model.allAccommodation.length; x++) {
        for (var y = 0; y < model.allUsersName.length; y++) {
          if (model.allAccommodation[x].userId == model.allUsersName[y].id) {
            model.allAccommodation[x].userName = model.allUsersName[y].userName;
          }
        }
      }

      for (var x = 0; x < model.allAccommodation.length; x++) {
        for (var y = 0; y < model.allUsersPhoto.length; y++) {
          if (model.allAccommodation[x].userId == model.allUsersPhoto[y].id) {
            model.allAccommodation[x].userPhotoUrl = model.allUsersPhoto[y].userPhotoUrl;
          }
        }
      }

      Widget content = Center(child: Text('No Hostels Found'));
      if (model.allAccommodation.length > 0 && !model.isLoading) {
        content = _Accommodation(model.allAccommodation);
      } else if (model.isLoading) {
        content = Center(child: PlatformProgressIndicator());
      }
      return RefreshIndicator(
        onRefresh: refreshAccommodation,
        child: content,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(child: _buildAccommodationList());
  }
}

class _Accommodation extends StatelessWidget {
  final List<Item> accommodation;

  _Accommodation(this.accommodation);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        void favIconPressed(Item item) {
          model.favoriteAccommodationStatus(item);
        }

        Widget accommodationCard;
        if (accommodation.length > 0) {
          accommodationCard = ListView.builder(
            itemBuilder: (BuildContext context, int index) =>
                ItemCard(accommodation[index], favIconPressed),
            itemCount: accommodation.length,
          );
        }
        return accommodationCard;
      },
    );
  }
}
