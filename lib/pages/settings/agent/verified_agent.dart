import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../../scoped-models/main.dart';


class VerifiedAgent extends StatefulWidget {
  @override
  _VerifiedAgentState createState() => _VerifiedAgentState();
}

class _VerifiedAgentState extends State<VerifiedAgent> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Agent,  ${model.iAmAnAgent[0].name}'),
        ),
        body: Container(
          child: Center(
            child: Text('Verified'),
          ),
        ),
      );
    });
  }
}