import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:intl/intl.dart';

import '../../models/item.dart';
import '../../scoped-models/main.dart';

import './title_default.dart';
import './address_tag.dart';
import './price_tag.dart';
import '../../main.dart';

class ItemCard extends StatelessWidget {
  final Item item;
  final Function favIconPressed;
  ItemCard(this.item, this.favIconPressed);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        final myDeviceWidth = MediaQuery.of(context).size.width;

        return GestureDetector(
          child: Card(
            margin: EdgeInsets.all(10.0),
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
                SizedBox(
                  height: 200.0,
                  child: Hero(
                    tag: item.id,
                    child: FadeInImage(
                      fit: BoxFit.cover,
                      width: myDeviceWidth,
                      image: NetworkImage(item.image),
                      fadeInDuration: Duration(milliseconds: 380),
                      fadeOutDuration: Duration(seconds: 0),
                      placeholder: AssetImage('assets/placeholderimage.png'),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                //TitlePriceRow
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    PriceTag(item.price),
                    Flexible(child: SizedBox(width: 10.0)),
                    Flexible(
                        child: Text(
                      DateFormat('dd MMM kk:mm').format(
                          DateTime.fromMillisecondsSinceEpoch(
                              int.parse(item.timeStamp.toString()))),
                      style: TextStyle(color: Colors.grey, fontSize: 12.0, fontStyle: FontStyle.italic),
                    )),
                  ],
                ),
                SizedBox(height: 12.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Flexible(
                      child: Icon(
                        Icons.location_on,
                        color: Colors.green,
                      ),
                    ),
                    Flexible(
                      child: AddressTag(item.locationAddress),
                    ),
                  ],
                ),

                //ActionButtons
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        item.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
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
