import 'package:flutter/material.dart';
import 'package:backdrop/backdrop.dart';

class CustomizePage extends StatefulWidget {
  @override
  _CustomizePageState createState() => _CustomizePageState();
}

class _CustomizePageState extends State<CustomizePage> {
  @override
  Widget build(BuildContext context) {
    return BackdropScaffold(
        title: Text('Customize'),
        frontLayer: Container(
          child: Center(
            child: Text('Front data'),
          ),
        ),
        backLayer: Container(
          child: Center(
            child: Text('Back data'),
          ),
        ),
        iconPosition: BackdropIconPosition.none,
        actions: <Widget>[
          BackdropToggleButton(
            icon: AnimatedIcons.list_view,
          ),
        ]);
  }
}
