// import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
// import 'package:flutter_chips_input/flutter_chips_input.dart';
import 'package:recipetap/models/search_suggestions.dart';
import 'package:recipetap/pages/catagories_screen.dart';
import 'package:recipetap/pages/search_results.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key key}) : super(key: key);
  static const routeName = 'search_screen';
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController inclController = TextEditingController();
  TextEditingController exclController = TextEditingController();
  TextEditingController normalSearchController = TextEditingController();

  GlobalKey<AutoCompleteTextFieldState<String>> key = GlobalKey();

  GlobalKey<AutoCompleteTextFieldState<String>> keyy = GlobalKey();

// TODO: all user search inputs lowercase
// TODO spaces replace %20
// TODO check same ingredient not included and excluded
// TODO: Handle empty search result page 404
// TODO: Review all 10,000 Suggestions

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
            // incl: incl,
            // excl: excl,
            url:
                'https://www.allrecipes.com/search/results/?ingIncl=$incl&ingExcl=$excl&sort=re')));
    print(
        'https://www.allrecipes.com/search/results/?ingIncl=$incl&ingExcl=$excl&sort=re');
  }

  submitSearchNormal(String appbarTitle, String url) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => SearchResultsScreen(
            // incl: incl,
            // excl: excl,
            appBarTitle: appbarTitle,
            url: 'https://www.allrecipes.com/search/results/?wt=$url&sort=re'
            // url: url,
            )));
    print(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // TODO Custom Name Appbar
      appBar: AppBar(),
      body: SlidingUpPanel(
        backdropEnabled: true,
        body: Container(
          child: Column(
            children: <Widget>[
              Text('Search'),
              TextFormField(
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
              // TODO retry button ip
              Text('Favourites'),
              Text('Browse By Category'),
              FlatButton(
                child: Text('CategoriesScreen'),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CategoriesScreen()));
                },
              ),
              // TextFormField(
              //   controller: inclController,
              // ),
              // TextFormField(
              //   controller: exclController,
              // ),
              // FlatButton(
              //   child: Text('Search'),
              //   onPressed: () {
              //     submitSearch(inclController.text, exclController.text);
              //   },
              // ),
            ],
          ),
        ),
        panel: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: <Widget>[
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
