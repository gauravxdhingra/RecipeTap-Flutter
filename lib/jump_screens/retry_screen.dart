import 'package:flutter/material.dart';
import 'package:recipetap/pages/catagories_screen.dart';

class RetryScreen extends StatelessWidget {
  const RetryScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Text('Connection Error!'),
          FlatButton(
            onPressed: () => Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => CategoriesScreen())),
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }
}
