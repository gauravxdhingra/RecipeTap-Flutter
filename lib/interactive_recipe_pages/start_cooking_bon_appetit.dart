import 'package:flutter/material.dart';
import 'package:recipetap/pages/recipe_view_page.dart';

class StartCookingBonAppetit extends StatelessWidget {
  const StartCookingBonAppetit({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ready!'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context)),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/family.png'),
            Text(
              'Bon Appetit!',
              style: Theme.of(context).textTheme.headline1.copyWith(
                    fontWeight: FontWeight.w300,
                  ),
            ),
            SizedBox(
              height: 70,
            ),
            Text('Rate Us'),
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
