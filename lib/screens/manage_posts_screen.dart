import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:blog/screens/update_posts_screen.dart';
import 'package:blog/widgets/drawer/main_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:readmore/readmore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ManagePostsScreen extends StatefulWidget {
  static const routeName = 'manage_products';
  @override
  _ManagePostsScreenState createState() => _ManagePostsScreenState();
}

class _ManagePostsScreenState extends State<ManagePostsScreen>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;
  Future<AudioPlayer> playLocalAsset() async {
    AudioCache cache = new AudioCache();
    return await cache.play("deleted.mp3");
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _animation = Tween(begin: 0.4, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  CollectionReference _posts = FirebaseFirestore.instance.collection("posts");
  void _deletePost(id, BuildContext ctx) async {
    await _posts.doc(id).delete().then((value) {
      playLocalAsset();
      return Scaffold.of(ctx).showSnackBar(
        SnackBar(
          content: Text('Deleted Successfully'),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      );
    });
  }

  final _userlogged = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    _controller.forward();
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Products'),
        actions: [
          DropdownButton(
            underline: Container(),
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color,
            ),
            items: [
              DropdownMenuItem(
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.logout),
                      SizedBox(width: 8),
                      Text('Logout'),
                    ],
                  ),
                ),
                value: 'logout',
              ),
            ],
            onChanged: (itemIdentifier) {
              if (itemIdentifier == 'logout') {
                FirebaseAuth.instance.signOut();
              }
            },
          ),
        ],
      ),
      drawer: MainDrawer(),
      body: FadeTransition(
        opacity: _animation,
        child: Container(
          child: StreamBuilder<QuerySnapshot>(
              stream: _posts
                  .where('userID', isEqualTo: _userlogged.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return LinearProgressIndicator();
                }
                if (snapshot.data.docs.length <=0 ) {
                return  Center(
                    child: Text("No posts available"),
                  );
                } else {
                  print(snapshot.data.docs.length);
                  return ListView.builder(
                    padding: const EdgeInsets.all(8),
                    shrinkWrap: true,
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, int index) {
                      DocumentSnapshot documentSnapshot =
                          snapshot.data.docs[index];
                      return Dismissible(
                        key: Key(documentSnapshot.id),
                        confirmDismiss: (DismissDirection direction) async {
                          return await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: Theme.of(context).primaryColor,
                                contentTextStyle:
                                    TextStyle(color: Colors.white),
                                title: const Text(
                                  "Confirm",
                                  style: TextStyle(color: Colors.white),
                                ),
                                content: const Text(
                                    "Are you sure you wish to delete this post?"),
                                actions: <Widget>[
                                  FlatButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      child: const Text("DELETE",
                                          style:
                                              TextStyle(color: Colors.white))),
                                  FlatButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: const Text("CANCEL",
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        onDismissed: (direction) {
                          _deletePost(documentSnapshot.id, context);
                        },
                        direction: DismissDirection.startToEnd,
                        child: Container(
                          child: Card(
                            clipBehavior: Clip.antiAlias,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 200,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                          documentSnapshot['featured_image']),
                                    ),
                                  ),
                                ),

                                // Image.network(documentSnapshot['featured_image']),

                                Divider(),
                                ListTile(
                                  title: Text(documentSnapshot['title']),
                                  subtitle: Text(
                                    'Posted on ' +
                                        DateFormat('yMMMd').format(
                                            documentSnapshot['created']
                                                .toDate()),
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.6)),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 16),
                                  child: ReadMoreText(
                                    documentSnapshot['body'],
                                    trimLines: 2,
                                    colorClickableText: Colors.blueAccent,
                                    trimMode: TrimMode.Line,
                                    trimCollapsedText: '...Show more',
                                    trimExpandedText: ' show less',
                                  ),
                                ),
                                Divider(),
                                ButtonBar(
                                  alignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    FlatButton.icon(
                                      icon: Icon(Icons.update),
                                      onPressed: () {
                                        Navigator.pushNamed(
                                          context,
                                          UpdatepostsScreen.routeName,
                                          arguments: {
                                            'id': documentSnapshot.id,
                                            'title': documentSnapshot['title'],
                                            'body': documentSnapshot['body'],
                                            'featured': documentSnapshot[
                                                'featured_image']
                                          },
                                        );
                                      },
                                      label: const Text('Update'),
                                    ),
                                    FlatButton.icon(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        _deletePost(
                                            documentSnapshot.id, context);
                                        // Perform some action
                                      },
                                      label: const Text('Delete'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              }),
        ),
      ),
    );
  }
}
