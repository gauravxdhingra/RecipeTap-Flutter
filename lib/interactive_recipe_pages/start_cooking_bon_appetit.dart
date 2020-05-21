import 'package:flutter/material.dart';
import 'package:recipetap/pages/recipe_view_page.dart';

class StartCookingBonAppetit extends StatelessWidget {
  const StartCookingBonAppetit({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ready'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Text('Bon Appetit'),
            // TODO SVG
            // TODO Rate Us
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
        },
        label: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Finish'),
            Icon(Icons.navigate_next),
          ],
        ),
      ),
    );
  }
}
