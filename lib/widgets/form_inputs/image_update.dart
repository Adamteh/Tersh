import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../scoped-models/main.dart';
import '../../models/item.dart';

class ImageInput extends StatefulWidget {
  final Function setImage;
  final Item item;

  ImageInput(this.setImage, this.item);

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File _imageFile;

  void _getImage(BuildContext context, ImageSource source) {
    ImagePicker.pickImage(
            source: source, maxWidth: MediaQuery.of(context).size.width)
        .then(
      (File image) {
        setState(() {
          _imageFile = image;
        });
        widget.setImage(image);
        Navigator.pop(context);
      },
    ).catchError((error) {});
  }

  void _openImagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
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
                },
              ),
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
              _imageFile != null
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
                        Navigator.pop(context);
                        setState(
                          () {
                            _imageFile = null;
                          },
                        );
                      },
                    )
                  : Container(),
            ],
          ),
        );
      },
    ).catchError((error) {});
  }

  @override
  Widget build(BuildContext context) {
    var previewImage;
    if (_imageFile != null) {
      previewImage = FileImage(
        _imageFile,
      );
    } else if (widget.item.image != null) {
      previewImage = NetworkImage(widget.item.image);
    } else {
      previewImage = AssetImage(
        'assets/placeholderimage.png',
      );
    }
    return GestureDetector(
      child: CircleAvatar(
        backgroundImage: previewImage,
        radius: 65.0,
      ),
      onTap: () {
        _openImagePicker(context);
      },
    );
  }
}

class ImageInput1 extends StatefulWidget {
  final Function setImage;
  final Item item;

  ImageInput1(this.setImage, this.item);

  @override
  _ImageInput1State createState() => _ImageInput1State();
}

class _ImageInput1State extends State<ImageInput1> {
  File _imageFile;

  void _getImage(BuildContext context, ImageSource source) {
    ImagePicker.pickImage(
            source: source, maxWidth: MediaQuery.of(context).size.width)
        .then(
      (File image) {
        setState(() {
          _imageFile = image;
        });
        widget.setImage(image);
        Navigator.pop(context);
      },
    ).catchError((error) {});
  }

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
                  },
                ),
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
                _imageFile != null || widget.item.image1 != null
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
                          Navigator.pop(context);
                          setState(
                            () {
                              _imageFile = null;
                              widget.item.image1 = null;
                            },
                          );
                          try {
                            model.deleteProductImage('imagePath1');
                            model.deleteProductImage('imageUrl1');
                            model.deleteAccommodationImage('imagePath1');
                            model.deleteAccommodationImage('imageUrl1');
                            model.deleteJobImage('imagePath1');
                            model.deleteJobImage('imageUrl1');
                            model.deleteEventImage('imagePath1');
                            model.deleteEventImage('imageUrl1');
                          } catch (error) {}
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

  @override
  Widget build(BuildContext context) {
    var previewImage;
    if (_imageFile != null) {
      previewImage = FileImage(
        _imageFile,
      );
    } else if (widget.item.image1 != null) {
      previewImage = NetworkImage(widget.item.image1);
    } else {
      previewImage = AssetImage(
        'assets/placeholderimage.png',
      );
    }
    return GestureDetector(
      child: CircleAvatar(
        backgroundImage: previewImage,
        radius: 65.0,
      ),
      onTap: () {
        _openImagePicker(context);
      },
    );
  }
}

class ImageInput2 extends StatefulWidget {
  final Function setImage;
  final Item item;

  ImageInput2(this.setImage, this.item);

  @override
  _ImageInput2State createState() => _ImageInput2State();
}

class _ImageInput2State extends State<ImageInput2> {
  File _imageFile;

  void _getImage(BuildContext context, ImageSource source) {
    ImagePicker.pickImage(
            source: source, maxWidth: MediaQuery.of(context).size.width)
        .then(
      (File image) {
        setState(() {
          _imageFile = image;
        });
        widget.setImage(image);
        Navigator.pop(context);
      },
    ).catchError((error) {});
  }

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
                  },
                ),
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
                _imageFile != null || widget.item.image2 != null
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
                          Navigator.pop(context);
                          setState(
                            () {
                              _imageFile = null;
                              widget.item.image2 = null;
                            },
                          );
                          try {
                            model.deleteProductImage('imagePath2');
                            model.deleteProductImage('imageUrl2');
                            model.deleteAccommodationImage('imagePath2');
                            model.deleteAccommodationImage('imageUrl2');
                            model.deleteJobImage('imagePath2');
                            model.deleteJobImage('imageUrl2');
                            model.deleteEventImage('imagePath2');
                            model.deleteEventImage('imageUrl2');
                          } catch (error) {}
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

  @override
  Widget build(BuildContext context) {
    var previewImage;
    if (_imageFile != null) {
      previewImage = FileImage(
        _imageFile,
      );
    } else if (widget.item.image2 != null) {
      previewImage = NetworkImage(widget.item.image2);
    } else {
      previewImage = AssetImage(
        'assets/placeholderimage.png',
      );
    }
    return GestureDetector(
      child: CircleAvatar(
        backgroundImage: previewImage,
        radius: 65.0,
      ),
      onTap: () {
        _openImagePicker(context);
      },
    );
  }
}

