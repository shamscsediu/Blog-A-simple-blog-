import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UpdatePostImage extends StatefulWidget {
  UpdatePostImage(this.imgUrl, this._featuredImagePickFn, {Key key})
      : super(key: key);
  final String imgUrl;
  final void Function(File pickedFeatured) _featuredImagePickFn;

  @override
  _UpdatePostImageState createState() => _UpdatePostImageState();
}

class _UpdatePostImageState extends State<UpdatePostImage> {
  File _featuredImg;
  final picker = ImagePicker();
  Future _getFeaturedImage() async {
    final pickedFile = await picker.getImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxHeight: 350,
        maxWidth: 350);

    setState(() {
      if (pickedFile != null) {
        _featuredImg = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
    setState(() {
      _featuredImg = File(pickedFile.path);
    });
    widget._featuredImagePickFn(_featuredImg);
  }

  @override
  Widget build(BuildContext context) {
    print('image');
    return Column(
      children: <Widget>[
        Card(
          child: GestureDetector(
            onTap: _getFeaturedImage,
            child: Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: _featuredImg != null
                      ? FileImage(_featuredImg)
                      : NetworkImage(widget.imgUrl),
                ),
              ),
            ),
          ),
        ),
        FlatButton.icon(
          textColor: Theme.of(context).primaryColor,
          //key: UniqueKey(),
          onPressed: _getFeaturedImage,
          icon: Icon(Icons.image),
          label: Text('Update featured Image'),
        ),
      ],
    );
  }
}
