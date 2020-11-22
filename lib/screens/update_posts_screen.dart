import 'dart:io';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:blog/widgets/blog/update_post.dart';
import 'package:blog/widgets/loader/loader.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class UpdatepostsScreen extends StatefulWidget {
  static const routeName = 'update_post';

  @override
  _UpdatepostsScreenState createState() => _UpdatepostsScreenState();
}

class _UpdatepostsScreenState extends State<UpdatepostsScreen> {
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
    final args = ModalRoute.of(context).settings.arguments as Map;
    final _getData = await _posts.doc(args['id'].toString()).get();
    setState(() {
      _isLoading = true;
    });
    final userlogged = FirebaseAuth.instance.currentUser;
    if (image != null) {
      final ref = FirebaseStorage.instance.ref();
      var desertRef = ref.child('posts_image').child(args['id'].toString() + '.jpg');
      desertRef.delete().then((value) => print('success'));

      final _refpath = ref.child('posts_image').child(args['id'].toString() + '.jpg');

      await _refpath.putFile(image);

      final _url = await _refpath.getDownloadURL();

      await _posts.doc(args['id'].toString()).update({
        'title': title,
        'userID': userlogged.uid,
        'body': body,
        'featured_image': _url,
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
        print(err.toString());
        //return SnackBar(content: Text(err.toString()));
      });
    } else {
      final _existedImage = _getData.data()['featured_image'];
      await _posts.doc(args['id'].toString()).update({
        'title': title,
        'userID': userlogged.uid,
        'body': body,
        'featured_image': _existedImage,
        'updated': Timestamp.now().toDate()
      }).then((val) {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
        AudioCache cache = new AudioCache();
        return cache.play("posted.mp3");
      }).catchError((err) {
        setState(() {
          _isLoading = false;
        });
        print(err.toString() + 'this is error');
        //return SnackBar(content: Text(err.toString()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading ? Loader() : Scaffold(
      appBar: AppBar(
        title: Text('Update Post'),
      ),
      body: UpdatePost(
        _submitpostData,
        _isLoading,
      ),
    );
  }
}
