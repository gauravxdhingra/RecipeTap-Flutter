import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chips_input/flutter_chips_input.dart';
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

  submitSearch(appBarTitle, dish, incl, excl) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => SearchResultsScreen(
            appBarTitle: appBarTitle,
            incl: incl,
            excl: excl,
            url:
                'https://www.allrecipes.com/search/results/?wt=$dish?ingIncl=$incl&ingExcl=$excl&sort=re')));
    print(
        'https://www.allrecipes.com/search/results/?wt=$dish?ingIncl=$incl&ingExcl=$excl&sort=re');
  }

  // submitSearchNormal(String appbarTitle, String url) {
  //   Navigator.of(context).push(MaterialPageRoute(
  //       builder: (context) => SearchResultsScreen(
  //           appBarTitle: appbarTitle,
  //           url: 'https://www.allrecipes.com/search/results/?wt=$url&sort=re'
  //           // url: url,
  //           )));
  //   print(url);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // Text('Search'),
              TextField(
                controller: normalSearchController,
                // autofocus: true,
              ),
              // FlatButton(
              //   child: Text('Search Recipe by name'),
              //   onPressed: () => submitSearchNormal(
              //     "Showing Results For " + normalSearchController.text,
              //     normalSearchController.text
              //         .replaceAll(" ", "%20")
              //         .toLowerCase(),
              //   ),
              // ),

              Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text('Include'),
                    Container(
                      width: MediaQuery.of(context).size.width * 2 / 3,
                      child:
                          // ChipsInput(
                          //   chipBuilder: null,
                          //   suggestionBuilder: null,
                          //   findSuggestions: null,
                          //   onChanged: null,
                          // )
                          SimpleAutoCompleteTextField(
                        key: key,
                        suggestions: suggestions,
                        // textChanged: (query) => suggestions.add(query),

                        controller: inclController,
                      ),
                    ),
                  ],
                ),
              ),

              // SizedBox(
              //   height: 50,
              // ),

              Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text('Exclude'),
                    Container(
                      width: MediaQuery.of(context).size.width * 2 / 3,
                      child: SimpleAutoCompleteTextField(
                        key: keyy,
                        suggestions: suggestions,
                        controller: exclController,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 50,
              ),
              FlatButton(
                child: Text('Search'),
                onPressed: () {
                  submitSearch(
                    normalSearchController.text.trim().isNotEmpty
                        ? "Showing Results For " + normalSearchController.text
                        : "Showing Recipes From Ingredients",
                    normalSearchController.text
                        .replaceAll(" ", "%20")
                        .toLowerCase(),
                    inclController.text
                        .toLowerCase()
                        .replaceAll(", ", ",")
                        .replaceAll(" ", "%20"),
                    exclController.text
                        .toLowerCase()
                        .replaceAll(", ", ",")
                        .replaceAll(" ", "%20"),
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
