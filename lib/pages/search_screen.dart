import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recipetap/models/search_suggestions.dart';
import 'package:recipetap/pages/search_results.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/search_screen';
  SearchScreen({Key key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController inclController = TextEditingController();
  TextEditingController exclController = TextEditingController();
  TextEditingController normalSearchController = TextEditingController();

  GlobalKey<AutoCompleteTextFieldState<String>> key = GlobalKey();

  GlobalKey<AutoCompleteTextFieldState<String>> keyy = GlobalKey();

  var searchValue = '';

  @override
  void initState() {
    inclController = TextEditingController();
    exclController = TextEditingController();
    normalSearchController = TextEditingController();

    super.initState();
    // print(suggestions);
  }

  List<String> suggestions = SearchSuggestions.suggestions;
  @override
  void dispose() {
    inclController.dispose();
    exclController.dispose();
    normalSearchController.dispose();
    super.dispose();
  }

  submitSearch(incl, excl) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => SearchResultsScreen(
            url:
                'https://www.allrecipes.com/search/results/?ingIncl=$incl&ingExcl=$excl&sort=re')));
    print(
        'https://www.allrecipes.com/search/results/?ingIncl=$incl&ingExcl=$excl&sort=re');
  }

  submitSearchNormal(String appbarTitle, String url) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => SearchResultsScreen(
            appBarTitle: appbarTitle,
            url: 'https://www.allrecipes.com/search/results/?wt=$url&sort=re'
            // url: url,
            )));
    print(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Text('Search'),
              CupertinoTextField(
                controller: normalSearchController,
              ),
              FlatButton(
                child: Text('Search Recipe by name'),
                onPressed: () => submitSearchNormal(
                  "Showing Results For " + normalSearchController.text,
                  normalSearchController.text
                      .replaceAll(" ", "%20")
                      .toLowerCase(),
                ),
              ),
              SizedBox(
                height: 100,
              ),
              Text('Search By Ingredients'),
              SizedBox(
                height: 50,
              ),
              Text('Include'),
              SimpleAutoCompleteTextField(
                key: key,
                suggestions: suggestions,
                // textChanged: (query) => suggestions.add(query),
                controller: inclController,
              ),
              SizedBox(
                height: 50,
              ),
              Text('Exclude'),
              SimpleAutoCompleteTextField(
                key: keyy,
                suggestions: suggestions,
                controller: exclController,
              ),
              SizedBox(
                height: 50,
              ),
              FlatButton(
                child: Text('Search'),
                onPressed: () {
                  submitSearch(
                    inclController.text.toLowerCase().replaceAll(" ", "%20"),
                    exclController.text.toLowerCase().replaceAll(" ", "%20"),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
