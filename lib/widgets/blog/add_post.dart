import 'dart:io';

import 'package:blog/pickers/post_image_picker.dart';

import 'package:flutter/material.dart';

class AddpostForm extends StatefulWidget {
  AddpostForm(
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
  _AddpostFormState createState() => _AddpostFormState();
}

class _AddpostFormState extends State<AddpostForm> {
  final _formKey = GlobalKey<FormState>();
  var _postTitle = '';
  var _postBody = '';
  File _pickFeatured;
  void _getImage(File image) {
    setState(() {
      _pickFeatured = image;
    });
  }
  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (_pickFeatured == null) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Please pick an image.'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }

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
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
               PostImagePicker(_getImage),
                TextFormField(
                  key: ValueKey('title'),
                  autocorrect: false,
                  textCapitalization: TextCapitalization.sentences,
                  enableSuggestions: true,
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
                  key: ValueKey('body'),
                  autocorrect: true,
                  textCapitalization: TextCapitalization.sentences,
                  enableSuggestions: true,
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
    );
  }
}
