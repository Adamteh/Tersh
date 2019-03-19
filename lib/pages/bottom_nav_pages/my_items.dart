import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:intl/intl.dart';

import '../../models/item.dart';
import '../add_pages/edit_update.dart';
import '../../scoped-models/main.dart';

class MyItems extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyItemsState();
  }
}

class _MyItemsState extends State<MyItems> {
  Widget _buildItemsList() {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      List<Item> allItems = model.userCreatedProducts +
          model.userCreatedAccommodation +
          model.userCreatedJobs +
          model.userCreatedEvent;

      //sorting the items according to the time it was posted, new to old
      allItems.sort((a, b) => b.timeStamp.compareTo(a.timeStamp));

      Widget content;
      if (allItems.length > 0) {
        content = _ItemList();
      } else {
        content = Center(child: Text('No Items Found'));
      }
      return content;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(child: _buildItemsList());
  }
}

class _ItemList extends StatelessWidget {
  Widget _buildEditButton(BuildContext context, int index, MainModel model) {
    List<Item> allItems = model.userCreatedProducts +
        model.userCreatedAccommodation +
        model.userCreatedJobs +
        model.userCreatedEvent;

    //sorting the items according to the time it was posted, new to old
    allItems.sort((a, b) => b.timeStamp.compareTo(a.timeStamp));
    return IconButton(
      icon: Icon(Icons.edit),
      onPressed: () {
        model.selectItem(allItems[index].id);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return Edit();
            },
          ),
        ).then((_) {
          model.selectItem(null); // fix page error
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      List<Item> allItems = model.userCreatedProducts +
          model.userCreatedAccommodation +
          model.userCreatedJobs +
          model.userCreatedEvent;

      //sorting the items according to the time it was posted, new to old
      allItems.sort((a, b) => b.timeStamp.compareTo(a.timeStamp));

      return ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: Key(allItems[index].id),
            onDismissed: (DismissDirection direction) {
              if (direction == DismissDirection.endToStart) {
                model.selectItem(allItems[index].id);
                model.deleteProduct();
                model.deleteAccommodation();
                model.deleteJob();
                model.deleteEvent();
              } else if (direction == DismissDirection.startToEnd) {
                model.selectItem(allItems[index].id);
                model.deleteProduct();
                model.deleteAccommodation();
                model.deleteJob();
                model.deleteEvent();
              }
            },
            background: Container(
              color: Colors.red,
              child: ListTile(
                leading: Icon(Icons.delete, color: Colors.black, size: 36.0),
              ),
            ),
            secondaryBackground: Container(
              color: Colors.red,
              child: ListTile(
                trailing: Icon(Icons.delete, color: Colors.black, size: 36.0),
              ),
            ),
            child: Column(
              children: <Widget>[
                ListTile(
                  isThreeLine: true,
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(allItems[index].image),
                  ),
                  title: Text(allItems[index].title),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('GH₵ ' + allItems[index].price.toString()),
                      Text(
                        'Date Created: ' +
                            DateFormat('dd MMM kk:mm').format(
                                DateTime.fromMillisecondsSinceEpoch(int.parse(
                                    allItems[index].timeStamp.toString()))),
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12.0,
                            fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                  trailing: _buildEditButton(context, index, model),
                ),
                Divider(),
              ],
            ),
          );
        },
        itemCount: allItems.length,
      );
    });
  }
}
