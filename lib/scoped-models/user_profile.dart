import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/user.dart';
import '../models/auth.dart';
import './connected_items.dart';

mixin UserProfileModel on ConnectedItemsModel {
  UsersData iUser;
  UsersPhoto userPhoto;

  List<UsersData> _usersData = [];
  List<UsersPhoto> _usersPhoto = [];

  List<UsersData> get allUsersName {
    return List.from(_usersData);
  }

  List<UsersPhoto> get allUsersPhoto {
    return List.from(_usersPhoto);
  }

  List<UsersData> get myUsers {
    return _usersData.where((UsersData _user) {
      return _user.id == authenticatedUser.id;
    }).toList();
  }

  Future<Map<String, dynamic>> uploadProfileImage(File image,
      {String imagePath}) async {
    final mimeTypeData = lookupMimeType(image.path).split('/');
    final imageUploadRequest = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://us-central1-flutter-buy.cloudfunctions.net/storeProfileImage'));
    final file = await http.MultipartFile.fromPath(
      'image',
      image.path,
      contentType: MediaType(
        mimeTypeData[0],
        mimeTypeData[1],
      ),
    );
    imageUploadRequest.files.add(file);
    if (imagePath != null) {
      imageUploadRequest.fields['imagePath'] = Uri.encodeComponent(imagePath);
    }
    imageUploadRequest.headers['Authorization'] =
        'Bearer ${authenticatedUser.id}';

    try {
      final streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode != 200 && response.statusCode != 201) {
        print('Something went wrong with 1st image');
        print(json.decode(response.body));
        return null;
      }
      final responseData = json.decode(response.body);
      return responseData;
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<bool> addNewUser(String email, String userName,
      [AuthMode mode = AuthMode.Login]) async {
    final Map<String, dynamic> newUserData = {
      'email': email,
      'userName': userName,
    };

    if (mode == AuthMode.Signup) {
      try {
        final http.Response response = await http.put(
            'https://flutter-buy.firebaseio.com/Users/UserNames/${authenticatedUser.id}.json', //firebase backend url /products.json
            body: json.encode(newUserData));

        //successful response codes are 200 and 201
        //checking if the post request is not successful
        if (response.statusCode != 200 && response.statusCode != 201) {
          return false; //if not successful
        }
        //will proceed if successful
        final UsersData newUser = UsersData(
          email: email,
          userName: userName,
        );
        iUser = newUser;
        return true; //if successful
      } catch (error) {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<bool> addUserPhoto(File photo) async {
    loading = true;
    notifyListeners();
    String photoUrl;
    String photoPath;

    if (photo != null) {
      //check if there is a selected image/new image
      final uploadData = await uploadProfileImage(photo);

      photoUrl = uploadData['imageUrl'];
      photoPath = uploadData['imagePath'];
    } else {
      photoUrl = userPhoto == null ? null : userPhoto.userPhotoUrl;
      photoPath = userPhoto == null ? null : userPhoto.userPhotoUrl;
    }

    final Map<String, dynamic> newUserPhoto = {
      'email': authenticatedUser.email,
      'userPhotoUrl': photoUrl,
      'userPhotoPath': photoPath,
    };

    try {
      final http.Response response = await http.put(
          'https://flutter-buy.firebaseio.com/Users/UserPhotos/${authenticatedUser.id}.json', //firebase backend url /products.json
          body: json.encode(newUserPhoto));

      //successful response codes are 200 and 201
      //checking if the post request is not successful
      if (response.statusCode != 200 && response.statusCode != 201) {
        loading = false;
        notifyListeners();
        return false; //if not successful
      }
      //will proceed if successful
      Fluttertoast.showToast(msg: "Profile Photo Updated");

      final UsersPhoto newUser = UsersPhoto(
        userPhotoUrl: photoUrl,
        userPhotoPath: photoPath,
      );
      userPhoto = newUser;
      loading = false;
      notifyListeners();
      return true; //if successful
    } catch (error) {
      return false;
    }
  }

  Future<bool> deleteUserPhoto() {
    try {
      userPhoto = null;

      return http
          .delete(
              'https://flutter-buy.firebaseio.com/Users/UserPhotos/${authenticatedUser.id}.json')
          .then((http.Response response) {
        Fluttertoast.showToast(
          msg: "Profile Photo Deleted",
        );
        return true; //if successful
      }).catchError(
        (error) {
          return false; //if not successful
        },
      );
    } catch (error) {
      return null;
    }
  }

  Future<bool> updateUser(
    String userName,
  ) async {
    loading = true;
    notifyListeners();

    final Map<String, dynamic> newUserData = {
      'email': authenticatedUser.email,
      'userName': userName,
    };

    try {
      final http.Response response = await http.put(
          'https://flutter-buy.firebaseio.com/Users/UserNames/${authenticatedUser.id}.json', //firebase backend url /products.json
          body: json.encode(newUserData));

      //successful response codes are 200 and 201
      //checking if the post request is not successful
      if (response.statusCode != 200 && response.statusCode != 201) {
        loading = false;
        notifyListeners();
        return false; //if not successful
      }
      //will proceed if successful
      Fluttertoast.showToast(msg: "Username Updated");

      final UsersData newUser = UsersData(
        email: authenticatedUser.email,
        userName: userName,
      );
      iUser = newUser;
      loading = false;
      notifyListeners();
      return true; //if successful
    } catch (error) {
      return false;
    }
  }

  Future<Null> fetchNewUser() {
    return http
        .get(
            'https://flutter-buy.firebaseio.com/Users/UserNames/${authenticatedUser.id}.json')
        .then<Null>((http.Response response) {
      UsersData fetchedUserData;
      final Map<String, dynamic> usersListData = json.decode(response.body);
      //print(usersListData);
      if (usersListData == null) {
        return;
      }
      usersListData.forEach((String k, dynamic userData) {
        final UsersData user = UsersData(
          userName: userData,
        );
        fetchedUserData = user;
      });
      iUser = fetchedUserData;
    }).catchError((error) {
      return;
    });
  }

  Future<Null> fetchUserPhoto() {
    return http
        .get(
            'https://flutter-buy.firebaseio.com/Users/UserPhotos/${authenticatedUser.id}.json')
        .then<Null>((http.Response response) {
      UsersPhoto fetchedUserData;
      final Map<String, dynamic> usersListData = json.decode(response.body);
      if (usersListData == null) {
        return;
      }
      usersListData.forEach((String k, dynamic _users) {
        final UsersPhoto _user = UsersPhoto(userPhotoUrl: _users);
        fetchedUserData = _user;
      });
      userPhoto = fetchedUserData;
    }).catchError((error) {
      return;
    });
  }

//
  //
  //
//fetch all users details
  Future<Null> fetchUsers() {
    return http
        .get('https://flutter-buy.firebaseio.com/Users/UserNames/.json')
        .then<Null>((http.Response response) {
      final List<UsersData> fetchedUserData = [];

      final Map<String, dynamic> usersListData = json.decode(response.body);
      //print(usersListData);
      if (usersListData == null) {
        return;
      }
      usersListData.forEach((String userId, dynamic userData) {
        final UsersData user = UsersData(
          id: userId,
          email: userData['email'],
          userName: userData['userName'],
        );
        fetchedUserData.add(user);
      });
      _usersData = fetchedUserData;
    }).catchError((error) {
      return;
    });
  }

  Future<Null> fetchUsersPhoto() {
    return http
        .get('https://flutter-buy.firebaseio.com/Users/UserPhotos/.json')
        .then<Null>((http.Response response) {
      final List<UsersPhoto> fetchedUserData = [];
      final Map<String, dynamic> usersListData = json.decode(response.body);
      if (usersListData == null) {
        return;
      }
      usersListData.forEach((String userId, dynamic _users) {
        final UsersPhoto _user = UsersPhoto(
          id: userId,
          email: _users['email'],
          userPhotoUrl: _users['userPhotoUrl'],
          userPhotoPath: _users['userPhotoPath'],
        );
        fetchedUserData.add(_user);
      });
      _usersPhoto = fetchedUserData;
    }).catchError((error) {
      return;
    });
  }
}
