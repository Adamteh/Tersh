import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class PlatformProgressIndicator extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    return Theme.of(context).platform == TargetPlatform.iOS
        ? CupertinoActivityIndicator()
        : CircularProgressIndicator(backgroundColor: Theme.of(context).accentColor,);
  }
}
