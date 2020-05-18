import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AwwSnapScreen extends StatelessWidget {
  const AwwSnapScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // height: MediaQuery.of(context).size.height,
      backgroundColor: Colors.blueGrey[900],
      // Theme.of(context).accentColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SvgPicture.asset(
            'assets/svg/bestManWorking.svg',
            fit: BoxFit.cover,
            height: MediaQuery.of(context).size.width * 1.5,
          ),
          Text('Aw, Snap!'),
          Text('We have our best man working on it'),
          FlatButton(
            child: Text('Go Back'),
            onPressed: () {},
          )
        ],
      ),
    );
  }
}
