import 'package:flutter/material.dart';

class StartCookingBonAppetit extends StatelessWidget {
  const StartCookingBonAppetit({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ready'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => StartCookingBonAppetit(
                      // recipe: widget.recipe,
                      )));
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
