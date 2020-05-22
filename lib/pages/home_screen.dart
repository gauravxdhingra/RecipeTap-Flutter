// import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'dart:ui';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:clay_containers/clay_containers.dart';
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
import 'package:recipetap/widgets/home_screen_widget.dart';
// import 'package:simple_search_bar/simple_search_bar.dart';
import 'package:slimy_card/slimy_card.dart';

// TODO GIPHY Navbar

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);
  static const routeName = 'home_screen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  TextEditingController inclController = TextEditingController();
  TextEditingController exclController = TextEditingController();
  TextEditingController normalSearchController = TextEditingController();

  PageController pageController = PageController();

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
    pageController = PageController();
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

  // submitSearch(incl, excl) {
  //   Navigator.of(context).push(MaterialPageRoute(
  //       builder: (context) => SearchResultsScreen(

  //           url:
  //               'https://www.allrecipes.com/search/results/?ingIncl=$incl&ingExcl=$excl&sort=re')));
  //   print(
  //       'https://www.allrecipes.com/search/results/?ingIncl=$incl&ingExcl=$excl&sort=re');
  // }

  submitSearchNormal(String appbarTitle, String url) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => SearchResultsScreen(
            appBarTitle: appbarTitle,
            url: 'https://www.allrecipes.com/search/results/?wt=$url&sort=re'
            // url: url,
            )));
    print(url);
  }

  var searchValue = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // TODO Custom Name Appbar
      // TODO: Searchlist images resolution full

      body: PageView(
        controller: pageController,
        children: <Widget>[
          HomeScreenWidget(),
          CategoriesScreen(),
          FavouritesScreen(),
          SearchScreen(),
          SettingsScreen(),
        ],
        onPageChanged: (i) {
          _selectedIndex = i;
          setState(() {});
        },
        pageSnapping: true,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1))
        ]),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
            child: GNav(
              gap: 8,
              activeColor: Colors.white,
              iconSize: 22,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              duration: Duration(milliseconds: 800),
              tabBackgroundColor: Colors.grey[800],
              tabs: [
                GButton(
                  icon: Icons.home,
                  text: 'Home',
                ),
                // TODO Category pageview
                GButton(
                  icon: Icons.category,
                  text: 'Categories',
                ),
                GButton(
                  icon: Icons.favorite,
                  text: 'Favourites',
                ),
                GButton(
                  icon: Icons.search,
                  text: 'Search',
                ),
                GButton(
                  icon: Icons.account_circle,
                  text: 'Profile',
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  pageController.jumpToPage(index);
                  _selectedIndex = index;
                });
              },
            ),
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
