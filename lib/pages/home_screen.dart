// import 'package:autocomplete_textfield/autocomplete_textfield.dart';
// import 'dart:ui';

// import 'package:autocomplete_textfield/autocomplete_textfield.dart';
// import 'package:clay_containers/clay_containers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:recipetap/models/search_suggestions.dart';
import 'package:recipetap/models/userdata.dart';
import 'package:recipetap/pages/catagories_screen.dart';
import 'package:recipetap/pages/categories_recipe_screen.dart';
import 'package:recipetap/pages/favourites_screen.dart';
import 'package:recipetap/pages/recipe_view_page.dart';
import 'package:recipetap/pages/search_results.dart';
import 'package:recipetap/pages/settings_screen.dart';
import 'package:recipetap/provider/recently_viewed_provider.dart';
import 'package:recipetap/widgets/home_screen_widget.dart';
import 'package:recipetap/widgets/loading_spinner.dart';
import 'package:url_launcher/url_launcher.dart';
// import '../provider/auth_provider.dart';
// import 'package:slimy_card/slimy_card.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();
final usersRef = Firestore.instance.collection('users');
User currentUser;
bool authSkipped = true;

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);
  static const routeName = 'home_screen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool isAuth = false;
  // bool authSkipped = false;

  String username;
  String profilePhotoUrl;
  String email;

  bool isLoading = true;
  TextEditingController inclController = TextEditingController();
  TextEditingController exclController = TextEditingController();
  TextEditingController normalSearchController = TextEditingController();

  PageController pageController = PageController();

  // GlobalKey<AutoCompleteTextFieldState<String>> key = GlobalKey();

  // GlobalKey<AutoCompleteTextFieldState<String>> keyy = GlobalKey();

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

    initialize();

    super.initState();
    setState(() {
      isLoading = false;
    });
  }

  initialize() async {
    await init();
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

  _HomeScreenState._();

  factory _HomeScreenState() => _instance;

  static final _HomeScreenState _instance = _HomeScreenState._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool _initialized = false;

  Future<void> init() async {
    if (!_initialized) {
      // For iOS request permission first.
      _firebaseMessaging.requestNotificationPermissions();
      _firebaseMessaging.configure(
        // Foreground Notif
        onMessage: (Map<String, dynamic> message) async {
          print(message.toString());
          serialiseAndNavigate(message);
        },
        // Closed
        onLaunch: (Map<String, dynamic> message) async {
          print(message.toString());
          serialiseAndNavigate(message);
        },
        // Background
        onResume: (Map<String, dynamic> message) async {
          print(message.toString());
          serialiseAndNavigate(message);
        },
      );

      // For testing purposes print the Firebase Messaging token
      String token = await _firebaseMessaging.getToken();
      print("FirebaseMessaging token: $token");

      _initialized = true;
    }
  }

  void serialiseAndNavigate(Map<String, dynamic> message) async {
    var notificationData = message['data'];
    var view = notificationData['view'];

// TODO
// TODO
// TODO
// click_action
// FLUTTER_NOTIFICATION_CLICK

// Method Triggers
// TODO
// TODO
// TODO

    if (view != null) {
      // Navigate to any view
      if (view == "fav") {
        pageController.animateToPage(2,
            duration: Duration(milliseconds: 150), curve: Curves.ease);
        setState(() {});
      }

      if (view == "preferences") {
        pageController.animateToPage(3,
            duration: Duration(milliseconds: 150), curve: Curves.ease);
        setState(() {});
      }

      if (view == "categories") {
        pageController.animateToPage(1,
            duration: Duration(milliseconds: 150), curve: Curves.ease);
        setState(() {});
      }

      if (view == "recipe") {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => RecipeViewPage(
                  url: notificationData['url'],
                  coverImageUrl: notificationData['coverImg'],
                )));
      }

      if (view == "category") {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => CategoryRecipesScreen(
                  url: notificationData['url'],
                  categoryName: notificationData['categoryName'],
                )));
      }

      if (view == "categoryOptions") {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => SearchResultsScreen(
                  url: notificationData['url'],
                  appBarTitle: notificationData['appbarTitle'],
                  excl: "",
                  incl: "",
                  categoryOption: true,
                  // categoryName: notificationData['categoryName'],
                )));
      }

      if (view == "rateUs") {
        const url =
            "https://play.google.com/store/apps/details?id=com.gauravxdhingra.recipetap";
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          throw 'Could not launch $url';
        }

        // Navigator.of(context).push(MaterialPageRoute(
        //     builder: (context) => SearchResultsScreen(
        //           url: notificationData['url'],
        //           appBarTitle: notificationData['appbarTitle'],
        //           excl: "",
        //           incl: "",
        //           categoryOption: true,
        //           // categoryName: notificationData['categoryName'],
        //         )));
      }
    }
  }

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
    // print(MediaQuery.of(context).size.height.toString() +
    //     "w" +
    //     MediaQuery.of(context).size.width.toString());
    print(Theme.of(context).scaffoldBackgroundColor);
    return Scaffold(
      body:
          // (isAuth || authSkipped)
          //     ?
          isLoading
              ? LoadingSpinner(
                  size: 100,
                  color: Colors.grey,
                )
              : PageView(
                  controller: pageController,
                  physics: PageScrollPhysics(),
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
                  pageSnapping: false,
                ),
      // : LoginPage(),
      bottomNavigationBar: isAuth || authSkipped
          ? Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.white
                      : Theme.of(context).primaryColor,
                  // color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 20, color: Colors.black.withOpacity(.1))
                  ]),
              child: SafeArea(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
                  child: GNav(
                    // backgroundColor: Theme.of(context).primaryColor,
                    gap: 8,
                    activeColor: Colors.white,
                    iconSize: 24,
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    duration: Duration(milliseconds: 800),
                    tabBackgroundColor: Theme.of(context).accentColor,

                    textStyle: Theme.of(context)
                        .textTheme
                        .button
                        .copyWith(color: Colors.white),
                    tabs: [
                      GButton(
                        icon: Icons.home,
                        text: 'Home',
                        iconColor:
                            Theme.of(context).brightness == Brightness.light
                                ? Theme.of(context).accentColor.withOpacity(0.6)
                                : Colors.white,
                      ),
                      GButton(
                        icon: Icons.category,
                        text: 'Categories',
                        iconColor:
                            Theme.of(context).brightness == Brightness.light
                                ? Theme.of(context).accentColor.withOpacity(0.6)
                                : Colors.white,
                      ),
                      GButton(
                        icon: Icons.favorite,
                        text: 'Favourites',
                        iconColor:
                            Theme.of(context).brightness == Brightness.light
                                ? Theme.of(context).accentColor.withOpacity(0.6)
                                : Colors.white,
                      ),
                      GButton(
                        icon: Icons.settings,
                        text: 'Preferences',
                        iconColor:
                            Theme.of(context).brightness == Brightness.light
                                ? Theme.of(context).accentColor.withOpacity(0.6)
                                : Colors.white,
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
