import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/agent.dart';
import './connected_items.dart';

mixin AgentModel on ConnectedItemsModel {
  Agent agent;
  List<Agent> _agents = [];

  List<Agent> get allAgents {
    return List.from(_agents);
  }

  List<Agent> get iAmAnAgent {
    return _agents.where((Agent _agent) {
      return _agent.id == authenticatedUser.id;
    }).toList();
  }



  Future<Map<String, dynamic>> uploadAgentImage(File image,
      {String imagePath}) async {
    final mimeTypeData = lookupMimeType(image.path).split('/');
    final imageUploadRequest = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://us-central1-flutter-buy.cloudfunctions.net/storeAgentImage'));
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

  Future<bool> addAgent(
    String university,
    String campusLocation,
    String name,
    String phoneNumber,
    String indexNumber,
    String programme,
    String currentLevel,
    String duration,
    String onCampus,
    String location,
    File frontPhoto,
    File backPhoto,
  ) async {
    loading = true;
    notifyListeners();
    final uploadData = await uploadAgentImage(frontPhoto);
    final uploadData1 = await uploadAgentImage(backPhoto);

    final String verified = 'No';

    if (uploadData == null) {
      print('Upload failed');
      return false;
    }

    final Map<String, dynamic> agentData = {
      'university': university,
      'campusLocation': campusLocation,
      'name': name,
      'phoneNumber': phoneNumber,
      'indexnumber': indexNumber,
      'programme': programme,
      'currentLevel': currentLevel,
      'duration': duration,
      'onCampus': onCampus,
      'location': location,
      'frontPhotoPath': uploadData['imagePath'],
      'frontPhotoUrl': uploadData['imageUrl'],
      'backPhotoPath': uploadData1['imagePath'],
      'backPhotoUrl': uploadData1['imageUrl'],
      'verified': verified
    };

    try {
      final http.Response response = await http.put(
          'https://flutter-buy.firebaseio.com/Agents/${authenticatedUser.id}.json', //firebase backend url /products.json
          body: json.encode(agentData));

      //successful response codes are 200 and 201
      //checking if the post request is not successful
      if (response.statusCode != 200 && response.statusCode != 201) {
        loading = false;
        notifyListeners();
        return false; //if not successful
      }
      //will proceed if successful
      final Agent newAgent = Agent(
          university: university,
          campusLocation: campusLocation,
          name: name,
          phoneNumber: phoneNumber,
          indexNumber: indexNumber,
          programme: programme,
          currentLevel: currentLevel,
          duration: duration,
          onCampus: onCampus,
          location: location,
          frontPhotoPath: uploadData['imagePath'],
          frontPhotoUrl: uploadData['imageUrl'],
          backPhotoPath: uploadData1['imagePath'],
          backPhotoUrl: uploadData1['imageUrl'],
          verified: verified);
      agent = newAgent;
      loading = false;
      Fluttertoast.showToast(msg: "Record Sent Successfully");
      notifyListeners();
      return true; //if successful
    } catch (error) {
      return false;
    }
  }

  Future<Null> fetchAgent() {
    return http
        .get(
            'https://flutter-buy.firebaseio.com/Agents/${authenticatedUser.id}/.json')
        .then<Null>((http.Response response) {
      Agent fetchedAgentData;
      final Map<String, dynamic> _agentData = json.decode(response.body);
      //print(_agentListData);
      if (_agentData == null) {
        return;
      }
      _agentData.forEach((String k, dynamic agentData) {
        final Agent _agent = Agent(
          verified: agentData,
        );
        fetchedAgentData = _agent;
      });
      agent = fetchedAgentData;
    }).catchError((error) {
      return;
    });
  }

  Future<Null> fetchAgents() {
    return http
        .get('https://flutter-buy.firebaseio.com/Agents/.json')
        .then<Null>((http.Response response) {
      final List<Agent> fetchedAgentData = [];
      final Map<String, dynamic> _agentsListData = json.decode(response.body);
      //print(_agentListData);
      if (_agentsListData == null) {
        return;
      }
      _agentsListData.forEach((String userId, dynamic agentData) {
        final Agent _agent = Agent(
          id: userId,
          university: agentData['university'],
          campusLocation: agentData['campusLocation'],
          name: agentData['name'],
          phoneNumber: agentData['phoneNumber'],
          indexNumber: agentData['indexnumber'],
          programme: agentData['programme'],
          currentLevel: agentData['currentLevel'],
          duration: agentData['duration'],
          onCampus: agentData['onCampus'],
          location: agentData['location'],
          frontPhotoPath: agentData['frontPhotoPath'],
          frontPhotoUrl: agentData['frontPhotoUrl'],
          backPhotoPath: agentData['backPhotoPath'],
          backPhotoUrl: agentData['backPhotoUrl'],
          verified: agentData['verified'],
        );
        fetchedAgentData.add(_agent);
      });
      _agents = fetchedAgentData;
    }).catchError((error) {
      return;
    });
  }
}
