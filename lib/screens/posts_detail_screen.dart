import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:intl/intl.dart';

class PostsDetailScreen extends StatefulWidget {
  static const routeName = '/post_detail';

  @override
  _PostsDetailScreenState createState() => _PostsDetailScreenState();
}

class _PostsDetailScreenState extends State<PostsDetailScreen> {
  var _loadedInitData = false;
  var _postTitle;
  var _postBody;
  var _imageUrl;
  var _postCreated;
  var _docID;

  @override
  void didChangeDependencies() {
    print('did change');
    if (!_loadedInitData) {
      print('in the loaded data');
      final routeArgs = ModalRoute.of(context).settings.arguments as Map;
      // print(routeArgs['id'].toString());
      setState(() {
        _postTitle = routeArgs['title'];
        _postBody = routeArgs['body'];
        _imageUrl = routeArgs['featured'];
        _postCreated = routeArgs['created'];
        _docID = routeArgs['id'];
        print(_postTitle);
      });

      _loadedInitData = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            iconTheme: IconThemeData(
              color: Colors.black, //change your color here
            ),
            expandedHeight: 300,
            pinned: false,
            flexibleSpace: FlexibleSpaceBar(
              // title: Container(
              //   color: Colors.black54,
              //   child: Text(
              //     'By Shams',
              //     textAlign: TextAlign.right,
              //   ),
              // ),
              background: Hero(
                tag: _docID,
                child: Image.network(
                  _imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(height: 10),
                Text(
                  _postTitle,
                  style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  'Posted on ' +
                      DateFormat('yMMMd').format(_postCreated.toDate()),
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
                Divider(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  child: Linkify(
                    onOpen: (link) async {
                      if (await canLaunch(link.url)) {
                        await launch(link.url);
                      } else {
                        throw 'Could not launch $link';
                      }
                    },
                    text: _postBody,
                    softWrap: true,
                    style: TextStyle(color: Colors.black),
                    linkStyle: TextStyle(color: Colors.red),
                  ),
                )
              ],
            ),
          ),
        ],
      ),

      // body: SingleChildScrollView(
      //   child: SafeArea(
      //     child: Container(
      //       child: Card(
      //         clipBehavior: Clip.antiAlias,
      //         child: Column(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: [
      //             Hero(
      //               tag: _postCreated,
      //               child: Stack(children: <Widget>[
      //                 Container(
      //                   //alignment: Alignment.center,
      //                   height: 200,
      //                   width: double.infinity,
      //                   decoration: BoxDecoration(
      //                     image: DecorationImage(
      //                       fit: BoxFit.cover,
      //                       image: NetworkImage(_imageUrl),
      //                     ),
      //                   ),
      //                 ),
      //                 Positioned(
      //                   bottom: 0,
      //                   right: 50,
      //                   child: Container(

      //                     child: FittedBox(

      //                       child: Text(_postTitle)),
      //                     // subtitle: Text(
      //                     //   'Posted on ' +
      //                     //       DateFormat('yMMMd').format(_postCreated.toDate()),
      //                     //   style:
      //                     //       TextStyle(color: Colors.black.withOpacity(0.6)),
      //                     // ),
      //                   ),
      //                 ),
      //               ]),
      //             ),

      //             // Image.network(documentSnapshot['featured_image']),

      //             Divider(),

      //             Padding(
      //               padding:
      //                   const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
      //               child: Text(_postBody),
      //             ),
      //             Divider(),
      //             ButtonBar(
      //               alignment: MainAxisAlignment.spaceEvenly,
      //               children: [
      //                 FlatButton(
      //                   onPressed: () {
      //                     // Perform some action
      //                   },
      //                   child: const Text('Like'),
      //                 ),
      //                 FlatButton(
      //                   onPressed: () {
      //                     // Perform some action
      //                   },
      //                   child: const Text('comment'),
      //                 ),
      //               ],
      //             ),
      //           ],
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}
