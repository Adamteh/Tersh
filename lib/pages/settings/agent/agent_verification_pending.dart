import 'package:flutter/material.dart';

class VerificationPending extends StatefulWidget {
  @override
  _VerificationPendingState createState() => _VerificationPendingState();
}

class _VerificationPendingState extends State<VerificationPending> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verification Pending'),
      ),
      body: Container(
        child: Center(
          child: Text('Verification Pending...'),
        ),
      ),
    );
  }
}