import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipetap/pages/catagories_screen.dart';
import 'package:recipetap/pages/favourites_screen.dart';
import 'package:recipetap/pages/search_results.dart';
import 'package:recipetap/pages/search_screen.dart';
import 'package:recipetap/pages/settings_screen.dart';
import 'package:recipetap/provider/auth_provider.dart';
// import 'package:search_app_bar/search_app_bar.dart';
// import 'package:simple_search_bar/simple_search_bar.dart';
import 'package:slimy_card/slimy_card.dart';

class HomeScreenWidget extends StatefulWidget {
  @override
  _HomeScreenWidgetState createState() => _HomeScreenWidgetState();
}

class _HomeScreenWidgetState extends State<HomeScreenWidget> {
  bool search = false;
  TextEditingController controller;

  bool isAuth;
  bool authSkipped;
  String profilePhotoUrl;
  String username;
  String email;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = TextEditingController();
  }

  var _isLoading = false;

  var isInit = false;

  @override
  void didChangeDependencies() async {
    if (!isInit) {
      setState(() {
        _isLoading = true;
      });

      final auth = Provider.of<AuthProvider>(context, listen: false);

      profilePhotoUrl = auth.profilePhotoUrl;
      username = auth.username;
      email = auth.email;

      isAuth = auth.isAuth;
      authSkipped = auth.authSkipped;

      _isLoading = false;

      isInit = true;
    }
    super.didChangeDependencies();
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

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: !search
          ? AppBar(
              leading: Center(
                  child: CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                child: !isAuth
                    ? Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 32,
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          profilePhotoUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                // backgroundColor: ,
              )),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(isAuth
                      ? 'Welcome, ${username.split(" ")[0]}!'
                      : 'Welcome!'),
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Text(
                      "What would you like to have today?",
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                    ),
                  ),
                ],
              ),
              // centerTitle: true,
              actions: <Widget>[
                IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      Provider.of<AuthProvider>(context, listen: false)
                          .logout();
                      // search = true;
                      // setState(() {});
                    })
              ],
            )
          : AppBar(
              leading: Icon(Icons.search),
              title: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                    controller: controller,
                    autofocus: true,
                    onSubmitted: (query) {
                      submitSearch(
                        controller.text.trim().isNotEmpty
                            ? "Showing Results For " + controller.text
                            : "Showing Recipes From Ingredients",
                        controller.text.replaceAll(" ", "%20").toLowerCase(),
                        "",
                        "",
                      );
                      controller.clear();
                    }
                    // TODO SLiver Incl Excl Search
                    // TODO all appbars arrow back ios
                    ),
              ),
              actions: <Widget>[
                IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      search = false;
                      controller.clear();
                      setState(() {});
                    })
              ],
            ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SearchScreen())),
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
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: SlimyCard(
              //     color: Colors.deepPurple,
              //     width: MediaQuery.of(context).size.width * 0.95,
              //     borderRadius: 25,
              //     topCardHeight: 275,
              //     // 235
              //     topCardWidget: Stack(
              //       children: [
              //         Column(
              //           children: <Widget>[
              //             ClipRRect(
              //               borderRadius: BorderRadius.circular(25),
              //               child: Container(
              //                 child: Image.asset(
              //                   'assets/images/fridge.jpg',
              //                   fit: BoxFit.cover,
              //                 ),

              //                 // child: BackdropFilter(
              //                 //   filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
              //                 // ),
              //                 // child: Image.asset('assets/images/fridge.jpg'),
              //               ),
              //             ),
              //             SizedBox(
              //               height: 20,
              //             ),
              //           ],
              //         ),
              //         Padding(
              //           padding: const EdgeInsets.all(17.0),
              //           child: Text(
              //             'Find Recipes From The Items In Your Fridge'
              //                 .toUpperCase(),
              //             textAlign: TextAlign.center,
              //             style: Theme.of(context).textTheme.caption.copyWith(
              //                   color: Colors.white,
              //                   fontSize: 30,
              //                   fontWeight: FontWeight.w200,
              //                   wordSpacing: 2,
              //                   letterSpacing: 1.2,
              //                 ),
              //           ),
              //         ),
              //       ],
              //     ),
              //     bottomCardHeight: 200,
              //     bottomCardWidget: Container(
              //       decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(30),
              //       ),
              //     ),
              //   ),
              // ),
//
//
//
//
//
//
//
//
//
              // Text("Recently Viewed"),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: SlimyCard(
              //     topCardHeight: 150,
              //     bottomCardHeight: 250,
              //     color: Theme.of(context).primaryColor,
              //     width: MediaQuery.of(context).size.width,
              //     topCardWidget: Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       crossAxisAlignment: CrossAxisAlignment.center,
              //       children: <Widget>[
              //         Icon(Icons.history),
              //         Text('RECENTS'),
              //       ],
              //     ),
              //   ),
              // ),

              //
//
//
//
//
//
//
//
//
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
    );
  }
}
