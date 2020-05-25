import 'dart:ui';

// import 'package:autocomplete_textfield/autocomplete_textfield.dart';
// import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipetap/models/search_suggestions.dart';
import 'package:recipetap/models/userdata.dart';
import 'package:recipetap/pages/home_screen.dart';
// import 'package:recipetap/pages/catagories_screen.dart';
// import 'package:recipetap/pages/favourites_screen.dart';
import 'package:recipetap/pages/search_results.dart';
// import 'package:recipetap/pages/search_screen.dart';
// import 'package:recipetap/pages/settings_screen.dart';
// import 'package:recipetap/provider/auth_provider.dart';
// import 'package:search_app_bar/search_app_bar.dart';
// import 'package:simple_search_bar/simple_search_bar.dart';
// import 'package:slimy_card/slimy_card.dart';
import './search_home_widget.dart';

class HomeScreenWidget extends StatefulWidget {
  @override
  _HomeScreenWidgetState createState() => _HomeScreenWidgetState();
}

class _HomeScreenWidgetState extends State<HomeScreenWidget> {
  // bool search = false;
  TextEditingController controller;

  bool isAuth;
  bool authSkipped;
  String profilePhotoUrl;
  String username;
  String email;

  TextEditingController inclController = TextEditingController();
  TextEditingController exclController = TextEditingController();
  // TextEditingController normalSearchController = TextEditingController();

  // GlobalKey<AutoCompleteTextFieldState<String>> key = GlobalKey();

  // GlobalKey<AutoCompleteTextFieldState<String>> keyy = GlobalKey();

  var searchValue = '';

  @override
  void initState() {
    if (currentUser != null) {
      profilePhotoUrl = currentUser.photoUrl;
      username = currentUser.username;
      email = currentUser.email;
    }

    super.initState();

    inclController = TextEditingController();
    exclController = TextEditingController();
    controller = TextEditingController();
  }

  List<String> suggestions = SearchSuggestions.suggestions;
  @override
  void dispose() {
    inclController.dispose();
    exclController.dispose();
    controller.dispose();
    super.dispose();
  }

  // var _isLoading = false;

  // var isInit = false;

  bool isSearch = false;

  // @override
  // void didChangeDependencies() async {
  //   if (!isInit) {
  //     setState(() {
  //       _isLoading = true;
  //     });

  //     // final auth = Provider.of<AuthProvider>(context, listen: false);

  //     // isAuth = auth.isAuth;
  //     // authSkipped = auth.authSkipped;

  //     _isLoading = false;

  //     isInit = true;
  //   }
  //   super.didChangeDependencies();
  // }

  submitSearch(appBarTitle, dish, incl, excl) {
    controller.clear();
    inclController.clear();
    exclController.clear();

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

  var closedContainerHeight = 10;
  var openContainerHeight = 200;
  BorderRadius openContainerBR = BorderRadius.only(
    bottomLeft: Radius.circular(40),
    bottomRight: Radius.circular(40),
  );
  BorderRadius closedContainerBR = BorderRadius.only(
    bottomLeft: Radius.circular(40),
    bottomRight: Radius.circular(40),
  );
  BoxShadow openContainerBS =
      // BoxShadow(color: Colors.black45),
      BoxShadow(
    blurRadius: 0.6,
    spreadRadius: 0.6,
    color: Colors.black45,
    offset: Offset(0.1, 2.1),
  );

  BoxShadow closedContainerBS = BoxShadow(
    blurRadius: 0.3,
    spreadRadius: 0.3,
    color: Colors.black45,
    offset: Offset(0.1, 2),
  );

  Duration duration = Duration(milliseconds: 200);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: Center(
          child: CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor,
            child: currentUser != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      profilePhotoUrl,
                      fit: BoxFit.cover,
                    ),
                  )
                : Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 32,
                  ),
          ),
        ),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              currentUser != null
                  ? 'Welcome, ${username.split(" ")[0]}!'
                  : 'Welcome!',
            ),
            Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: Text(
                "What would you like to have today?",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
              ),
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                // Provider.of<AuthProvider>(context, listen: false).logout();
                isSearch = !isSearch;
                setState(() {});
              })
        ],
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              AnimatedContainer(
                duration: duration,
                height: isSearch
                    ? 200
                    : 120 -
                        MediaQuery.of(context).padding.top -
                        AppBar().preferredSize.height,
                child: Stack(
                  children: [
                    AnimatedContainer(
                      duration: duration,
                      height: isSearch
                          ? 200
                          : 120 -
                              MediaQuery.of(context).padding.top -
                              AppBar().preferredSize.height,
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                    AnimatedContainer(
                      duration: duration,
                      height: isSearch
                          ? 200
                          : 120 -
                              MediaQuery.of(context).padding.top -
                              AppBar().preferredSize.height,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius:
                            isSearch ? openContainerBR : closedContainerBR,
                        boxShadow: [
                          if (isSearch) openContainerBS else closedContainerBS,
                        ],
                      ),
                      child: isSearch
                          ? AnimatedContainer(
                              duration: duration,
                              child: SingleChildScrollView(
                                child: SearchHomeWidget(
                                  controller: controller,
                                  // key: key,
                                  suggestions: suggestions,
                                  inclController: inclController,
                                  // keyy: keyy,
                                  exclController: exclController,
                                  submitSearch: submitSearch,
                                ),
                              ),
                            )
                          : AnimatedContainer(
                              duration: duration,
                            ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () => {},
                  //  Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) => SearchScreen())),
                  child: Stack(
                    children: [
                      Column(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: Container(
                              child: Image.asset(
                                'assets/images/fridge.jpg',
                                fit: BoxFit.cover,
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
                          'Find Recipes From The Items In Your Fridge'
                              .toUpperCase(),
                          textAlign: TextAlign.right,
                          style: Theme.of(context).textTheme.caption.copyWith(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w200,
                                wordSpacing: 2,
                                letterSpacing: 1.2,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