class ImageInput3 extends StatefulWidget {
  final Function setImage;
  final Item item;

  ImageInput3(this.setImage, this.item);

  @override
  _ImageInput3State createState() => _ImageInput3State();
}

class _ImageInput3State extends State<ImageInput3> {
  File _imageFile;

  void _getImage(BuildContext context, ImageSource source) {
    ImagePicker.pickImage(
            source: source, maxWidth: MediaQuery.of(context).size.width)
        .then(
      (File image) {
        setState(() {
          _imageFile = image;
        });
        widget.setImage(image);
        Navigator.pop(context);
      },
    ).catchError((error) {});
  }

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
                  },
                ),
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
                _imageFile != null || widget.item.image3 != null
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
                          Navigator.pop(context);
                          setState(
                            () {
                              _imageFile = null;
                              widget.item.image3 = null;
                            },
                          );
                          try {
                            model.deleteProductImage('imagePath3');
                            model.deleteProductImage('imageUrl3');
                            model.deleteAccommodationImage('imagePath3');
                            model.deleteAccommodationImage('imageUrl3');
                            model.deleteJobImage('imagePath3');
                            model.deleteJobImage('imageUrl3');
                            model.deleteEventImage('imagePath3');
                            model.deleteEventImage('imageUrl3');
                          } catch (error) {}
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

  @override
  Widget build(BuildContext context) {
    var previewImage;
    if (_imageFile != null) {
      previewImage = FileImage(
        _imageFile,
      );
    } else if (widget.item.image3 != null) {
      previewImage = NetworkImage(widget.item.image3);
    } else {
      previewImage = AssetImage(
        'assets/placeholderimage.png',
      );
    }
    return GestureDetector(
      child: CircleAvatar(
        backgroundImage: previewImage,
        radius: 65.0,
      ),
      onTap: () {
        _openImagePicker(context);
      },
    );
  }
}

class ImageInput4 extends StatefulWidget {
  final Function setImage;
  final Item item;

  ImageInput4(this.setImage, this.item);

  @override
  _ImageInput4State createState() => _ImageInput4State();
}

class _ImageInput4State extends State<ImageInput4> {
  File _imageFile;

  void _getImage(BuildContext context, ImageSource source) {
    ImagePicker.pickImage(
            source: source, maxWidth: MediaQuery.of(context).size.width)
        .then(
      (File image) {
        setState(() {
          _imageFile = image;
        });
        widget.setImage(image);
        Navigator.pop(context);
      },
    ).catchError((error) {});
  }

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
                  },
                ),
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
                _imageFile != null || widget.item.image4 != null
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
                          Navigator.pop(context);
                          setState(
                            () {
                              _imageFile = null;
                              widget.item.image4 = null;
                            },
                          );
                          try {
                            model.deleteProductImage('imagePath4');
                            model.deleteProductImage('imageUrl4');
                            model.deleteAccommodationImage('imagePath4');
                            model.deleteAccommodationImage('imageUrl4');
                            model.deleteJobImage('imagePath4');
                            model.deleteJobImage('imageUrl4');
                            model.deleteEventImage('imagePath4');
                            model.deleteEventImage('imageUrl4');
                          } catch (error) {}
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

  @override
  Widget build(BuildContext context) {
    var previewImage;
    if (_imageFile != null) {
      previewImage = FileImage(
        _imageFile,
      );
    } else if (widget.item.image4 != null) {
      previewImage = NetworkImage(widget.item.image4);
    } else {
      previewImage = AssetImage(
        'assets/placeholderimage.png',
      );
    }
    return GestureDetector(
      child: CircleAvatar(
        backgroundImage: previewImage,
        radius: 65.0,
      ),
      onTap: () {
        _openImagePicker(context);
      },
    );
  }
}
