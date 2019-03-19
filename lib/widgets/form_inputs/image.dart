import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/item.dart';

class ImageInput extends StatefulWidget {
  final Function setImage;
  final Item item;

  ImageInput(this.setImage, this.item);

  @override
  State<StatefulWidget> createState() {
    return _ImageInputState();
  }
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
                            Icons.remove_circle,
                            size: 30.0,
                            color: Colors.red,
                          ),
                          Text(
                            'Remove',
                            style: TextStyle(color: Colors.black),
                          )
                        ],
                      ),
                      onPressed: () {
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
    } else if (_imageFile == null) {
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
