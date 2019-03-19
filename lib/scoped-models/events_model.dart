import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

import '../models/item.dart';
import './connected_items.dart';

mixin EventsModel on ConnectedItemsModel {
  List<Item> _events = [];
  bool _showFavorite = false;

  List<Item> get allEvents {
    return List.from(_events
        .reversed); // .reversed, return data in the reversed order, from new to old.. default is old to new
  }

  List<Item> get displayFavoriteEvent {
    return _events.reversed.where((Item events) => events.isFavorite).toList();
  }

  List<Item> get userCreatedEvent {
    return _events.reversed.where((Item events) {
      return events.userId == authenticatedUser.id;
    }).toList();
  }

  int get selectedEventsIndex {
    return _events.indexWhere((Item events) {
      return events.id == selectedItemId;
    });
  }

  String get selectedEventsId {
    return selectedItemId;
  }

  Item get selectedEvent {
    if (selectedEventsId == null) {
      return null;
    }
    return _events.firstWhere((Item events) {
      return events.id == selectedItemId;
    });
  }

  Future<bool> addEvent(
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
    final Map<String, dynamic> eventsData = {
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
          'https://flutter-buy.firebaseio.com/events.json', //firebase backend url /events.json
          body: json.encode(eventsData));

      //successful response codes are 200 and 201
      //checking if the post request is not successful
      if (response.statusCode != 200 && response.statusCode != 201) {
        loading = false;
        notifyListeners();
        return false; //if not successful
      }
      //will proceed if successful
      final Map<String, dynamic> responseData = json.decode(response.body);
      final Item newEvent = Item(
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
      _events.add(newEvent);
      loading = false;
      notifyListeners();
      return true; //if successful
    } catch (error) {
      loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateEvent(
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
      String imageUrl = selectedEvent.image;
      String imagePath = selectedEvent.imagePath;
      //
      String imageUrl1 = selectedEvent.image1;
      String imagePath1 = selectedEvent.imagePath1;
      String imageUrl2 = selectedEvent.image2;
      String imagePath2 = selectedEvent.imagePath2;
      String imageUrl3 = selectedEvent.image3;
      String imagePath3 = selectedEvent.imagePath3;
      String imageUrl4 = selectedEvent.image4;
      String imagePath4 = selectedEvent.imagePath4;
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
        'userEmail': selectedEvent.userEmail,
        'userId': selectedEvent.userId,
        'timePosted': selectedEvent.timeStamp
      };
      //put is used to update existing record
      try {
        await http.put(
            'https://flutter-buy.firebaseio.com/events/${selectedEvent.id}.json',
            body: json.encode(updateData));
        loading = false;
        final Item updatedEvent = Item(
            id: selectedEvent.id,
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
            userEmail: selectedEvent.userEmail,
            userId: selectedEvent.userId,
            timeStamp: selectedEvent.timeStamp);
        _events[selectedEventsIndex] = updatedEvent;
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

  Future<bool> deleteEvent() {
    try {
      loading = true;
      String deletedEventId = selectedEvent.id;
      _events.removeAt(selectedEventsIndex);
      notifyListeners();
      selectedItemId = null; //no events selected

      return http
          .delete(
              'https://flutter-buy.firebaseio.com/events/$deletedEventId.json')
          .then((http.Response response) {
        Fluttertoast.showToast(msg: "Event Deleted");
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

  Future<bool> deleteEventImage(String imagepath) {
    try {
      return http
          .delete(
              'https://flutter-buy.firebaseio.com/events/${selectedEvent.id}/$imagepath.json')
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
  Future<Null> fetchEvent() {
    loading = true;
    notifyListeners();
    return http
        .get('https://flutter-buy.firebaseio.com/events.json')
        .then<Null>((http.Response response) {
      final List<Item> fetchedEventList = [];
      final Map<String, dynamic> eventsListData = json.decode(response.body);
      if (eventsListData == null) {
        loading = false;
        notifyListeners();
        return;
      }
      eventsListData.forEach((String eventsId, dynamic eventsData) {
        final Item events = Item(
            id: eventsId,
            title: eventsData['title'],
            description: eventsData['description'],
            image: eventsData['imageUrl'],
            imagePath: eventsData['imagePath'],
            //
            image1: eventsData['imageUrl1'],
            imagePath1: eventsData['imagePath1'],
            image2: eventsData['imageUrl2'],
            imagePath2: eventsData['imagePath2'],
            image3: eventsData['imageUrl3'],
            imagePath3: eventsData['imagePath3'],
            image4: eventsData['imageUrl4'],
            imagePath4: eventsData['imagePath4'],
            //
            price: eventsData['price'],
            locationAddress: eventsData['locationAddress'],
            latitude: eventsData['latitude'],
            longitude: eventsData['longitude'],
            userEmail: eventsData['userEmail'],
            userId: eventsData['userId'],
            timeStamp: eventsData['timePosted'],
            isFavorite: eventsData['wishlistUsers'] == null
                ? false
                : (eventsData['wishlistUsers'] as Map<String, dynamic>)
                    .containsKey(authenticatedUser.id));
        fetchedEventList.add(events);
      });
      _events = fetchedEventList;
      loading = false;
      notifyListeners();
    }).catchError((error) {
      loading = false;
      notifyListeners();
      return;
    });
  }

  Future<Null> fetchEventRefreshed() {
    return http
        .get('https://flutter-buy.firebaseio.com/events.json')
        .then<Null>((http.Response response) {
      final List<Item> fetchedEventList = [];
      final Map<String, dynamic> eventsListData = json.decode(response.body);
      if (eventsListData == null) {
        return;
      }
      eventsListData.forEach((String eventsId, dynamic eventsData) {
        final Item events = Item(
            id: eventsId,
            title: eventsData['title'],
            description: eventsData['description'],
            image: eventsData['imageUrl'],
            imagePath: eventsData['imagePath'],
            //
            image1: eventsData['imageUrl1'],
            imagePath1: eventsData['imagePath1'],
            image2: eventsData['imageUrl2'],
            imagePath2: eventsData['imagePath2'],
            image3: eventsData['imageUrl3'],
            imagePath3: eventsData['imagePath3'],
            image4: eventsData['imageUrl4'],
            imagePath4: eventsData['imagePath4'],
            //
            price: eventsData['price'],
            locationAddress: eventsData['locationAddress'],
            latitude: eventsData['latitude'],
            longitude: eventsData['longitude'],
            userEmail: eventsData['userEmail'],
            userId: eventsData['userId'],
            timeStamp: eventsData['timePosted'],
            isFavorite: eventsData['wishlistUsers'] == null
                ? false
                : (eventsData['wishlistUsers'] as Map<String, dynamic>)
                    .containsKey(authenticatedUser.id));
        fetchedEventList.add(events);
      });
      _events = fetchedEventList;
      notifyListeners();
    }).catchError((error) {
      return;
    });
  }

  void favoriteEventStatus(Item toggledEvent) async {
    try {
      final bool isCurrentlyFavorite = toggledEvent.isFavorite;
      final bool newFavoriteStatus = !isCurrentlyFavorite;
      // Get the index of the events passed into the method
      final int toggledEventIndex = _events.indexWhere((Item events) {
        return events.id == toggledEvent.id;
      });
      final Item updatedEvent = Item(
          id: toggledEvent.id,
          title: toggledEvent.title,
          description: toggledEvent.description,
          price: toggledEvent.price,
          image: toggledEvent.image,
          imagePath: toggledEvent.imagePath,
          //
          image1: toggledEvent.image1,
          imagePath1: toggledEvent.imagePath1,
          image2: toggledEvent.image2,
          imagePath2: toggledEvent.imagePath2,
          image3: toggledEvent.image3,
          imagePath3: toggledEvent.imagePath3,
          image4: toggledEvent.image4,
          imagePath4: toggledEvent.imagePath4,
          //
          locationAddress: toggledEvent.locationAddress,
          latitude: toggledEvent.latitude,
          longitude: toggledEvent.longitude,
          userEmail: toggledEvent.userEmail,
          userId: toggledEvent.userId,
          timeStamp: toggledEvent.timeStamp,
          isFavorite: newFavoriteStatus);
      _events[toggledEventIndex] = updatedEvent;
      notifyListeners(); //updates the state, re-renders the app visually
      http.Response response;
      if (newFavoriteStatus) {
        response = await http.put(
            'https://flutter-buy.firebaseio.com/events/${toggledEvent.id}/wishlistUsers/${authenticatedUser.id}.json',
            body: json.encode(true));
      } else {
        response = await http.delete(
            'https://flutter-buy.firebaseio.com/events/${toggledEvent.id}/wishlistUsers/${authenticatedUser.id}.json');
      }
      if (response.statusCode != 200 && response.statusCode != 201) {
        final Item updatedEvent = Item(
            id: toggledEvent.id,
            title: toggledEvent.title,
            description: toggledEvent.description,
            price: toggledEvent.price,
            image: toggledEvent.image,
            imagePath: toggledEvent.imagePath,
            locationAddress: toggledEvent.locationAddress,
            latitude: toggledEvent.latitude,
            longitude: toggledEvent.longitude,
            userEmail: toggledEvent.userEmail,
            userId: toggledEvent.userId,
            timeStamp: toggledEvent.timeStamp,
            isFavorite: !newFavoriteStatus);
        _events[toggledEventIndex] = updatedEvent;
        notifyListeners(); //updates the state, re-renders the app visually

      }
    } catch (error) {}
  }

  void toggleEventDisplayMode() {
    _showFavorite = !_showFavorite;
    notifyListeners();
  }
}
