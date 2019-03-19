import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/item.dart';
import '../../../scoped-models/main.dart';
import '../chat/chat_page.dart';

class ProductFab extends StatefulWidget {
  final Item item;
  final Function favoriteStatus;
  final selectedItem;

  ProductFab(this.item, this.favoriteStatus, this.selectedItem);

  @override
  State<StatefulWidget> createState() {
    return _ProductFabState();
  }
}

class _ProductFabState extends State<ProductFab> with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            widget.item.userId == model.authenticatedUser.id
                ? Container(
                    height: 70.0,
                    width: 56.0,
                    alignment: FractionalOffset.topCenter,
                    child: ScaleTransition(
                        scale: CurvedAnimation(
                          parent: _controller,
                          curve: Interval(0.0, 1.0, curve: Curves.easeOut),
                        ),
                        child: Container()),
                  )
                : Container(
                    height: 70.0,
                    width: 56.0,
                    alignment: FractionalOffset.topCenter,
                    child: ScaleTransition(
                      scale: CurvedAnimation(
                        parent: _controller,
                        curve: Interval(0.0, 1.0, curve: Curves.easeOut),
                      ),
                      child: FloatingActionButton(
                        backgroundColor: Colors.white,
                        heroTag: 'Message Seller',
                        mini: true,
                        child: Icon(Icons.message, color: Colors.red),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Chat(
                                    userId: model.authenticatedUser.id,
                                    userName: model.iUser.userName,
                                    myAvatar: model.userPhoto == null
                                        ? ''
                                        : model.userPhoto.userPhotoUrl,
                                    peerId: widget.item.userId,
                                    peerAvatar: widget.item.userPhotoUrl == null
                                        ? ''
                                        : widget.item.userPhotoUrl,
                                    sellerUsername: widget.item.userName,
                                  ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
//            Container(
//              height: 70.0,
//              width: 56.0,
//              alignment: FractionalOffset.topCenter,
//              child: ScaleTransition(
//                scale: CurvedAnimation(
//                  parent: _controller,
//                  curve: Interval(0.0, 1.0, curve: Curves.easeOut),
//                ),
//                child: FloatingActionButton(
//                  backgroundColor: Colors.white,
//                  heroTag: 'Contact Seller',
//                  mini: true,
//                  child: Icon(Icons.email, color: Colors.red),
//                  onPressed: () async {
//                    final url = 'mailto:${widget.item.userEmail}';
//                    if (await canLaunch(url)) {
//                      await launch(url);
//                    } else {
//                      throw 'Could not launch';
//                    }
//                  },
//                ),
//              ),
//            ),
            Container(
              height: 70.0,
              width: 56.0,
              alignment: FractionalOffset.topCenter,
              child: ScaleTransition(
                scale: CurvedAnimation(
                  parent: _controller,
                  curve: Interval(0.0, 0.5, curve: Curves.easeOut),
                ),
                child: FloatingActionButton(
                  backgroundColor: Colors.white,
                  heroTag: 'Favorite',
                  mini: true,
                  onPressed: () {
                    widget.favoriteStatus(widget
                        .selectedItem); // placeholders for favoriteStatus and selectedItem for each item
                  },
                  child: Icon(
                      widget.selectedItem.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: Colors.red),
                ),
              ),
            ),
            FloatingActionButton(
              heroTag: 'options',
              onPressed: () {
                if (_controller.isDismissed) {
                  //animation not played
                  _controller.forward();
                } else {
                  _controller.reverse(); //if animation is played , reverse it
                }
              },
              child: AnimatedBuilder(
                animation: _controller,
                builder: (BuildContext context, Widget child) {
                  return Transform(
                      alignment: FractionalOffset.center,
                      transform:
                          Matrix4.rotationZ(_controller.value * 0.5 * math.pi),
                      child: Icon(
                          _controller.isDismissed ? Icons.add : Icons.close));
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
