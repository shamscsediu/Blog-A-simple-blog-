import 'package:blog/screens/posts_detail_screen.dart';

import 'package:blog/widgets/blog/comments/comments.dart';
import 'package:blog/widgets/loader/loader.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

class BlogPosts extends StatefulWidget {
  @override
  _BlogPostsState createState() => _BlogPostsState();
}

class _BlogPostsState extends State<BlogPosts> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

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
  //var _isliked = false;

  @override
  Widget build(BuildContext context) {
    _controller.forward();
    return FadeTransition(
      opacity: _animation,
      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("posts")
              .orderBy('updated', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Loader();
            }

            if (snapshot.hasData) {
              print(snapshot.data.docs.length);
              if (snapshot.data.docs.length <= 0) {
                return Center(
                  child: Text('No posts available'),
                );
              } else
                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  shrinkWrap: true,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, int index) {
                    DocumentSnapshot documentSnapshot =
                        snapshot.data.docs[index];
                    return Container(
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, PostsDetailScreen.routeName,
                                    arguments: {
                                      'id': documentSnapshot.id,
                                      'title': documentSnapshot['title'],
                                      'body': documentSnapshot['body'],
                                      'featured':
                                          documentSnapshot['featured_image'],
                                      'created': documentSnapshot['created']
                                    });
                              },
                              child: Hero(
                                tag: documentSnapshot.id,
                                child: Container(
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
                              ),
                            ),

                            // Image.network(documentSnapshot['featured_image']),

                            Divider(),
                            ListTile(
                              title: Text(documentSnapshot['title']),
                              subtitle: Text(
                                'Posted on ' +
                                    DateFormat('yMMMd').format(
                                        documentSnapshot['created'].toDate()),
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
                                ShowComments(documentSnapshot.id),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
            }
          }),
    );
  }
}
