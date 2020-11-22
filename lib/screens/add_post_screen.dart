import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

import 'package:blog/widgets/blog/add_post.dart';
import 'package:blog/widgets/loader/loader.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class AddPost extends StatefulWidget {
  static const routeName = '/add_post';
  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final _posts = FirebaseFirestore.instance.collection('posts');
  var _isLoading = false;
  Future<AudioPlayer> playLocalAsset() async {
    AudioCache cache = new AudioCache();
    return await cache.play("posted.mp3");
  }

  void _submitpostData(
    String title,
    String body,
    File image,
    BuildContext ctx,
  ) async {
    setState(() {
      _isLoading = true;
    });
    final userlogged = FirebaseAuth.instance.currentUser;
    final ref = FirebaseStorage.instance
        .ref()
        .child('posts_image')
        .child(Timestamp.now().toString() + '.jpg');

    await ref.putFile(image);

    final _url = await ref.getDownloadURL();

    await _posts.add({
      'title': title,
      'userID': userlogged.uid,
      'body': body,
      'featured_image': _url,
      'likes': '',
      'created': Timestamp.now().toDate(),
      'updated': Timestamp.now().toDate()
    }).then((val) {
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
      playLocalAsset();
    }).catchError((err) {
      setState(() {
        _isLoading = false;
      });

      return SnackBar(content: Text(err));
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading ? Loader() : Scaffold(
      appBar: AppBar(
        title: Text('Create Post'),
      ),
      body: AddpostForm(
        _submitpostData,
        _isLoading,
      ),
    );
  }
}
