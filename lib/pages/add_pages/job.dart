import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../scoped-models/main.dart';
import '../../models/item.dart';
import '../../widgets/form_inputs/image.dart';
import '../../main.dart';


import '../../widgets/ui_elements/platform_progress_indicator.dart';

class JobsAddPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _JobsAddPageState();
  }
}

class _JobsAddPageState extends State<JobsAddPage> {

  bool _autovalidate = false;
  final Map<String, dynamic> _formData = {
    'title': null,
    'description': null,
    'price': null,
    "image": null,
    "image1": null,
    "image2": null,
    "image3": null,
    "image4": null,
    'locationAddress': null,
    'latitude': 5.596962,
    'longitude': -0.223282,
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildTitleTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Job/Intenship Name/Position*",
      ),
      validator: (String value) {
        if (value.trim() == '' || value.isEmpty || value.length < 3) {
          return 'Title is required and should be 3 or more letters';
        }else if (value.length > 35) {
          return 'Title is too long, keep it short..The rest can be in the description';
        }
      },
      onSaved: (String value) {
        _formData['title'] = value;
      },
    );
  }

  Widget _buildDescriptionTextField() {
    return TextFormField(
      maxLines: 4,
      decoration: InputDecoration(
          labelText: "Description*",
          hintText: 'Tell  users more about the internship/job',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      validator: (String value) {
        if (value.trim() == '' || value.isEmpty || value.length < 10) {
          return 'Description is required and should be 10 or more characters';
        }
      },
      onSaved: (String value) {
        _formData['description'] = value;
      },
    );
  }

  Widget _buildPriceTextField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          labelText: "Salary*",
          hintText: " If the internship doesn't pay, type 0",
          prefixText: '\₵',
          suffixText: 'GH₵',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
      validator: (String value) {
        if (value.trim() == '' ||
            value.isEmpty ||
            !RegExp(r'^(?:[1-9]\d*|0)?(?:\.\d+)?$').hasMatch(value)) {
          return 'Price is required and should be a number';
        } else if (value.length > 15) {
          return 'Too Long, 1 trillion is even 13 digits';
          //trillion is 13 digits, so I have even been kind with 15
        }
      },
      onSaved: (String value) {
        _formData['price'] = value;
      },
    );
  }

  Widget _buildLocationAddressTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: "Address*",
          hintText: 'Location of the workplace',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
      validator: (String value) {
        if (value.trim() == '' || value.isEmpty || value.length < 3) {
          return 'No Valid Address';
        } else if (value.length > 20) {
          return 'Too Long';
        }
      },
      onSaved: (String value) {
        _formData['locationAddress'] = value;
      },
    );
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
                  _submitForm(
                      model.addJobs, model.selectItem, model.selectedJobIndex);
                  //closing the key board
                  FocusScope.of(context).requestFocus(FocusNode());
                });
      },
    );
  }

  Widget _buildPageContent(BuildContext context, Item job) {
    return GestureDetector(
      onTap: () {
        //closing the key board
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          autovalidate: _autovalidate,
          child: Column(
            children: <Widget>[
              _buildTitleTextField(),
              SizedBox(height: 30.0),
              _buildDescriptionTextField(),
              SizedBox(height: 30.0),
              _buildPriceTextField(),
              SizedBox(height: 30.0),
              _buildLocationAddressTextField(),
              SizedBox(height: 30.0),
              Text('Tap to select image'),
              SizedBox(height: 30.0),
              //Create a scrollable row
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: <Widget>[
                    Container(
                      child: Stack(
                        children: <Widget>[
                          ImageInput(_setImage, job),
                          Text('1*'),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Container(
                      child: Stack(
                        children: <Widget>[
                          ImageInput(_setImage1, job),
                          Text('2'),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Container(
                      child: Stack(
                        children: <Widget>[
                          ImageInput(_setImage2, job),
                          Text('3'),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Container(
                      child: Stack(
                        children: <Widget>[
                          ImageInput(_setImage3, job),
                          Text('4'),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Container(
                      child: Stack(
                        children: <Widget>[
                          ImageInput(_setImage4, job),
                          Text('5'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50.0),
              _buildSubmitButton(),
              SizedBox(
                height: 10.0,
              ),
              Text('* indicates required field',
                  style: Theme.of(context).textTheme.caption),
            ],
          ),
        ),
      ),
    );
  }

  void _setImage(File image) {
    _formData['image'] = image;
  }

  void _setImage1(File image1) {
    _formData['image1'] = image1;
  }

  void _setImage2(File image1) {
    _formData['image2'] = image1;
  }

  void _setImage3(File image1) {
    _formData['image3'] = image1;
  }

  void _setImage4(File image1) {
    _formData['image4'] = image1;
  }

  void _submitForm(Function addJob, Function setSelectedJob,
      [int selectedJobIndex]) {
    // [] optional argument

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
          });
    }

    //checking form validation
    //Don't save if form is not valid
    if (!_formKey.currentState.validate()) {
      myDialog('Form is not valid');
      _autovalidate = true;
      return; //Don't return //Do nothing

    }
    if (_formData['image'] == null) {
      myDialog('Please Add First Image');
      return; //Don't return //Do nothing
    }
    _formKey.currentState.save();
    //if (selectedProductIndex == -1) {
    //selectedProductIndex == -1 means no item selected
    addJob(
      _formData['title'],
      _formData['description'],
      _formData['image'],
      _formData['image1'],
      _formData['image2'],
      _formData['image3'],
      _formData['image4'],
      _formData['price'],
      _formData['locationAddress'],
      _formData['latitude'],
      _formData['longitude'],
    ).then(
      (bool success) {
        // navigate to the products page only when successful
        if (success) {
          // if success is true
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MyApp()),
          ).then((_) => setSelectedJob(null));
        } else {
          myDialog('Please try again');
        }
      },
    ).catchError((error) {});
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return _buildPageContent(context, model.selectedJob);
      },
    );
  }
}
