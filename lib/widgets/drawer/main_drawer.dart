import 'package:blog/screens/add_post_screen.dart';
import 'package:blog/screens/blog_screen.dart';
import 'package:blog/screens/manage_posts_screen.dart';
import 'package:blog/widgets/drawer/drawer_header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  final _authUser = FirebaseAuth.instance.currentUser;
  CollectionReference _users = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeaderCustomized(),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return BlogScreen();
              }));
            },
          ),
          ListTile(
            leading: Icon(Icons.local_post_office),
            title: Text('Create Post'),
            onTap: () {
              Navigator.popAndPushNamed(context, AddPost.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.build),
            title: Text('Manage Posts'),
            onTap: () {
              Navigator.popAndPushNamed(context, ManagePostsScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
