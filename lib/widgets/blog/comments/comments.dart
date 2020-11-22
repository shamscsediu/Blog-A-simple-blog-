import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ShowComments extends StatefulWidget {
  final String docID;

  ShowComments(this.docID);
  @override
  _ShowCommentsState createState() => _ShowCommentsState();
}

class _ShowCommentsState extends State<ShowComments> {
  Future<AudioPlayer> playLocalAsset() async {
    AudioCache cache = new AudioCache();
    return await cache.play("posted.mp3");
  }

  final _formKey = GlobalKey<FormState>();
  var _comment = '';
// _getUserImage(data) async{
// final _users = await FirebaseFirestore.instance.collection('users').doc(data).get().then((value) => );
// }
  var _isauthUser = false;
  void _islogged(id) {
    setState(() {
      _isauthUser = FirebaseAuth.instance.currentUser.uid == id;
    });
  }

  void _submitComment() async {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      final _posts = FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.docID)
          .collection('comments');
      _formKey.currentState.save();
      final userlogged = FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userlogged.uid)
          .get()
          .then((value) async {
        await _posts.add({
          'userID': userlogged.uid,
          'body': _comment,
          'avatar': value.data()['image_url'],
          'username': value.data()['username'],
          'created': Timestamp.now().toDate(),
          'updated': Timestamp.now().toDate()
        }).then((val) {
          playLocalAsset();

          Navigator.of(context).pop();
        }).catchError((err) {
          return SnackBar(content: Text(err));
        });
      });
    }
  }

  void _showDialog(BuildContext context, CollectionReference comments) {
    showDialog(
      context: context,

      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return Form(
          key: _formKey,
          child: AlertDialog(
            contentPadding: EdgeInsets.all(4),

            // title: Text('comments'),
            content: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.zero,
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    StreamBuilder(
                        stream: comments
                            .orderBy('updated', descending: true)
                            .snapshots(),
                        initialData: Center(child: CircularProgressIndicator()),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text('error');
                          } else {
                            switch (snapshot.connectionState) {
                              case ConnectionState.none:
                              case ConnectionState.waiting:
                                return Center(
                                    child: CircularProgressIndicator());

                              case ConnectionState.active:

                              case ConnectionState.done:
                                if (snapshot.data.docs.length <= 0) {
                                  return Center(
                                    child: Container(
                                      padding: EdgeInsets.all(8),
                                      child: Text('No comments'),
                                    ),
                                  );
                                } else {
                                  return SingleChildScrollView(
                                    child: Container(
                                      padding: EdgeInsets.all(4),
                                      width: double.maxFinite,
                                      height: 170,
                                      child: ListView.builder(
                                          itemCount: snapshot.data.docs.length,
                                          shrinkWrap: true,
                                          itemBuilder:
                                              (BuildContext ctx, index) {
                                            DocumentSnapshot documentSnapshot =
                                                snapshot.data.docs[index];
                                            // WidgetsBinding.instance
                                            //     .addPostFrameCallback((_) {
                                            //   _islogged(
                                            //       documentSnapshot['userID']);
                                            // });
                                            Future.delayed(Duration.zero,
                                                () async {
                                              _islogged(
                                                  documentSnapshot['userID']);
                                            });

                                            if (_isauthUser)
                                              return ListTile(
                                                leading: Image.network(
                                                    documentSnapshot['avatar']),
                                                title: Text(documentSnapshot[
                                                    'username']),
                                                subtitle: Text(
                                                    documentSnapshot['body']),
                                                trailing: IconButton(
                                                  color: Colors.redAccent,
                                                  splashColor:
                                                      Colors.pinkAccent,
                                                  icon:
                                                      const Icon(Icons.delete),
                                                  onPressed: () {
                                                    comments
                                                        .doc(
                                                            documentSnapshot.id)
                                                        .delete();
                                                  },
                                                ),
                                              );
                                            if (!_isauthUser)
                                              return ListTile(
                                                leading: Image.network(
                                                    documentSnapshot['avatar']),
                                                title: Text(documentSnapshot[
                                                    'username']),
                                                subtitle: Text(
                                                    documentSnapshot['body']),
                                              );
                                          }),
                                    ),
                                  );
                                }
                            }
                          }
                        }),
                    Divider(),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Reply here',
                      ),
                      autofocus: true,
                      maxLines: 1,
                      onSaved: (newValue) {
                        _comment = newValue;
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'please type a comment';
                        }
                        return null;
                      },
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Icon(Icons.send),
                onPressed: () {
                  _submitComment();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference _comments = FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.docID)
        .collection('comments');

    return FlatButton.icon(
      icon: Icon(Icons.comment),
      onPressed: () {
        _showDialog(context, _comments);

        // Perform some action
      },
      label: const Text('comment'),
    );
  }
}
