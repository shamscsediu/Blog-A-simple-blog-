import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PostImagePicker extends StatefulWidget {
  PostImagePicker(this.featuredImagePickFn,{Key key}) : super(key: key);

  final void Function(File pickedFeatured) featuredImagePickFn;

  @override
  _PostImagePickerState createState() => _PostImagePickerState();
}

class _PostImagePickerState extends State<PostImagePicker> {
  File _featured;
  final picker = ImagePicker();
  Future _getFeaturedImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery,imageQuality: 80,maxHeight:  350 , maxWidth: 350);

    setState(() {
      if (pickedFile != null) {
        _featured = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
    setState(() {
      _featured = File(pickedFile.path);
    });
    widget.featuredImagePickFn(_featured);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Card(
          child: Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: _featured != null
                    ? FileImage(_featured)
                    : NetworkImage('https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/600px-No_image_available.svg.png'),
              ),
            ),
          ),
          // _featured != null ? FileImage(_featured) : null,
        ),
        FlatButton.icon(
          textColor: Theme.of(context).primaryColor,
          onPressed: _getFeaturedImage,
          icon: Icon(Icons.image),
          label: Text('Add Image'),
        ),
      ],
    );
  }
}
