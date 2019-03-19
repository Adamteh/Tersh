import 'dart:io';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/agent.dart';
import '../../scoped-models/main.dart';
import '../../widgets/ui_elements/platform_progress_indicator.dart';
import './agent/agent_page.dart';
import './agent/agent_verification_pending.dart';
import './agent/verified_agent.dart';


class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

class SettingsPage extends StatefulWidget {
  final Agent agent;
  SettingsPage(this.agent);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _autoValidate = false;

  List<Choice> choices = const <Choice>[
    const Choice(title: 'Become An Agent', icon: Icons.people),
    const Choice(title: 'Customize', icon: Icons.center_focus_strong),
  ];

  onItemMenuPress(Choice choice) {

    if (choice.title == 'Become An Agent') {
      if (widget.agent == null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AgentPage(),
          ),
        );
      } else if (widget.agent.verified == 'No') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerificationPending(),
          ),
        );
      } else if (widget.agent.verified == 'Yes') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerifiedAgent(),
          ),
        );
      }
    } else {}
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Map<String, dynamic> _formData = {
    'userName': null,
    'userPhoto': null,
    'phoneNumber': null
  };

  File _imageFile;

  _getImage(BuildContext context, ImageSource source) {
    ImagePicker.pickImage(source: source).then(
      (File image) {
        setState(() {
          _imageFile = image;
        });
        _formData['userPhoto'] = _imageFile;
        Navigator.pop(context);
      },
    ).catchError((error) {});
  }

  //final TextEditingController _userNameController = TextEditingController();

  void _openImagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ScopedModelDescendant<MainModel>(
            builder: (BuildContext context, Widget child, MainModel model) {
          return Container(
            height: 120.0,
            padding: EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton(
                    textColor: Theme.of(context).primaryColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.camera,
                          size: 30.0,
                          color: Colors.green,
                        ),
                        Text('Camera', style: TextStyle(color: Colors.black))
                      ],
                    ),
                    onPressed: () {
                      _getImage(context, ImageSource.camera);
                      Navigator.pop(context); //closing the modelbottomsheet
                    }),
                FlatButton(
                  textColor: Theme.of(context).primaryColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.image,
                        size: 30.0,
                      ),
                      Text('Gallery', style: TextStyle(color: Colors.black))
                    ],
                  ),
                  onPressed: () {
                    _getImage(context, ImageSource.gallery);
                    Navigator.pop(context);
                  },
                ),
                _imageFile != null || model.userPhoto != null
                    ? FlatButton(
                        textColor: Theme.of(context).primaryColor,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.delete_forever,
                              size: 30.0,
                              color: Colors.red,
                            ),
                            Text(
                              'Delete',
                              style: TextStyle(color: Colors.black),
                            )
                          ],
                        ),
                        onPressed: () {
                          model.deleteUserPhoto();
                          Navigator.pop(context);
                          setState(() {
                            _imageFile = null;
                          });
                        },
                      )
                    : Container(),
              ],
            ),
          );
        });
      },
    ).catchError((error) {});
  }

  Widget _buildUserPhoto() {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        var profileImage;
        if (_imageFile != null) {
          //check if there is a picked image
          profileImage = FileImage(_imageFile);
        } else if (model.userPhoto != null) {
          profileImage = NetworkImage(model.userPhoto.userPhotoUrl);
        } else {
          profileImage = AssetImage('assets/person-placeholder-portrait.png');
        }

        return Center(
          child: Stack(
            alignment: const Alignment(1, 1),
            children: <Widget>[
              CircleAvatar(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white12,
                radius: 150.0,
                backgroundImage: profileImage,
              ),
              GestureDetector(
                child: Icon(
                  Icons.add_a_photo,
                  size: 50,
                ),
                onTap: () {
                  _openImagePicker(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUserNameTextField() {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return TextFormField(
          decoration: InputDecoration(
              labelText: 'UserName',
              hintText: 'Display Name',
              icon: Icon(Icons.person),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              )),
          initialValue: model.iUser == null ? '' : model.iUser.userName,
          validator: (String value) {
            if (value.trim() == '' || value.length < 2) {
              return 'UserName is required and must be 2 or more letters';
            }else if(value.length > 20){
                return 'Too long';
            }
          },
          onSaved: (String value) {
            _formData['userName'] = value;
          },
        );
      },
    );
  }

  // Widget _buildPhoneNumberTextField() {
  //   return ScopedModelDescendant<MainModel>(
  //     builder: (BuildContext context, Widget child, MainModel model) {
  //       return TextFormField(
  //         decoration: InputDecoration(
  //             labelText: 'Phone Number',
  //             hintText: 'Where can you be reached?',
  //             icon: Icon(Icons.phone),
  //             border: OutlineInputBorder()),
  //         initialValue:
  //             model.iUser.phoneNumber == null ? '' : model.iUser.phoneNumber,
  //         inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
  //         keyboardType: TextInputType.number,
  //         onSaved: (String value) {
  //           // _formData['userName'] = value;
  //         },
  //       );
  //     },
  //   );
  // }

  void _submitForm(Function updateUser, Function addUserPhoto) {
    if (!_formKey.currentState.validate()) {
      _autoValidate = true;
      return; //Don't return //Do nothing

    }

    _formKey.currentState.save();
    updateUser(_formData['userName']).catchError(
      (error) {},
    );

    if (_imageFile != null) {
      addUserPhoto(_formData['userPhoto']).catchError(
        (error) {},
      );
    }
  }

  Widget _buildUpdateButton() {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return model.isLoading
            ? Center(
                child: PlatformProgressIndicator(),
              )
            : Center(
                child: RaisedButton(
                  elevation: 8,
                  shape: StadiumBorder(),
                  child: Text("UPDATE"),
                  color: Theme.of(context).accentColor,
                  textColor: Colors.white,
                  onPressed: () {
                    _submitForm(model.updateUser, model.addUserPhoto);
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
                ),
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: onItemMenuPress,
            itemBuilder: (BuildContext context) {
              return choices.map((dynamic choice) {
                return PopupMenuItem<Choice>(
                  value: choice,
                  child: Row(
                    children: <Widget>[
                      Icon(
                        choice.icon,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        choice.title,
                      ),
                    ],
                  ),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          //closing the key board
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          margin: EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            autovalidate: _autoValidate,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: targetPadding / 2),
              children: <Widget>[
                _buildUserPhoto(),
                SizedBox(height: 25.0),
                _buildUserNameTextField(),
                // SizedBox(height: 25.0),
                // _buildPhoneNumberTextField(),
                SizedBox(
                  height: 20.0,
                ),
                _buildUpdateButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
