import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

import '../models/item.dart';
import './connected_items.dart';

mixin InternshipJobModel on ConnectedItemsModel {
  List<Item> _jobs = [];
  bool _showFavorite = false;

  List<Item> get allJobs {
    return List.from(_jobs
        .reversed); // .reversed, return data in the reversed order, from new to old.. default is old to new
  }

  List<Item> get displayFavoriteJobs {
    return _jobs.reversed.where((Item job) => job.isFavorite).toList();
  }

  List<Item> get userCreatedJobs {
    return _jobs.reversed.where((Item job) {
      return job.userId == authenticatedUser.id;
    }).toList();
  }

  int get selectedJobIndex {
    return _jobs.indexWhere((Item job) {
      return job.id == selectedItemId;
    });
  }

  String get selectedJobId {
    return selectedItemId;
  }

  Item get selectedJob {
    if (selectedJobId == null) {
      return null;
    }
    return _jobs.firstWhere((Item job) {
      return job.id == selectedItemId;
    });
  }

  Future<bool> addJobs(
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

    final Map<String, dynamic> jobData = {
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
          'https://flutter-buy.firebaseio.com/internshipJobs.json', //firebase backend url /job.json
          body: json.encode(jobData));

      //successful response codes are 200 and 201
      //checking if the post request is not successful
      if (response.statusCode != 200 && response.statusCode != 201) {
        loading = false;
        notifyListeners();
        return false; //if not successful
      }
      //will proceed if successful
      final Map<String, dynamic> responseData = json.decode(response.body);
      final Item newJob = Item(
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
      _jobs.add(newJob);
      loading = false;
      notifyListeners();
      return true; //if successful
    } catch (error) {
      loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateJob(
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
      String imageUrl = selectedJob.image;
      String imagePath = selectedJob.imagePath;
      //
      String imageUrl1 = selectedJob.image1;
      String imagePath1 = selectedJob.imagePath1;
      String imageUrl2 = selectedJob.image2;
      String imagePath2 = selectedJob.imagePath2;
      String imageUrl3 = selectedJob.image3;
      String imagePath3 = selectedJob.imagePath3;
      String imageUrl4 = selectedJob.image4;
      String imagePath4 = selectedJob.imagePath4;
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
        'userEmail': selectedJob.userEmail,
        'userId': selectedJob.userId,
        'timePosted': selectedJob.timeStamp
      };
      //put is used to update existing record
      try {
        await http.put(
            'https://flutter-buy.firebaseio.com/internshipJobs/${selectedJob.id}.json',
            body: json.encode(updateData));
        loading = false;
        final Item updateJob = Item(
            id: selectedJob.id,
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
            userEmail: selectedJob.userEmail,
            userId: selectedJob.userId,
            timeStamp: selectedJob.timeStamp);
        _jobs[selectedJobIndex] = updateJob;
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

  Future<bool> deleteJob() {
    try {
      loading = true;
      String deletedJobId = selectedJob.id;
      _jobs.removeAt(selectedJobIndex);
      notifyListeners();
      selectedItemId = null; //no job selected

      return http
          .delete(
              'https://flutter-buy.firebaseio.com/internshipJobs/$deletedJobId.json')
          .then((http.Response response) {
        Fluttertoast.showToast(msg: "Internship/Job Deleted");
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

  Future<bool> deleteJobImage(String imagepath) {
    try {
      return http
          .delete(
              'https://flutter-buy.firebaseio.com/internshipJobs/${selectedJob.id}/$imagepath.json')
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
  Future<Null> fetchJob() {
    loading = true;
    notifyListeners();
    return http
        .get('https://flutter-buy.firebaseio.com/internshipJobs.json')
        .then<Null>((http.Response response) {
      final List<Item> fetchedJobList = [];
      final Map<String, dynamic> jobListData = json.decode(response.body);
      if (jobListData == null) {
        loading = false;
        notifyListeners();
        return;
      }
      jobListData.forEach((String jobId, dynamic jobData) {
        final Item job = Item(
            id: jobId,
            title: jobData['title'],
            description: jobData['description'],
            image: jobData['imageUrl'],
            imagePath: jobData['imagePath'],
            //
            image1: jobData['imageUrl1'],
            imagePath1: jobData['imagePath1'],
            image2: jobData['imageUrl2'],
            imagePath2: jobData['imagePath2'],
            image3: jobData['imageUrl3'],
            imagePath3: jobData['imagePath3'],
            image4: jobData['imageUrl4'],
            imagePath4: jobData['imagePath4'],
            //
            price: jobData['price'],
            locationAddress: jobData['locationAddress'],
            latitude: jobData['latitude'],
            longitude: jobData['longitude'],
            userEmail: jobData['userEmail'],
            userId: jobData['userId'],
            timeStamp: jobData['timePosted'],
            isFavorite: jobData['wishlistUsers'] == null
                ? false
                : (jobData['wishlistUsers'] as Map<String, dynamic>)
                    .containsKey(authenticatedUser.id));
        fetchedJobList.add(job);
      });
      _jobs = fetchedJobList;
      loading = false;
      notifyListeners();
    }).catchError((error) {
      loading = false;
      notifyListeners();
      return;
    });
  }

  Future<Null> fetchJobRefreshed() {
    return http
        .get('https://flutter-buy.firebaseio.com/internshipJobs.json')
        .then<Null>((http.Response response) {
      final List<Item> fetchedJobList = [];
      final Map<String, dynamic> jobListData = json.decode(response.body);
      if (jobListData == null) {
        return;
      }
      jobListData.forEach((String jobId, dynamic jobData) {
        final Item job = Item(
            id: jobId,
            title: jobData['title'],
            description: jobData['description'],
            image: jobData['imageUrl'],
            imagePath: jobData['imagePath'],
            //
            image1: jobData['imageUrl1'],
            imagePath1: jobData['imagePath1'],
            image2: jobData['imageUrl2'],
            imagePath2: jobData['imagePath2'],
            image3: jobData['imageUrl3'],
            imagePath3: jobData['imagePath3'],
            image4: jobData['imageUrl4'],
            imagePath4: jobData['imagePath4'],
            //
            price: jobData['price'],
            locationAddress: jobData['locationAddress'],
            latitude: jobData['latitude'],
            longitude: jobData['longitude'],
            userEmail: jobData['userEmail'],
            userId: jobData['userId'],
            timeStamp: jobData['timePosted'],
            isFavorite: jobData['wishlistUsers'] == null
                ? false
                : (jobData['wishlistUsers'] as Map<String, dynamic>)
                    .containsKey(authenticatedUser.id));
        fetchedJobList.add(job);
      });
      _jobs = fetchedJobList;
      notifyListeners();
    }).catchError((error) {
      return;
    });
  }

  void favoriteJobStatus(Item toggledJob) async {
    try {
      final bool isCurrentlyFavorite = toggledJob.isFavorite;
      final bool newFavoriteStatus = !isCurrentlyFavorite;
      // Get the index of the job passed into the method
      final int toggledJobIndex = _jobs.indexWhere((Item job) {
        return job.id == toggledJob.id;
      });
      final Item updateJob = Item(
          id: toggledJob.id,
          title: toggledJob.title,
          description: toggledJob.description,
          price: toggledJob.price,
          image: toggledJob.image,
          imagePath: toggledJob.imagePath,
          //
          image1: toggledJob.image1,
          imagePath1: toggledJob.imagePath1,
          image2: toggledJob.image2,
          imagePath2: toggledJob.imagePath2,
          image3: toggledJob.image3,
          imagePath3: toggledJob.imagePath3,
          image4: toggledJob.image4,
          imagePath4: toggledJob.imagePath4,
          //
          locationAddress: toggledJob.locationAddress,
          latitude: toggledJob.latitude,
          longitude: toggledJob.longitude,
          userEmail: toggledJob.userEmail,
          userId: toggledJob.userId,
          timeStamp: toggledJob.timeStamp,
          isFavorite: newFavoriteStatus);
      _jobs[toggledJobIndex] = updateJob;
      notifyListeners(); //updates the state, re-renders the app visually
      http.Response response;
      if (newFavoriteStatus) {
        response = await http.put(
            'https://flutter-buy.firebaseio.com/internshipJobs/${toggledJob.id}/wishlistUsers/${authenticatedUser.id}.json',
            body: json.encode(true));
      } else {
        response = await http.delete(
            'https://flutter-buy.firebaseio.com/internshipJobs/${toggledJob.id}/wishlistUsers/${authenticatedUser.id}.json');
      }
      if (response.statusCode != 200 && response.statusCode != 201) {
        final Item updateJob = Item(
            id: toggledJob.id,
            title: toggledJob.title,
            description: toggledJob.description,
            price: toggledJob.price,
            image: toggledJob.image,
            imagePath: toggledJob.imagePath,
            locationAddress: toggledJob.locationAddress,
            latitude: toggledJob.latitude,
            longitude: toggledJob.longitude,
            userEmail: toggledJob.userEmail,
            userId: toggledJob.userId,
            timeStamp: toggledJob.timeStamp,
            isFavorite: !newFavoriteStatus);
        _jobs[toggledJobIndex] = updateJob;
        notifyListeners(); //updates the state, re-renders the app visually

      }
    } catch (error) {}
  }

  void toggleJobDisplayMode() {
    _showFavorite = !_showFavorite;
    notifyListeners();
  }
}
