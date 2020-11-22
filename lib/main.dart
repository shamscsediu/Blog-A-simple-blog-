
import 'package:blog/screens/add_post_screen.dart';
import 'package:blog/screens/auth_screen.dart';
import 'package:blog/screens/blog_screen.dart';
import 'package:blog/screens/manage_posts_screen.dart';
import 'package:blog/screens/posts_detail_screen.dart';
import 'package:blog/screens/splash_screen.dart';
import 'package:blog/screens/update_posts_screen.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterChat',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        backgroundColor: Colors.pink,
        accentColor: Colors.deepPurple,
        accentColorBrightness: Brightness.dark,
        buttonTheme: ButtonTheme.of(context).copyWith(
          buttonColor: Colors.pink,
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, userSnapshot) {
            if (userSnapshot.hasError) {
              return Text('error');
            } else {
              switch (userSnapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return SplashScreen();
                case ConnectionState.active:
                case ConnectionState.done:
                  if (userSnapshot.hasData) {
                    return BlogScreen();
                  } else {
                    return AuthScreen();
                  }
              }
            }
          }),
      routes: {
        AddPost.routeName: (context) => AddPost(),
        ManagePostsScreen.routeName: (context) => ManagePostsScreen(),
        UpdatepostsScreen.routeName: (context) => UpdatepostsScreen(),
        PostsDetailScreen.routeName: (context) => PostsDetailScreen()
      },
    );
  }
}
