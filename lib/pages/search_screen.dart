import 'package:flutter/material.dart';

import 'package:flutter_chips_input/flutter_chips_input.dart';
import 'package:recipetap/models/ingredients.dart';
import 'package:recipetap/pages/search_results.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key key}) : super(key: key);
  static const routeName = 'search_screen';
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController inclController = TextEditingController();
  TextEditingController exclController = TextEditingController();

// TODO spaces replace %20
// TODO check same ingredient not included and excluded

  @override
  void initState() {
    inclController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    inclController.dispose();
    exclController.dispose();
    super.dispose();
  }

  submitSearch(incl, excl) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => SearchResultsScreen(
              incl: incl,
              excl: excl,
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: inclController,
            ),
            TextFormField(
              controller: exclController,
            ),
            FlatButton(
              child: Text('Search'),
              onPressed: () {
                submitSearch(inclController.text, exclController.text);
              },
            ),
          ],
        ),
      ),
    );
  }
}
