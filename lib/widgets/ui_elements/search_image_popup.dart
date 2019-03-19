import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../models/item.dart';
import '../../scoped-models/main.dart';
import './title_default.dart';
import './price_tag.dart';

class SearchItemImage extends StatelessWidget {
  final Item item;

  SearchItemImage(this.item);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return GestureDetector(
          child: Container(
            child: Hero(
              tag: item.id,
              child: FadeInImage(
                fit: BoxFit.cover,
                image: NetworkImage(item.image),
                fadeInDuration: Duration(milliseconds: 380),
                fadeOutDuration: Duration(seconds: 0),
                placeholder: AssetImage('assets/placeholderimage.png'),
              ),
            ),
          ),
          onTap: () {
            model.selectItem(item.id);
            Navigator.pushNamed(context, '/detailpage/' + item.id)
                .then((_) => model.selectItem(null));
          },
          onLongPress: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return SimpleDialog(
                  contentPadding: EdgeInsets.all(0),
                  title: Row(
                    children: <Widget>[
                      Flexible(child: TitleDefault(item.title)),
                      Flexible(child: SizedBox(width: 10.0)),
                      PriceTag(item.price.toString())
                    ],
                  ),
                  children: <Widget>[
                    GestureDetector(
                      child: Hero(
                        tag: item.id,
                        child: FadeInImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(item.image),
                          fadeInDuration: Duration(milliseconds: 380),
                          fadeOutDuration: Duration(seconds: 0),
                          placeholder:
                              AssetImage('assets/placeholderimage.png'),
                        ),
                      ),
                      onForcePressEnd: (_) {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}
