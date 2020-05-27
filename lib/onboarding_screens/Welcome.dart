import 'package:flutter/material.dart';
import 'package:concentric_transition/concentric_transition.dart';

class Welcome extends StatefulWidget {
  Welcome({Key key}) : super(key: key);

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ConcentricPageView(
        colors: <Color>[Colors.white, Colors.blue, Colors.red],
        itemCount: 4, // null = infinity
        // physics: NeverScrollableScrollPhysics(),
        itemBuilder: (int index, double value) {
          return Center(
            child: Container(
              child: Text('Page $index'),
            ),
          );
        },
      ),
    );
  }
}
