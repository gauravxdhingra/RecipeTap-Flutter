// import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';

// import 'package:flutter_chips_input/flutter_chips_input.dart';
import 'package:recipetap/models/search_suggestions.dart';
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

  GlobalKey<AutoCompleteTextFieldState<String>> key = GlobalKey();

// TODO spaces replace %20
// TODO check same ingredient not included and excluded

  @override
  void initState() {
    inclController = TextEditingController();
    super.initState();
    print(suggestions);
  }

  List<String> suggestions = SearchSuggestions.suggestions;
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
            // TextFormField(
            //   controller: inclController,
            // ),
            // TextFormField(
            //   controller: exclController,
            // ),
            AutoCompleteTextField(
              itemSubmitted: null,
              key: key,
              suggestions: null,
              itemBuilder: null,
              itemSorter: null,
              itemFilter: null,
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
