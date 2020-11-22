import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SpinKitChasingDots(
          duration: Duration(seconds: 3),
          size: 60,      
          itemBuilder: (BuildContext context, int index) {
            return DecoratedBox(
              decoration: BoxDecoration(
                color: index.isEven ? Colors.pinkAccent : Colors.purpleAccent,
                shape: BoxShape.circle
                
              ),
            );
          },
        ),
      ),
    );
  }
}
