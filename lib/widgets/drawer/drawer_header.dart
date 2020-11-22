import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DrawerHeaderCustomized extends StatefulWidget {
  @override
  _DrawerHeaderCustomizedState createState() => _DrawerHeaderCustomizedState();
}

class _DrawerHeaderCustomizedState extends State<DrawerHeaderCustomized> {
  final _authUser = FirebaseAuth.instance.currentUser;

  CollectionReference _users = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
        stream: _users.doc(_authUser.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }
          if (snapshot.hasData) {
            return UserAccountsDrawerHeader(
              accountName: Text(snapshot.data.data()['username']),
              accountEmail: Text(snapshot.data.data()['email']),
              currentAccountPicture: CircleAvatar(
                radius: 50.0,
                backgroundImage: NetworkImage(snapshot.data.data()['image_url']),
              ),
              // currentAccountPicture: Image.network(snapshot.data.data()['image_url']),
            );
          }
        },
      ),
    );
  }
}
