// import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'dart:ui';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
// import 'package:floating_search_bar/floating_search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
// import 'package:flutter_chips_input/flutter_chips_input.dart';
import 'package:recipetap/models/search_suggestions.dart';
import 'package:recipetap/pages/catagories_screen.dart';
import 'package:recipetap/pages/favourites_screen.dart';
import 'package:recipetap/pages/search_results.dart';
import 'package:recipetap/pages/search_screen.dart';
import 'package:recipetap/pages/settings_screen.dart';
import 'package:simple_search_bar/simple_search_bar.dart';
import 'package:slimy_card/slimy_card.dart';

// TODO GIPHY Navbar

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);
  static const routeName = 'home_screen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(),
          ),
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
                color: Colors.deepPurple,
                width: MediaQuery.of(context).size.width * 0.95,
                borderRadius: 25,
                topCardHeight: 275,
                // 235
                topCardWidget: Stack(
                  children: [
                    Column(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/fridge.jpg'),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            // child: BackdropFilter(
                            //   filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                            // ),
                            // child: Image.asset('assets/images/fridge.jpg'),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(17.0),
                      child: Text(
                        'Now, Find Recipes From The Items You Have In Your Fridge',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                bottomCardHeight: 200,
                bottomCardWidget: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
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
              FlatButton(
                child: Text('Search Screen'),
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SearchScreen()));
                },
              ),
              FlatButton(
                child: Text('FavouritesScreen'),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => FavouritesScreen()));
                },
              ),
              FlatButton(
                child: Text('Settings Screen'),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SettingsScreen()));
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
                    onPressed: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomeScreen())),
                  ),
                  GButton(
                    icon: Icons.search,
                    text: 'Likes',
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SearchScreen())),
                  ),
                  GButton(
                    icon: Icons.favorite,
                    text: 'Favourite',
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
