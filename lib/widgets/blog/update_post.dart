import 'dart:io';

import 'package:blog/pickers/update_post_image_picker.dart';
import 'package:flutter/material.dart';

class UpdatePost extends StatefulWidget {
  UpdatePost(
    this.submitPostFn,
    this.isLoading,
  );
  final bool isLoading;
  final void Function(
    String title,
    String body,
    File image,
    BuildContext ctx,
  ) submitPostFn;
  @override
  _UpdatePostState createState() => _UpdatePostState();
}

class _UpdatePostState extends State<UpdatePost> {
  var _loadedInitData = false;
  final _formKey = GlobalKey<FormState>();

  String _postTitle;
  String _postBody;
  String _imageUrl;

  File _pickFeatured;
  void _getImage(File image) {
    setState(() {
      _pickFeatured = image;
    });
  }

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    // if (_pickFeatured == null) {
    //   Scaffold.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text('Please pick an image.'),
    //       backgroundColor: Theme.of(context).errorColor,
    //     ),
    //   );
    //   return;
    // }

    if (isValid) {
      _formKey.currentState.save();
      widget.submitPostFn(
        _postTitle.trim(),
        _postBody.trim(),
        _pickFeatured,
        context,
      );
    }
  }

  @override
  void didChangeDependencies() {
    print('did change');
    if (!_loadedInitData) {
      print('in the loaded data');
      final routeArgs =
          ModalRoute.of(context).settings.arguments as Map;
     // print(routeArgs['id'].toString());
      setState(() {
        _postTitle = routeArgs['title'];
        _postBody = routeArgs['body'];
        _imageUrl = routeArgs['featured'];
        print(_postTitle);
      });

      _loadedInitData = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print('in the build');
    return Container(
        child: Card(
      margin: EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                UpdatePostImage(_imageUrl, _getImage),
                TextFormField(
                  key: UniqueKey(),
                  autocorrect: false,
                  textCapitalization: TextCapitalization.sentences,
                  enableSuggestions: true,
                  initialValue: _postTitle,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a title.';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Title',
                  ),
                  onSaved: (value) {
                    _postTitle = value;
                  },
                ),
                TextFormField(
                  key: UniqueKey(),
                  autocorrect: true,
                  textCapitalization: TextCapitalization.sentences,
                  enableSuggestions: true,
                  initialValue: _postBody,
                  validator: (value) {
                    if (value.isEmpty || value.length < 4) {
                      return 'Please enter at least 4 characters';
                    }
                    return null;
                  },
                  decoration: InputDecoration(labelText: 'Post'),
                  onSaved: (value) {
                    _postBody = value;
                  },
                ),
                SizedBox(height: 12),
                if (widget.isLoading) CircularProgressIndicator(),
                if (!widget.isLoading)
                  RaisedButton(
                    child: Text('Submit'),
                    onPressed: _trySubmit,
                  ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
