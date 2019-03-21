import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

import '../models/item.dart';
import './connected_items.dart';

mixin AccommodationModel on ConnectedItemsModel {
  List<Item> _accommodation = [];

  bool _showFavorite = false;

  List<Item> get allAccommodation {
    return List.from(_accommodation
        .reversed); // .reversed, return data in the reversed order, from new to old.. default is old to new
  }

  List<Item> get displayFavoriteAccommodation {
    return _accommodation.reversed
        .where((Item accommodation) => accommodation.isFavorite)
        .toList();
  }

  List<Item> get userCreatedAccommodation {
    return _accommodation.reversed.where((Item accommodation) {
      return accommodation.userId == authenticatedUser.id;
    }).toList();
  }

  int get selectedAccommodationIndex {
    return _accommodation.indexWhere((Item accommodation) {
      return accommodation.id == selectedItemId;
    });
  }

  String get selectedAccommodationId {
    return selectedItemId;
  }

  Item get selectedAccommodation {
    if (selectedAccommodationId == null) {
      return null;
    }
    return _accommodation.firstWhere((Item accommodation) {
      return accommodation.id == selectedItemId;
    });
  }

  Future<bool> addAccommodation(
      String title,
      String description,
      File image,
      File image1,
      File image2,
      File image3,
      File image4,
      String price,
      String locationAddress,
      double latitude,
      double longitude) async {
    loading = true;
    notifyListeners();
    final uploadData = await uploadImage(image);

    final uploadData1 = await uploadImage(image1).catchError((error) {});
    final uploadData2 = await uploadImage(image2).catchError((error) {});
    final uploadData3 = await uploadImage(image3).catchError((error) {});
    final uploadData4 = await uploadImage(image4).catchError((error) {});

    if (uploadData == null) {
      print('Upload failed');
      return false;
    }
    final num timeStamp = DateTime.now().millisecondsSinceEpoch;
    final Map<String, dynamic> accommodationData = {
      'title': title,
      'description': description,
      'price': price,
      'imagePath': uploadData['imagePath'],
      'imageUrl': uploadData['imageUrl'],
      //if no image is selected it will assign null and it won't be part of the uploaded data to the database
      'imagePath1': uploadData1 == null ? null : uploadData1['imagePath'],
      'imageUrl1': uploadData1 == null ? null : uploadData1['imageUrl'],
      'imagePath2': uploadData2 == null ? null : uploadData2['imagePath'],
      'imageUrl2': uploadData2 == null ? null : uploadData2['imageUrl'],
      'imagePath3': uploadData3 == null ? null : uploadData3['imagePath'],
      'imageUrl3': uploadData3 == null ? null : uploadData3['imageUrl'],
      'imagePath4': uploadData4 == null ? null : uploadData4['imagePath'],
      'imageUrl4': uploadData4 == null ? null : uploadData4['imageUrl'],
      //if no image is selected it will assign null and it won't be part of the uploaded data to the database
      'locationAddress': locationAddress,
      'loc_lat': 5.596962,
      'loc_lng': -0.223282,
      'userEmail': authenticatedUser.email,
      'userId': authenticatedUser.id,
      'timePosted': timeStamp
    };
    try {
      final http.Response response = await http.post(
          'https://........json', //firebase backend url /accommodation.json
          body: json.encode(accommodationData));

      //successful response codes are 200 and 201
      //checking if the post request is not successful
      if (response.statusCode != 200 && response.statusCode != 201) {
        loading = false;
        notifyListeners();
        return false; //if not successful
      }
      //will proceed if successful
      final Map<String, dynamic> responseData = json.decode(response.body);
      final Item newAccommodation = Item(
          id: responseData[
              'name'], //name, value provided by firebase //print(responseData);
          title: title,
          description: description,
          image: uploadData['imageUrl'],
          imagePath: uploadData['imagePath'],
          //
          image1: uploadData1 == null ? null : uploadData1['imageUrl'],
          imagePath1: uploadData1 == null ? null : uploadData1['imagePath'],
          image2: uploadData2 == null ? null : uploadData2['imageUrl'],
          imagePath2: uploadData2 == null ? null : uploadData2['imagePath'],
          image3: uploadData3 == null ? null : uploadData3['imageUrl'],
          imagePath3: uploadData3 == null ? null : uploadData3['imagePath'],
          image4: uploadData4 == null ? null : uploadData4['imageUrl'],
          imagePath4: uploadData4 == null ? null : uploadData4['imagePath'],
          //
          price: price,
          locationAddress: locationAddress,
          latitude: latitude,
          longitude: longitude,
          userEmail: authenticatedUser.email,
          userId: authenticatedUser.id,
          timeStamp: timeStamp);
      _accommodation.add(newAccommodation);
      loading = false;
      notifyListeners();
      return true; //if successful
    } catch (error) {
      loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateAccommodation(
      String title,
      String description,
      File image,
      File image1,
      File image2,
      File image3,
      File image4,
      String price,
      String locationAddress,
      double latitude,
      double longitude) async {
    try {
      loading = true;
      notifyListeners();
      String imageUrl = selectedAccommodation.image;
      String imagePath = selectedAccommodation.imagePath;
      //
      String imageUrl1 = selectedAccommodation.image1;
      String imagePath1 = selectedAccommodation.imagePath1;
      String imageUrl2 = selectedAccommodation.image2;
      String imagePath2 = selectedAccommodation.imagePath2;
      String imageUrl3 = selectedAccommodation.image3;
      String imagePath3 = selectedAccommodation.imagePath3;
      String imageUrl4 = selectedAccommodation.image4;
      String imagePath4 = selectedAccommodation.imagePath4;
      //
      if (image != null) {
        final uploadData = await uploadImage(image);

        imageUrl = uploadData['imageUrl'];
        imagePath = uploadData['imagePath'];
      }
      //
      if (image1 != null) {
        final uploadData1 = await uploadImage(image1).catchError((error) {});

        imageUrl1 = uploadData1['imageUrl'];
        imagePath1 = uploadData1['imagePath'];
      }
      if (image2 != null) {
        final uploadData2 = await uploadImage(image2).catchError((error) {});

        imageUrl2 = uploadData2['imageUrl'];
        imagePath2 = uploadData2['imagePath'];
      }
      if (image3 != null) {
        final uploadData3 = await uploadImage(image3).catchError((error) {});

        imageUrl3 = uploadData3['imageUrl'];
        imagePath3 = uploadData3['imagePath'];
      }
      if (image4 != null) {
        final uploadData4 = await uploadImage(image4).catchError((error) {});

        imageUrl4 = uploadData4['imageUrl'];
        imagePath4 = uploadData4['imagePath'];
      }
      //
     

      final Map<String, dynamic> updateData = {
        'title': title,
        'description': description,
        'price': price,
        'imageUrl': imageUrl,
        'imagePath': imagePath,
        //
        'imageUrl1': imageUrl1,
        'imagePath1': imagePath1,
        'imageUrl2': imageUrl2,
        'imagePath2': imagePath2,
        'imageUrl3': imageUrl3,
        'imagePath3': imagePath3,
        'imageUrl4': imageUrl4,
        'imagePath4': imagePath4,
        //
        'locationAddress': locationAddress,
        'loc_lat': 5.596962,
        'loc_lng': -0.223282,
        'userEmail': selectedAccommodation.userEmail,
        'userId': selectedAccommodation.userId,
        'timeStampPosted': selectedAccommodation.timeStamp
      };
      //put is used to update existing record
      try {
        await http.put(
            'https:/......./${selectedAccommodation.id}.json',
            body: json.encode(updateData));
        loading = false;
        final Item updatedAccommodation = Item(
            id: selectedAccommodation.id,
            title: title,
            description: description,
            image: imageUrl,
            imagePath: imagePath,
            //
            image1: imageUrl1,
            imagePath1: imagePath1,
            image2: imageUrl2,
            imagePath2: imagePath2,
            image3: imageUrl3,
            imagePath3: imagePath3,
            image4: imageUrl4,
            imagePath4: imagePath4,
            //
            price: price,
            locationAddress: locationAddress,
            latitude: latitude,
            longitude: longitude,
            userEmail: selectedAccommodation.userEmail,
            userId: selectedAccommodation.userId,
            timeStamp: selectedAccommodation.timeStamp);
        _accommodation[selectedAccommodationIndex] = updatedAccommodation;
        notifyListeners();
        return true; //if successful
      } catch (error) {
        loading = false;
        notifyListeners();
        return false; //if not successful
      }
    } catch (error) {
      return null;
    }
  }

  Future<bool> deleteAccommodation() {
    try {
      loading = true;
      String deletedAccommodationId = selectedAccommodation.id;
      _accommodation.removeAt(selectedAccommodationIndex);
      notifyListeners();
      selectedItemId = null; //no accommodation selected

      return http
          .delete(
              'https://......./$deletedAccommodationId.json')
          .then((http.Response response) {
        Fluttertoast.showToast(msg: "Accommodation Deleted");
        loading = false;
        notifyListeners();
        return true; //if successful
      }).catchError((error) {
        loading = false;
        notifyListeners();
        return false; //if not successful
      });
    } catch (error) {
      return null;
    }
  }

  Future<bool> deleteAccommodationImage(String imagepath) {
    try {
      return http
          .delete(
              'https:/......./${selectedAccommodation.id}/$imagepath.json')
          .then((http.Response response) {
        Fluttertoast.showToast(msg: "Image Deleted");

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

  //fetching data from the server
  Future<Null> fetchAccommodation() {
    loading = true;

    notifyListeners();
    return http
        .get('https://.......json')
        .then<Null>((http.Response response) {
      final List<Item> fetchedAccommodationList = [];
      final Map<String, dynamic> accommodationListData =
          json.decode(response.body);
      if (accommodationListData == null) {
        loading = false;
        notifyListeners();
        return;
      }
      accommodationListData
          .forEach((String accommodationId, dynamic accommodationData) {
        final Item accommodation = Item(
            id: accommodationId,
            title: accommodationData['title'],
            description: accommodationData['description'],
            image: accommodationData['imageUrl'],
            //
            image1: accommodationData['imageUrl1'],
            imagePath1: accommodationData['imagePath1'],
            image2: accommodationData['imageUrl2'],
            imagePath2: accommodationData['imagePath2'],
            image3: accommodationData['imageUrl3'],
            imagePath3: accommodationData['imagePath3'],
            image4: accommodationData['imageUrl4'],
            imagePath4: accommodationData['imagePath4'],
            //
            imagePath: accommodationData['imagePath'],
            price: accommodationData['price'],
            locationAddress: accommodationData['locationAddress'],
            latitude: accommodationData['latitude'],
            longitude: accommodationData['longitude'],
            userEmail: accommodationData['userEmail'],
            userId: accommodationData['userId'],
            timeStamp: accommodationData['timePosted'],
            isFavorite: accommodationData['wishlistUsers'] == null
                ? false
                : (accommodationData['wishlistUsers'] as Map<String, dynamic>)
                    .containsKey(authenticatedUser.id));
        fetchedAccommodationList.add(accommodation);
      });
      _accommodation = fetchedAccommodationList;
      loading = false;
      notifyListeners();
    }).catchError((error) {
      loading = false;
      notifyListeners();
      return;
    });
  }

  Future<Null> fetchAccommodationRefreshed() {
    return http
        .get('https:/........json')
        .then<Null>((http.Response response) {
      final List<Item> fetchedAccommodationList = [];
      final Map<String, dynamic> accommodationListData =
          json.decode(response.body);
      if (accommodationListData == null) {
        return;
      }
      accommodationListData
          .forEach((String accommodationId, dynamic accommodationData) {
        final Item accommodation = Item(
            id: accommodationId,
            title: accommodationData['title'],
            description: accommodationData['description'],
            image: accommodationData['imageUrl'],
            imagePath: accommodationData['imagePath'],
            //
            image1: accommodationData['imageUrl1'],
            imagePath1: accommodationData['imagePath1'],
            image2: accommodationData['imageUrl2'],
            imagePath2: accommodationData['imagePath2'],
            image3: accommodationData['imageUrl3'],
            imagePath3: accommodationData['imagePath3'],
            image4: accommodationData['imageUrl4'],
            imagePath4: accommodationData['imagePath4'],
            //
            price: accommodationData['price'],
            locationAddress: accommodationData['locationAddress'],
            latitude: accommodationData['latitude'],
            longitude: accommodationData['longitude'],
            userEmail: accommodationData['userEmail'],
            userId: accommodationData['userId'],
            timeStamp: accommodationData['timePosted'],
            isFavorite: accommodationData['wishlistUsers'] == null
                ? false
                : (accommodationData['wishlistUsers'] as Map<String, dynamic>)
                    .containsKey(authenticatedUser.id));
        fetchedAccommodationList.add(accommodation);
      });
      _accommodation = fetchedAccommodationList;
      notifyListeners();
    }).catchError((error) {
      return;
    });
  }

  void favoriteAccommodationStatus(Item toggledAccommodation) async {
    try {
      final bool isCurrentlyFavorite = toggledAccommodation.isFavorite;
      final bool newFavoriteStatus = !isCurrentlyFavorite;
      // Get the index of the accommodation passed into the method
      final int toggledAccommodationIndex =
          _accommodation.indexWhere((Item accommodation) {
        return accommodation.id == toggledAccommodation.id;
      });
      final Item updatedAccommodation = Item(
          id: toggledAccommodation.id,
          title: toggledAccommodation.title,
          description: toggledAccommodation.description,
          price: toggledAccommodation.price,
          image: toggledAccommodation.image,
          imagePath: toggledAccommodation.imagePath,
          //
          image1: toggledAccommodation.image1,
          imagePath1: toggledAccommodation.imagePath1,
          image2: toggledAccommodation.image2,
          imagePath2: toggledAccommodation.imagePath2,
          image3: toggledAccommodation.image3,
          imagePath3: toggledAccommodation.imagePath3,
          image4: toggledAccommodation.image4,
          imagePath4: toggledAccommodation.imagePath4,
          //
          locationAddress: toggledAccommodation.locationAddress,
          latitude: toggledAccommodation.latitude,
          longitude: toggledAccommodation.longitude,
          userEmail: toggledAccommodation.userEmail,
          userId: toggledAccommodation.userId,
          timeStamp: toggledAccommodation.timeStamp,
          isFavorite: newFavoriteStatus);
      _accommodation[toggledAccommodationIndex] = updatedAccommodation;
      notifyListeners(); //updates the state, re-renders the app visually
      http.Response response;
      if (newFavoriteStatus) {
        response = await http.put(
            'https://......./${toggledAccommodation.id}/wishlistUsers/${authenticatedUser.id}.json',
            body: json.encode(true));
      } else {
        response = await http.delete(
            'https:/.......${toggledAccommodation.id}/wishlistUsers/${authenticatedUser.id}.json');
      }
      if (response.statusCode != 200 && response.statusCode != 201) {
        final Item updatedAccommodation = Item(
            id: toggledAccommodation.id,
            title: toggledAccommodation.title,
            description: toggledAccommodation.description,
            price: toggledAccommodation.price,
            image: toggledAccommodation.image,
            imagePath: toggledAccommodation.imagePath,
            locationAddress: toggledAccommodation.locationAddress,
            latitude: toggledAccommodation.latitude,
            longitude: toggledAccommodation.longitude,
            userEmail: toggledAccommodation.userEmail,
            userId: toggledAccommodation.userId,
            timeStamp: toggledAccommodation.timeStamp,
            isFavorite: !newFavoriteStatus);
        _accommodation[toggledAccommodationIndex] = updatedAccommodation;
        notifyListeners(); //updates the state, re-renders the app visually

      }
    } catch (error) {}
  }

  void toggleAccommodationDisplayMode() {
    _showFavorite = !_showFavorite;
    notifyListeners();
  }
}
