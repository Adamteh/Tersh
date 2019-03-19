import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../../scoped-models/main.dart';
import './chat_page.dart';

class ChatsWith extends StatefulWidget {
  @override
  ChatsWithState createState() => ChatsWithState();
}

class ChatsWithState extends State<ChatsWith> {
  static bool newMessage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messages'),
      ),
      body: Container(
        child: StreamBuilder(
          stream: Firestore.instance.collection('messages').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                ),
              );
            } else {
              return ListView.builder(
                padding: EdgeInsets.all(10.0),
                itemBuilder: (context, index) =>
                    buildItem(context, snapshot.data.documents[index]),
                itemCount: snapshot.data.documents.length,
              );
            }
          },
        ),
      ),
    );
  }

  Widget buildItem(BuildContext context, DocumentSnapshot document) {
    return ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainModel model) {
      //if user is the sender of the message
      if (document['CurrentSenderId'] == model.authenticatedUser.id) {
        newMessage = false;
        return Container(
          child: Material(
            shape: StadiumBorder(),
            elevation: 10,
            color: Colors.white.withOpacity(.0),
            child: FlatButton(
              child: Row(
                children: <Widget>[
                  Material(
                    child: CachedNetworkImage(
                      useOldImageOnUrlChange: true,
                      placeholder: ((context, url) => Container(
                            child: CircularProgressIndicator(
                              strokeWidth: 1.0,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.black),
                            ),
                            width: 50.0,
                            height: 50.0,
                            padding: EdgeInsets.all(15.0),
                          )),
                      errorWidget: ((context, url, error) => Material(
                            child: Image.asset(
                              'assets/person-placeholder-portrait.png',
                              width: 50.0,
                              height: 50.0,
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                          )),
                      //show the receiver's photo
                      imageUrl: document['To_photoUrl'],
                      width: 50.0,
                      height: 50.0,
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  Flexible(
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            //show the receiver's username
                            child: Text(
                              'UserName: ${document['To_Username']}',
                              style: TextStyle(color: Colors.black),
                            ),
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                          ),
                        ],
                      ),
                      margin: EdgeInsets.only(left: 20.0),
                    ),
                  ),
                ],
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Chat(
                              userId: model.authenticatedUser.id != null
                                  ? model.authenticatedUser.id
                                  : document['CurrentSenderId'],
                              userName: model.iUser != null
                                  ? model.iUser.userName
                                  : ['CurrentSender_Username'],
                              myAvatar: model.userPhoto != null
                                  ? model.userPhoto.userPhotoUrl
                                  : document['CurrentSender_photoUrl'],
                              peerId: document['idTo'],
                              sellerUsername: document['To_Username'],
                              peerAvatar: document['To_photoUrl'],
                            )));
              },
              color: Colors.blue[200],
              padding: EdgeInsets.fromLTRB(25.0, 15.0, 25.0, 15.0),
              shape: StadiumBorder(),
            ),
          ),
          margin: EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
        );
        //if user is the receiver  of the message
      } else if (document['idTo'] == model.authenticatedUser.id) {
        newMessage = true;
        return Container(
          child: Material(
            shape: StadiumBorder(),
            elevation: 10,
            color: Colors.white.withOpacity(.0),
            child: FlatButton(
              child: Row(
                children: <Widget>[
                  Material(
                    child: CachedNetworkImage(
                      placeholder: ((context, url) => Container(
                            child: CircularProgressIndicator(
                              strokeWidth: 1.0,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.black),
                            ),
                            width: 50.0,
                            height: 50.0,
                            padding: EdgeInsets.all(15.0),
                          )),
                      errorWidget: ((context, url, error) => Material(
                            child: Image.asset(
                              'assets/person-placeholder-portrait.png',
                              width: 50.0,
                              height: 50.0,
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                          )),
                      //show sender's photo
                      imageUrl: document['CurrentSender_photoUrl'],
                      width: 50.0,
                      height: 50.0,
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  ),
                  Flexible(
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            //show sender's username
                            child: Text(
                              'UserName: ${document['CurrentSender_Username']}',
                              style: TextStyle(color: Colors.black),
                            ),
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                          ),
                        ],
                      ),
                      margin: EdgeInsets.only(left: 20.0),
                    ),
                  ),
                ],
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Chat(
                          userId: model.authenticatedUser.id != null
                              ? model.authenticatedUser.id
                              : document['idTo'],
                          userName: model.iUser != null
                              ? model.iUser.userName
                              : document['To_Username'],
                          myAvatar: model.userPhoto != null
                              ? model.userPhoto.userPhotoUrl
                              : document['To_photoUrl'],
                          peerId: document['CurrentSenderId'],
                          sellerUsername: document['CurrentSender_Username'],
                          peerAvatar: document['CurrentSender_photoUrl'],
                        ),
                  ),
                );
              },
              color: Colors.green[300],
              padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
              shape: StadiumBorder(),
            ),
          ),
          margin: EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
        );
      } else {
        return Container();
      }
    });
  }
}
