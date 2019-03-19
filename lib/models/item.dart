import 'package:flutter/material.dart';

class Item {
  final String id;
  final String title;
  final String description;
  //price is string and not double be cause it rounds to e+ when the number is huge
  final String price;
  final String image;
  final String imagePath;
  //not final so that it can be assigned more than once
  //not final so it can be changed @ update
  String image1;
  String imagePath1;
  String image2;
  String imagePath2;
  String image3;
  String imagePath3;
  String image4;
  //not final so it can be set to null @ the image update page
  final String imagePath4;
  final String locationAddress;
  final double latitude;
  final double longitude;
  final bool isFavorite;
  final String userEmail;
  final String userId;
  String userName;
  String userPhotoUrl;
 final num timeStamp;

  Item(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.image,
      @required this.imagePath,
      @required this.locationAddress,
      @required this.latitude,
      @required this.longitude,
      @required this.userEmail,
      @required this.userId,
      this.image1,
      this.imagePath1,
      this.image2,
      this.imagePath2,
      this.image3,
      this.imagePath3,
      this.image4,
      this.imagePath4,
      this.userName,
      this.userPhotoUrl,
      this.timeStamp,
      this.isFavorite = false});
  //rapped in cully braces meaning named arguments not positional arguments
  //optional
}
