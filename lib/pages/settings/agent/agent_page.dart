import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_mobile_vision/flutter_mobile_vision.dart';

import '../../../scoped-models/main.dart';
import '../../../widgets/ui_elements/platform_progress_indicator.dart';
import './agent_verification_pending.dart';

class AgentPage extends StatefulWidget {
  @override
  _AgentPageState createState() => _AgentPageState();
}

class _AgentPageState extends State<AgentPage> with TickerProviderStateMixin {
  bool _autovalidate = false;
  bool _durationAutoValidate = false;
  String _onCampusVal;
  File _frontPhoto;

  var isExpanded = false;
  _onExpansionChanged(bool val) {
    setState(() {
      isExpanded = val;
    });
  }

  AnimationController _controller;
  Animation<Offset> _slideAnimation;

  //OCR
  int _cameraOcr = FlutterMobileVision.CAMERA_BACK;
  bool _torchOcr = false;
  Size _previewOcr;
  List<OcrText> _textsOcr = [];
  File _backPhoto;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<Offset>(begin: Offset(0.0, -2.0), end: Offset.zero)
        .animate(
            CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn));
    //OCR
    FlutterMobileVision.start().then((previewSizes) => setState(() {
          _previewOcr = previewSizes[_cameraOcr].first;
        }));
    super.initState();
  }

  final Map<String, dynamic> _formData = {
    'university': null,
    'campusLocation': null,
    'name': null,
    'phoneNumber': null,
    "indexNumber": null,
    "programme": null,
    "currentLevel": null,
    "duration": null,
    "onCampus": null,
    'location': null,
    'frontPhoto': null,
    'backPhoto': null,
  };

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _locationFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _durationFormKey = GlobalKey<FormState>();
  static const menuItems = <String>[
    'Yes',
    'No',
  ];

  final List<DropdownMenuItem<String>> _dropDownMenuItems = menuItems
      .map(
        (String value) => DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            ),
      )
      .toList();

  Widget _buildUniversityTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "University*",
        hintText: "What's the name of your Tertiary Institution?",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      validator: (String value) {
        if (value.trim() == '' || value.length < 3 || value.isEmpty) {
          return 'Name of University is required and should be 3 or more letters';
        }
      },
      onSaved: (String value) {
        _formData['university'] = value;
      },
    );
  }

  Widget _buildCampusLocationTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "CampusLocation*",
        hintText: "Loaction of your university campus",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      validator: (String value) {
        if (value.trim() == '' || value.length < 3 || value.isEmpty) {
          return 'CampusLocation is required and should be 3 or more letters';
        }
      },
      onSaved: (String value) {
        _formData['campusLocation'] = value;
      },
    );
  }

  Widget _buildNameTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Name*",
        hintText: "What's your name?",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      validator: (String value) {
        if (value.trim() == '' || value.length < 3 || value.isEmpty) {
          return 'Your name  is required and should be 3 or more letters';
        }
      },
      onSaved: (String value) {
        _formData['name'] = value;
      },
    );
  }

  Widget _buildPhoneNumberTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Phone Number*",
        hintText: 'How can you be reached?',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
      keyboardType: TextInputType.phone,
      validator: (String value) {
        if (value.trim() == '' || value.length < 3 || value.isEmpty) {
          return 'Phone Number is required';
        }
      },
      onSaved: (String value) {
        _formData['phoneNumber'] = value;
      },
    );
  }

  Widget _buildIndexNumberTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Index Number*",
        hintText: "What's your Student ID number?",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      validator: (String value) {
        if (value.trim() == '' || value.length < 3 || value.isEmpty) {
          return 'Student ID is required';
        }
      },
      onSaved: (String value) {
        _formData['indexNumber'] = value;
      },
    );
  }

  Widget _buildProgrammeTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Programme*",
        hintText: "What Programme are you offering?",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      validator: (String value) {
        if (value.trim() == '' || value.length < 3 || value.isEmpty) {
          return 'Your Programme  is required and should be 3 or more letters';
        }
      },
      onSaved: (String value) {
        _formData['programme'] = value;
      },
    );
  }

  Widget _buildCurrentLevelTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Current Level*",
        hintText: "What level are u in now?",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      validator: (String value) {
        if (value.trim() == '' || value.length < 3 || value.isEmpty) {
          return 'Your Current Level  is required and should be 3 or more letters';
        }
      },
      onSaved: (String value) {
        _formData['currentLevel'] = value;
      },
    );
  }

  Widget _buildDurationTextField(OcrText ocrText) {
    return Form(
      key: _durationFormKey,
      autovalidate: _durationAutoValidate,
      child: TextFormField(
        initialValue: ocrText.value,
        decoration: InputDecoration(
          labelText: "Duration*",
          hintText: "The duration of your programme",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        validator: (String value) {
          if (value.trim() == '' || value.length < 20 || value.isEmpty) {
            return 'Your programme duration  is required, scan the back of your student\'s Id card';
          }
        },
        onSaved: (String value) {
          _formData['duration'] = value;
        },
      ),
    );
  }

  Widget _buildOnCampusDropdownButton() {
    return ListTile(
      title: Text('Are you onCampus?'),
      trailing: DropdownButton(
        value: _onCampusVal,
        hint: Text('Choose'),
        onChanged: ((String newValue) {
          setState(() {
            _onCampusVal = newValue;
          });
          if (_onCampusVal == 'No') {
            _controller.forward();
          } else {
            _controller.reverse();
          }
          _formData['onCampus'] = _onCampusVal;
        }),
        items: _dropDownMenuItems,
      ),
    );
  }

  Widget _buildLocationTextField() {
    return FadeTransition(
      opacity: CurvedAnimation(parent: _controller, curve: Curves.easeIn),
      child: SlideTransition(
        position: _slideAnimation,
        child: TextFormField(
          decoration: InputDecoration(
            labelText: "Location*",
            hintText: "Your location",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          validator: (String value) {
            if (value.trim() == '' || value.length < 3 || value.isEmpty) {
              return 'Location is required and should be 3 or more letters';
            }
          },
          onSaved: (String value) {
            if (_onCampusVal == 'Yes') {
              _formData['location'] = null;
            } else {
              _formData['location'] = value;
            }
          },
        ),
      ),
    );
  }

  Widget _buildFrontPhoto() {
    var _previewImage;
    if (_frontPhoto != null) {
      _previewImage = FileImage(
        _frontPhoto,
      );
    } else if (_frontPhoto == null) {
      _previewImage = AssetImage(
        'assets/placeholderimage.png',
      );
    }
    return GestureDetector(
      child: CircleAvatar(
        backgroundImage: _previewImage,
        radius: 65.0,
      ),
      onTap: () {
        ImagePicker.pickImage(source: ImageSource.camera).then(
          (File image) {
            setState(() {
              _frontPhoto = image;
            });
            _formData['frontPhoto'] = _frontPhoto;
          },
        ).catchError((error) {});
      },
    );
  }

  Widget _buildBackPhoto() {
    var _previewImage1;
    if (_backPhoto != null) {
      _previewImage1 = FileImage(
        _backPhoto,
      );
    } else if (_backPhoto == null) {
      _previewImage1 = AssetImage(
        'assets/placeholderimage.png',
      );
    }
    return GestureDetector(
      child: CircleAvatar(
        backgroundImage: _previewImage1,
        radius: 65.0,
      ),
      onTap: () {
        _read();
      },
    );
  }

  ///
  /// OCR Screen
  ///
  Widget _getOcrScreen(BuildContext context) {
    List<Widget> items = [];

    items.add(Text(
      "Take a picture of the back of your student's Id card and scan and tap the top part next",
      textAlign: TextAlign.center,
    ));
    items.add(SizedBox(height: 10));
    //torch
    items.add(new SwitchListTile(
      title: const Text('Torch:'),
      value: _torchOcr,
      onChanged: (bool value) => setState(() => _torchOcr = value),
    ));
    items.add(SizedBox(height: 10));
    //
    items.add(Text('Tap on circle image to start'));
    items.add(SizedBox(height: 10));
    //ocr scan and _backPhoto
    items.add(_buildBackPhoto());
    items.add(SizedBox(height: 20));
    items.addAll(
      ListTile.divideTiles(
        context: context,
        tiles: _textsOcr
            .map(
              (ocrText) => _buildDurationTextField(ocrText),
            )
            .toList(),
      ),
    );

    return Column(
      children: items,
    );
  }

  ///
  /// OCR Method
  ///
  Future<Null> _read() async {
    List<OcrText> texts;
    File image;
    try {
      image = await ImagePicker.pickImage(source: ImageSource.camera);
      texts = await FlutterMobileVision.read(
        flash: _torchOcr,
        autoFocus: true,
        multiple: false,
        waitTap: true,
        showText: true,
        preview: _previewOcr,
        camera: _cameraOcr,
        fps: 2.0,
      );
    } on Exception {
      texts.add(new OcrText('Failed to recognize text.'));
    }

    if (!mounted) return;

    setState(() {
      _backPhoto = image;
      _textsOcr = texts;
    });
    _formData['backPhoto'] = _backPhoto;
  }

  Widget _buildSubmitButton() {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return model.isLoading
            ? Center(
                child: PlatformProgressIndicator(),
              )
            : RaisedButton(
                elevation: 8,
                shape: StadiumBorder(),
                child: Text("Save"),
                color: Theme.of(context).accentColor,
                textColor: Colors.white,
                onPressed: () {
                  _submitForm(model.addAgent);
                  //closing the key board

                  FocusScope.of(context).requestFocus(FocusNode());
                });
      },
    );
  }

  void myDialog(String _content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ooops, Something went wrong'),
          content: Text(_content),
          actions: <Widget>[
            FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Okay'))
          ],
        );
      },
    );
  }

  Widget mainPage(
    BuildContext context,
  ) {
    return Container(
      child: GestureDetector(
        onTap: () {
          //closing the key board
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: 20),
              SizedBox(height: 20),
              Card(
                elevation: 7,
                child: ExpansionTile(
                  title: Text('Accept Terms'),
                  onExpansionChanged: _onExpansionChanged,
                  trailing: IgnorePointer(
                    child: Switch(
                      value: isExpanded,
                      onChanged: (_) {},
                      activeColor: Colors.blue,
                    ),
                  ),
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        children: <Widget>[
                          Form(
                            key: _formKey,
                            autovalidate: _autovalidate,
                            child: Column(
                              children: <Widget>[
                                SizedBox(height: 10.0),
                                _buildUniversityTextField(),
                                SizedBox(height: 10.0),
                                _buildCampusLocationTextField(),
                                SizedBox(height: 10.0),
                                _buildNameTextField(),
                                SizedBox(height: 10.0),
                                _buildPhoneNumberTextField(),
                                SizedBox(height: 10.0),
                                _buildIndexNumberTextField(),
                                SizedBox(height: 10.0),
                                _buildProgrammeTextField(),
                                SizedBox(height: 10.0),
                                _buildCurrentLevelTextField(),
                                SizedBox(height: 10.0),
                                _buildOnCampusDropdownButton(),
                              ],
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Form(
                            key: _locationFormKey,
                            autovalidate: _autovalidate,
                            child: _buildLocationTextField(),
                          ),
                          SizedBox(height: 5.0),
                          Text(
                            "Tap on circle image to take a picture of the front of your student's Id card",
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 10.0),
                          _buildFrontPhoto(),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Card(
                      elevation: 7,
                      child: ExpansionTile(
                        title: Text('Next'),
                        onExpansionChanged: nextButtonPressed,
                        children: <Widget>[
                          Container(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                children: <Widget>[
                                  SizedBox(height: 10.0),
                                  _getOcrScreen(context),
                                  SizedBox(height: 10.0),
                                  _buildSubmitButton()
                                ],
                              ))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  nextButtonPressed(bool val) {
    if (!_formKey.currentState.validate()) {
      myDialog('Form is not valid');
      _autovalidate = true;
      return; //Don't return //Do nothing
    } else if (_onCampusVal == 'No' &&
        !_locationFormKey.currentState.validate()) {
      myDialog('Form is not valid');
      _autovalidate = true;
      return; //Don't return //Do nothing
    } else if (_onCampusVal == null) {
      myDialog('Please Select if you are on campus or not');
      return; //Don't return //Do nothing
    } else if (_formData['frontPhoto'] == null) {
      myDialog('Please Add front Image');
      return; //Don't return //Do nothing
    } else {
      setState(() {
        isExpanded = val;
      });
    }
  }

  void _submitForm(Function addAgent) {
    //checking form validation
    //Don't save if form is not valid
    if (!_formKey.currentState.validate()) {
      myDialog('Form is not valid');
      _autovalidate = true;
      return; //Don't return //Do nothing
    }

    if (_onCampusVal == 'No' && !_locationFormKey.currentState.validate()) {
      myDialog('Form is not valid');
      _autovalidate = true;
      return; //Don't return //Do nothing
    }

    if (!_durationFormKey.currentState.validate()) {
      myDialog('Form is not valid');
      _durationAutoValidate = true;
      return; //Don't return //Do nothing
    }

    if (_onCampusVal == null) {
      myDialog('Please Select if you are on campus or not');
      return; //Don't return //Do nothing
    }

    if (_formData['frontPhoto'] == null) {
      myDialog('Please Add front Image');
      return; //Don't return //Do nothing
    }

    if (_formData['backPhoto'] == null) {
      myDialog('Please Add back Image');
      return; //Don't return //Do nothing
    }

    _formKey.currentState.save();
    _locationFormKey.currentState.save();
    _durationFormKey.currentState.save();

    addAgent(
      _formData['university'],
      _formData['campusLocation'],
      _formData['name'],
      _formData['phoneNumber'],
      _formData['indexNumber'],
      _formData['programme'],
      _formData['currentLevel'],
      _formData['duration'],
      _formData['onCampus'],
      _formData['location'],
      _formData['frontPhoto'],
      _formData['backPhoto'],
    ).then(
      (bool success) {
        // navigate to the products page only when successful
        if (success) {
          // if success is true
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => VerificationPending()),
          );
        } else {
          myDialog('Please try again');
        }
      },
    ).catchError((error) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Become An Agent'),
        ),
        body: mainPage(context));
  }
}
