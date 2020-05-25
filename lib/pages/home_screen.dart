// import 'package:autocomplete_textfield/autocomplete_textfield.dart';
// import 'dart:ui';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:floating_search_bar/floating_search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_chips_input/flutter_chips_input.dart';
import 'package:recipetap/models/search_suggestions.dart';
import 'package:recipetap/models/userdata.dart';
import 'package:recipetap/pages/catagories_screen.dart';
import 'package:recipetap/pages/favourites_screen.dart';
import 'package:recipetap/pages/login_page.dart';
// import 'package:recipetap/pages/login_page.dart';
import 'package:recipetap/pages/search_results.dart';
// import 'package:recipetap/pages/search_screen.dart';
import 'package:recipetap/pages/settings_screen.dart';
import 'package:recipetap/provider/recently_viewed_provider.dart';
import 'package:recipetap/widgets/home_screen_widget.dart';
import '../provider/auth_provider.dart';
// import 'package:slimy_card/slimy_card.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();
final usersRef = Firestore.instance.collection('users');
User currentUser;

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);
  static const routeName = 'home_screen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool isAuth = false;
  bool authSkipped = false;

  String username;
  String profilePhotoUrl;
  String email;

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

    googleSignIn.onCurrentUserChanged.listen(
      (account) {
        handleSignIn(account);
      },
      onError: (err) {
        print('Error signing in: $err');
      },
    );
    googleSignIn
        .signInSilently(
      suppressErrors: false,
    )
        .then((account) {
      handleSignIn(account);
    }).catchError((err) {
      print('SilentSignInError $err');
    });

    super.initState();
  }

  login() {
    googleSignIn.signIn();
  }

  logout() {
    googleSignIn.signOut();
  }

  handleSignIn(GoogleSignInAccount account) async {
    if (account != null) {
      // print('$account');
      await createUserInFirestore();
      setState(() {
        isAuth = true;
      });
    } else {
      setState(() {
        isAuth = false;
      });
    }
  }

  createUserInFirestore() async {
    // check if user exists in users collection in database(acc to their id)
    final GoogleSignInAccount user = googleSignIn.currentUser;
    DocumentSnapshot doc = await usersRef.document(user.email).get();
    // DocumentSnapshot doc = await usersRef.document(user.id).get();
    if (!doc.exists) {
      await usersRef.document(user.email).setData({
        "email": user.email,
        "photoUrl": user.photoUrl,
        "username": user.displayName,
      });
      doc = await usersRef.document(user.email).get();
    }
    currentUser = User.fromDocument(doc);
    print(currentUser);
    setState(() {
      isAuth = true;
    });
    print(currentUser.username);
  }

  // var isInit = false;
  // var _isLoading = false;

  // @override
  // void didChangeDependencies() {
  //   if (!isInit) {
  //     setState(() {
  //       _isLoading = true;
  //     });
  //     final auth = Provider.of<AuthProvider>(context);
  //     isAuth = auth.isAuth;
  //     print(isAuth);
  //     // username = auth.username;
  //     // profilePhotoUrl = auth.profilePhotoUrl;
  //     // email = auth.email;

  //     // isAuth = true;
  //     setState(() {
  //       _isLoading = false;
  //     });
  //     isInit = true;
  //   }
  //   super.didChangeDependencies();
  // }

// TODO: Min SDK 16

  List<String> suggestions = SearchSuggestions.suggestions;
  @override
  void dispose() {
    inclController.dispose();
    exclController.dispose();
    normalSearchController.dispose();
    super.dispose();
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

  var searchValue = '';

  @override
  Widget build(BuildContext context) {
    // final auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      // TODO: Searchlist images resolution full

      body: isAuth
          ? PageView(
              controller: pageController,
              children: <Widget>[
                HomeScreenWidget(),
                Consumer<RecentsProvider>(
                    builder: (context, recents, _) => CategoriesScreen()),
                Consumer<RecentsProvider>(
                    builder: (context, recents, _) => FavouritesScreen()),
                // SearchScreen(),
                SettingsScreen(),
              ],
              onPageChanged: (i) {
                _selectedIndex = i;
                setState(() {});
              },
              // pageSnapping: false,
            )
          : LoginPage(),
      bottomNavigationBar: isAuth
          ? Container(
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1))
              ]),
              child: SafeArea(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
                  child: GNav(
                    gap: 8,
                    activeColor: Colors.white,
                    iconSize: 24,
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
                        icon: Icons.account_circle,
                        text: 'Profile',
                      ),
                    ],
                    selectedIndex: _selectedIndex,
                    onTabChange: (index) {
                      setState(() {
                        pageController.animateToPage(
                          index,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.fastOutSlowIn,
                        );
                        _selectedIndex = index;
                      });
                    },
                  ),
                ),
              ),
            )
          : null,
    );
  }
}
