import 'package:flutter/material.dart';

class User {
  final String id;
  final String email;
  final String token;

  User({@required this.id, @required this.email, this.token});
}

class UsersData {
  final String id;
  final String email;
  final String userName;
  final String phoneNumber;

  UsersData({this.id, this.email, this.userName, this.phoneNumber});
}

class UsersPhoto {
  final String id;
  final String email;
  final String userPhotoUrl;
  final String userPhotoPath;

  UsersPhoto({this.id,  this.email, this.userPhotoUrl, this.userPhotoPath});
}
