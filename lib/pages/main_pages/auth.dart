import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../scoped-models/main.dart';
import '../../models/auth.dart';
import '../../main.dart';

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage> with TickerProviderStateMixin {
  bool _obscurePasswordText = true;
  bool _autovalidate = false;

  final Map<String, dynamic> _formData = {
    'userName': null,
    'email': null,
    'password': null,
    'acceptTerms': false
  };

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _userNameClearController =
      TextEditingController();
  final TextEditingController _emailClearController = TextEditingController();
  final TextEditingController _passwordClearController =
      TextEditingController();

  AuthMode _authMode = AuthMode.Login;
  AnimationController _controller;
  Animation<Offset> _slideAnimation;
  Animation<Offset> _userNameSlideAnimation;

  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<Offset>(begin: Offset(0.0, -2.0), end: Offset.zero)
        .animate(
            CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn));
    _userNameSlideAnimation =
        Tween<Offset>(begin: Offset(0.0, 2.0), end: Offset.zero).animate(
            CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn));
    super.initState();
  }

  DecorationImage _buildBackgroundImage() {
    return DecorationImage(
      fit: BoxFit.cover,
      colorFilter:
          ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.dstATop),
      image: AssetImage('assets/bg2.jpg'),
    );
  }

  Widget _buildUserNameTextField() {
    return FadeTransition(
      opacity: CurvedAnimation(parent: _controller, curve: Curves.easeIn),
      child: SlideTransition(
        position: _userNameSlideAnimation,
        child: TextFormField(
          style: TextStyle(color: Colors.black),
          decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              labelText: 'UserName',
              filled: true,
              hintText: 'What name do you want people to see?',
              icon: Icon(Icons.person, color: Colors.black)),
          controller: _userNameClearController,
          validator: (String value) {
            if ((value.trim() == '' || value.length < 2) &&
                _authMode == AuthMode.Signup) {
              return 'UserName is required and must be 2 or more letters';
            }else if(value.length > 20){
                return 'Too long';
            }
          },
          onSaved: (String value) {
            _formData['userName'] = value;
          },
        ),
      ),
    );
  }

  Widget _buildEmailTextField() {
    return TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        labelText: 'E-Mail',
        filled: true,
        icon: Icon(Icons.email, color: Colors.black),
        hintText: 'eg. tresh@gmail.com',
      ),
      keyboardType: TextInputType.emailAddress,
      controller: _emailClearController,
      validator: (String value) {
        if (value.isEmpty ||
            !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                .hasMatch(value)) {
          return 'Please enter a valid email';
        }
      },
      onSaved: (String value) {
        _formData['email'] = value;
      },
    );
  }

  Widget _buildPasswordTextField() {
    return TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        labelText: 'Password',
        filled: true,
        icon: Icon(Icons.security, color: Colors.black),
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              _obscurePasswordText = !_obscurePasswordText;
            });
          },
          child: Icon(
            _obscurePasswordText ? Icons.visibility : Icons.visibility_off,
            semanticLabel:
                _obscurePasswordText ? 'show password' : 'hide password',
          ),
        ),
      ),
      obscureText: _obscurePasswordText,
      controller: _passwordTextController,
      validator: (String value) {
        if (value.trim() == '' || value.isEmpty || value.length < 6) {
          return 'Password invalid : Password must be 6 characters or more';
        }
      },
      onSaved: (String value) {
        _formData['password'] = value;
      },
    );
  }

  Widget _buildPasswordConfirmTextField() {
    return FadeTransition(
      opacity: CurvedAnimation(parent: _controller, curve: Curves.easeIn),
      child: SlideTransition(
        position: _slideAnimation,
        child: TextFormField(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            labelText: 'Confirm Password',
            filled: true,
            icon: Icon(Icons.security, color: Colors.black),
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  _obscurePasswordText = !_obscurePasswordText;
                });
              },
              child: Icon(
                _obscurePasswordText ? Icons.visibility : Icons.visibility_off,
                semanticLabel:
                    _obscurePasswordText ? 'show password' : 'hide password',
              ),
            ),
          ),
          obscureText: _obscurePasswordText,
          controller: _passwordClearController,
          validator: (String value) {
            if (_passwordTextController.text != value &&
                _authMode == AuthMode.Signup) {
              return "Passwords don't match!";
            }
          },
        ),
      ),
    );
  }

  void showTershTerms() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Tresh Terms'),
          content: Text(
              'By Accepting These Terms, You Agree To Follow The Rules And Not Engage In any Fraud Activities Using This Platform'),
          actions: <Widget>[
            FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Okay'))
          ],
        );
      },
    );
  }

  Widget _buildAcceptSwitch() {
    return FadeTransition(
      opacity: CurvedAnimation(parent: _controller, curve: Curves.easeIn),
      child: SlideTransition(
        position: _slideAnimation,
        child: SwitchListTile(
          activeColor: Theme.of(context).accentColor,
          value: _formData['acceptTerms'],
          onChanged: (bool value) {
            setState(() {
              _formData['acceptTerms'] = value;
              if (value == true) {
                showTershTerms();
              }
            });
          },
          title: GestureDetector(
            child: Text('Accept Terms'),
            onTap: () {
              showTershTerms();
            },
          ),
        ),
      ),
    );
  }

  void _loginSubmit(Function authenticate, Function newUser) async {
    //checking form validation
    //Don't save if form is not valid or terms not accepted
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

    if (!_formKey.currentState.validate()) {
      _autovalidate = true;
      return;
    } else if (!_formData['acceptTerms']) {
      myDialog('Please Accept Terms Before Proceeding ');
      return;
    }

    _formKey.currentState.save();
    Map<String, dynamic> successInfo;

    successInfo = await authenticate(
        _formData['email'], _formData['password'], _authMode);

    newUser(_formData['email'], _formData['userName'], _authMode);

    if (successInfo['success']) {
      //  Navigator.pushReplacementNamed(context, "/");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyApp()),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('An Error Occured'),
            content: Text(successInfo['message']),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Tersh ${_authMode == AuthMode.Login ? 'Login' : 'Signup'}'),
      ),
      body: GestureDetector(
        onTap: () {
          //closing the key board
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          decoration: BoxDecoration(
            image: _buildBackgroundImage(),
          ),
          padding: EdgeInsets.all(10.0),
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                width: targetWidth,
                child: Form(
                  key: _formKey,
                  autovalidate: _autovalidate,
                  child: Column(
                    children: <Widget>[
                      _buildUserNameTextField(),
                      SizedBox(height: 10.0),
                      _buildEmailTextField(),
                      SizedBox(height: 10.0),
                      _buildPasswordTextField(),
                      SizedBox(
                        height: 10.0,
                      ),
                      _buildPasswordConfirmTextField(),
                      _buildAcceptSwitch(),
                      SizedBox(
                        height: 10.0,
                      ),
                      ScopedModelDescendant<MainModel>(
                        builder: (BuildContext context, Widget child,
                            MainModel model) {
                          return model.isLoading
                              ? CircularProgressIndicator()
                              : RaisedButton(
                                  elevation: 8,
                                  shape: StadiumBorder(),
                                  color: Theme.of(context).primaryColor,
                                  textColor: Colors.white,
                                  child: Text(_authMode == AuthMode.Login
                                      ? 'LOGIN'
                                      : 'SIGNUP'),
                                  onPressed: () {
                                    if (_authMode == AuthMode.Login) {
                                      _formData['acceptTerms'] = true;
                                    }

                                    _loginSubmit(
                                        model.authenticate, model.addNewUser);
                                    //closing the key board
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                  },
                                );
                        },
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      FlatButton(
                        child: Text(
                            '${_authMode == AuthMode.Login ? 'Create an account' : 'Go To Login'}'),
                        onPressed: () {
                          if (_authMode == AuthMode.Login) {
                            setState(() {
                              _authMode = AuthMode.Signup;
                            });
                            _controller.forward();
                          } else {
                            setState(() {
                              _authMode = AuthMode.Login;
                            });
                            _controller.reverse();
                          }
                          setState(() {
                            _formData['acceptTerms'] = false;
                          });
                          // _emailClearController.clear();
                          // _passwordClearController.clear();
                          // _passwordTextController.clear();
                          // _userNameClearController.clear();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
