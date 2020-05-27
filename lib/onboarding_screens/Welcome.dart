import 'package:flutter/material.dart';
import 'package:concentric_transition/concentric_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        duration: Duration(milliseconds: 1500),
        physics: BouncingScrollPhysics(),
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

setVisitingFlag() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setBool("alreadyVisited", true);
}

Future<bool> getVisitingFlag() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  bool alreadyVisited = preferences.getBool("alreadyVisited") ?? false;
  return alreadyVisited;
}