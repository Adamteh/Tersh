import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../models/item.dart';
import '../../scoped-models/main.dart';
import '../../widgets/ui_elements/platform_progress_indicator.dart';

import '../../widgets/ui_elements/item_card.dart';

class EventsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EventsPageState();
  }
}

class _EventsPageState extends State<EventsPage> {
  Widget _buildEventsList() {
    return ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainModel model) {
      Future refreshEvents() {
        return model.fetchEventRefreshed().then((_) {
           model.fetchUsers();
           model.fetchUsersPhoto();
          Fluttertoast.showToast(msg: "Events Refreshed");
        });
      }
      for (var x = 0; x < model.allEvents.length; x++) {
        for (var y = 0; y < model.allUsersName.length; y++) {
          if (model.allEvents[x].userId == model.allUsersName[y].id) {
            model.allEvents[x].userName = model.allUsersName[y].userName;
          }
        }
      }
       for (var x = 0; x < model.allEvents.length; x++) {
        for (var y = 0; y < model.allUsersPhoto.length; y++) {
          if (model.allEvents[x].userId == model.allUsersPhoto[y].id) {
            model.allEvents[x].userPhotoUrl = model.allUsersPhoto[y].userPhotoUrl;
          }
        }
      }

      Widget content;
      if (model.allEvents.length > 0 && !model.isLoading) {
        content = _Events(model.allEvents);
      } else if (model.isLoading) {
        content = Center(child: PlatformProgressIndicator());
      } else {
        Container(child: content = Center(child: Text('No Events Found')));
      }
      return RefreshIndicator(
        onRefresh: refreshEvents,
        child: content,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(child: _buildEventsList());
  }
}

class _Events extends StatelessWidget {
  final List<Item> events;

  _Events(this.events);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        void favIconPressed(Item item) {
          model.favoriteEventStatus(item);
        }

        Widget eventCard;
        if (events.length > 0) {
          eventCard = ListView.builder(
            itemBuilder: (BuildContext context, int index) =>
                ItemCard(events[index], favIconPressed),
            itemCount: events.length,
          );
        }
        return eventCard;
      },
    );
  }
}
