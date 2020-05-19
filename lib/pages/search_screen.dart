// import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
// import 'package:floating_search_bar/floating_search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
// import 'package:flutter_chips_input/flutter_chips_input.dart';
import 'package:recipetap/models/search_suggestions.dart';
import 'package:recipetap/pages/catagories_screen.dart';
import 'package:recipetap/pages/search_results.dart';
import 'package:simple_search_bar/simple_search_bar.dart';
import 'package:slimy_card/slimy_card.dart';

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

  int _selectedIndex = 0;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Likes',
      style: optionStyle,
    ),
    Text(
      'Index 2: Search',
      style: optionStyle,
    ),
    Text(
      'Index 3: Profile',
      style: optionStyle,
    ),
  ];

  var searchValue = '';

  final AppBarController appBarController = AppBarController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // TODO Custom Name Appbar
      // TODO: Searchlist images resolution full
      appBar: SearchAppBar(
        primary: Theme.of(context).primaryColor,
        appBarController: appBarController,

        searchHint: "Search Recipes",
        mainTextColor: Colors.white,
        onChange: (String value) {
          //Your function to filter list. It should interact with
          //the Stream that generate the final list
        },
        //Will show when SEARCH MODE wasn't active
        mainAppBar: AppBar(
          title: Text("Welcome, User!"),
          leading: CircleAvatar(),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: InkWell(
                child: Icon(
                  Icons.search,
                ),
                onTap: () {
                  //This is where You change to SEARCH MODE. To hide, just
                  //add FALSE as value on the stream
                  appBarController.stream.add(true);
                },
              ),
            ),
          ],
        ),
      ),
      // appBar: AppBar(
      //   title: CupertinoTextField(
      //     padding: EdgeInsets.all(10),
      //   ),
      // ),

      // body: Center(
      //   child: _widgetOptions.elementAt(_selectedIndex),
      // ),

      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SlimyCard(
                color: Colors.red.shade500,
                width: MediaQuery.of(context).size.width * 0.95,
                borderRadius: 25,
                topCardHeight: 235,
                topCardWidget: Container(
                  child: Column(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Image.asset('assets/images/fridge.jpg'),
                      ),
                    ],
                  ),
                ),
                bottomCardHeight: 200,
                bottomCardWidget: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    image: DecorationImage(
                      image: AssetImage(
                        'assets/images/fridge.jpg',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              // Text('Search'),
              // TextFormField(
              //   controller: normalSearchController,
              // ),
              // FlatButton(
              //   child: Text('Search Recipe by name'),
              //   onPressed: () => submitSearchNormal(
              //     "Showing Results For " + normalSearchController.text,
              //     normalSearchController.text
              //         .replaceAll(" ", "%20")
              //         .toLowerCase(),
              //   ),
              // ),
              // // TODO retry button for dns fail
              // Text('Favourites'),
              // Text('Browse By Category'),
              FlatButton(
                child: Text('CategoriesScreen'),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CategoriesScreen()));
                },
              ),
              // Text('Search By Ingredients'),
              // SizedBox(
              //   height: 50,
              // ),
              // Text('Include'),
              // SimpleAutoCompleteTextField(
              //   key: key,
              //   suggestions: suggestions,
              //   // textChanged: (query) => suggestions.add(query),
              //   controller: inclController,
              // ),
              // SizedBox(
              //   height: 50,
              // ),
              // Text('Exclude'),
              // SimpleAutoCompleteTextField(
              //   key: keyy,
              //   suggestions: suggestions,
              //   controller: exclController,
              // ),
              // SizedBox(
              //   height: 50,
              // ),
              // FlatButton(
              //   child: Text('Search'),
              //   onPressed: () {
              //     submitSearch(
              //       inclController.text.toLowerCase().replaceAll(" ", "%20"),
              //       exclController.text.toLowerCase().replaceAll(" ", "%20"),
              //     );
              //   },
              // ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1))
        ]),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
                gap: 8,
                activeColor: Colors.white,
                iconSize: 24,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                duration: Duration(milliseconds: 800),
                tabBackgroundColor: Colors.grey[800],
                tabs: [
                  GButton(
                    icon: Icons.home,
                    text: 'Home',
                  ),
                  GButton(
                    icon: Icons.favorite,
                    text: 'Likes',
                  ),
                  GButton(
                    icon: Icons.search,
                    text: 'Search',
                  ),
                  GButton(
                    icon: Icons.supervised_user_circle,
                    text: 'Profile',
                  ),
                ],
                selectedIndex: _selectedIndex,
                onTabChange: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                }),
          ),
        ),
      ),
    );
  }
}
// Container(
//   height: 200,
//   child: FloatingSearchBar(
//     children: <Widget>[
//       // Text(searchValue),
//     ],
//     onChanged: (String value) {
//       searchValue = value;
//     },
//     onTap: () {},
//     body: Text(""),
//     pinned: true,
//     decoration: InputDecoration.collapsed(
//       hintText: "Search For Your Favourite Recipes...",
//     ),
//   ),
// ),
