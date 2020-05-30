import 'dart:ui';

// import 'package:autocomplete_textfield/autocomplete_textfield.dart';
// import 'package:clay_containers/clay_containers.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chips_input/flutter_chips_input.dart';
// import 'package:provider/provider.dart';
import 'package:recipetap/models/category_model.dart';
import 'package:recipetap/models/favourites_model.dart';
import 'package:recipetap/models/search_suggestions.dart';
// import 'package:recipetap/models/userdata.dart';
import 'package:recipetap/pages/categories_recipe_screen.dart';
import 'package:recipetap/pages/home_screen.dart';
// import 'package:recipetap/pages/recipe_view_page.dart';
// import 'package:recipetap/pages/catagories_screen.dart';
// import 'package:recipetap/pages/favourites_screen.dart';
import 'package:recipetap/pages/search_results.dart';
import 'package:recipetap/provider/recently_viewed_provider.dart';
import 'package:recipetap/utility/shared_prefs.dart';
// import 'package:recipetap/pages/search_screen.dart';
// import 'package:recipetap/pages/settings_screen.dart';
// import 'package:recipetap/provider/auth_provider.dart';
// import 'package:search_app_bar/search_app_bar.dart';
// import 'package:simple_search_bar/simple_search_bar.dart';
// import 'package:slimy_card/slimy_card.dart';
// import './search_home_widget.dart';
import 'home_screen_widgets/recommended_categories_builder.dart';
import 'home_screen_widgets/recommended_recipes_builder.dart';
import 'home_screen_widgets/time_of_the_day.dart';
// import 'package:slide_popup_dialog/slide_popup_dialog.dart' as slideDialog;

class HomeScreenWidget extends StatefulWidget {
  @override
  _HomeScreenWidgetState createState() => _HomeScreenWidgetState();
}

class _HomeScreenWidgetState extends State<HomeScreenWidget> {
  // bool search = false;
  TextEditingController controller;
  int time;
  bool isAuth;
  bool authSkipped;
  String profilePhotoUrl;
  String username;
  String email;
  int i = 0;
  bool isloading = true;
  String diet;

  TextEditingController inclController = TextEditingController();
  TextEditingController exclController = TextEditingController();
  // TextEditingController normalSearchController = TextEditingController();

  // GlobalKey<AutoCompleteTextFieldState<String>> key = GlobalKey();

  // GlobalKey<AutoCompleteTextFieldState<String>> keyy = GlobalKey();

  var searchValue = '';

  List<dynamic> include = [];
  List exclude = [];
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    if (currentUser != null) {
      profilePhotoUrl = currentUser.photoUrl;
      username = currentUser.username;
      email = currentUser.email;
    }
    time = DateTime.now().hour;
    _scaffoldKey = GlobalKey<ScaffoldState>();
    inclController = TextEditingController();
    exclController = TextEditingController();
    controller = TextEditingController();
    fetchRecommended();
    super.initState();
  }

  List<String> suggestions = SearchSuggestions.suggestions;

  List<FavouritesModel> recommended = [];
  List<CategoryModel> recommendedCategoriesList = [];

  fetchRecommended() async {
    List<FavouritesModel> _favslist = [];
    QuerySnapshot recents = await favoritesRef
        .document("grvdhingra1999@gmail.com")
        .collection('favs')
        .orderBy(
          'timestamp',
          descending: true,
        )
        .getDocuments();
    recents.documents.forEach((DocumentSnapshot doc) {
      print(doc);
      _favslist.add(FavouritesModel.fromDocument(doc));
    });
    recommended = _favslist;
    //
    // isloading=false;
    List<CategoryModel> _favcatslist = [];
    QuerySnapshot recentsc = await favoriteCategoriesRef
        .document("grvdhingra1999@gmail.com")
        .collection('favs')
        .orderBy(
          'timestamp',
          descending: true,
        )
        .getDocuments();

    recentsc.documents.forEach((DocumentSnapshot doc) {
      print(doc);
      _favcatslist.add(CategoryModel.fromDocument(doc));
    });
    recommendedCategoriesList = _favcatslist;
    setState(() {
      isloading = false;
    });
  }

  // @override
  // void dispose() {
  //   inclController.dispose();
  //   exclController.dispose();
  //   controller.dispose();
  //   super.dispose();
  // }

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

  submitSearch(appBarTitle, dish) async {
    try {
      diet = await getDiet();
      if (controller.text.trim().isEmpty &&
          include.isEmpty &&
          exclude.isEmpty) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Enter A Recipe Or Ingredients To Search"),
        ));
        // print("No Search Query");
        return;
      }

      bool conflict = false;

      if (include.isNotEmpty) {
        include.forEach((element) {
          conflict = exclude.contains(element);
          if (conflict == true) {
            _scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text("Same Item Can't Be Included And Excluded"),
            ));
            return;
          }
        });
      } else {
        exclude.forEach((element) {
          conflict = include.contains(element);
          if (conflict == true) {
            _scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text("Same Item Can't Be Included And Excluded"),
            ));
            return;
          }
        });
      }

      if (!conflict) {
        controller.clear();
        inclController.clear();
        exclController.clear();

        String incl = include
            .toString()
            .split("[")[1]
            .split("]")[0]
            .replaceAll(", ", ",")
            .toLowerCase()
            .replaceAll(", ", ",")
            .replaceAll(" ", "%20")
            .replaceAll("-", "%2d")
            .replaceAll("/", "%2f");

        String excl = exclude
            .toString()
            .split("[")[1]
            .split("]")[0]
            .replaceAll(", ", ",")
            .toLowerCase()
            .replaceAll(", ", ",")
            .replaceAll(" ", "%20")
            .replaceAll("-", "%2d")
            .replaceAll("/", "%2f");

        String exclext = "";
        if (diet == "all") {
          if (excl.isNotEmpty) {
            exclext = ",beef,pork,ham,steak,veal,buffalo";
          } else
            exclext = "beef,pork,ham,veal,buffalo";
        }
        if (diet == "chicken") {
          if (excl.isNotEmpty) {
            exclext =
                ",beef,pork,ham,bacon,turkey,lamb,steak,duck,camel,goat,quail,shrimp,prawn,crab,lobster,oyster,chevon,veal,buffalo";
          } else
            exclext =
                "beef,pork,ham,bacon,turkey,lamb,steak,duck,camel,goat,quail,shrimp,prawn,crab,lobster,oyster,chevon,veal,buffalo";
        }
        if (diet == "veg") {
          if (excl.isNotEmpty) {
            exclext =
                ",fish,salmon,tuna,chicken,mutton,egg,beef,pork,ham,bacon,turkey,lamb,steak,duck,camel,goat,quail,shrimp,prawn,crab,lobster,oyster,chevon,veal,buffalo";
          } else
            exclext =
                "fish,salmon,tuna,chicken,mutton,egg,beef,pork,ham,bacon,turkey,lamb,steak,duck,camel,goat,quail,shrimp,prawn,crab,lobster,oyster,chevon,veal,buffalo";
        }
        isSearch = await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SearchResultsScreen(
              exclude: exclude,
              include: include,
              appBarTitle: appBarTitle,
              incl: incl,
              excl: excl,
              categoryOption: false,
              url:
                  'https://www.allrecipes.com/search/results/?wt=$dish&ingIncl=$incl&ingExcl=$excl$exclext&sort=re',
            ),
          ),
        );
        print("************************" +
            'https://www.allrecipes.com/search/results/?wt=$dish&ingIncl=$incl&ingExcl=$excl$exclext&sort=re');
      }
    } catch (e) {
      print(e);
    }
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

  Duration duration = Duration(milliseconds: 400);
  Curve curve = Curves.ease;

  // _showDialog(Widget child) {
  //   slideDialog.showSlideDialog(
  //     context: context,
  //     child: child,
  //   );
  // }

  mealsFromCategory(categoryUrl, context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CategoryRecipesScreen(url: categoryUrl)));
  }

  void onButtonPressed(Widget child) {
    showModalBottomSheet(
        // isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
        ),
        enableDrag: true,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            // physics: NeverScrollableScrollPhysics(),

            child: Container(
              child: child,
              height: MediaQuery.of(context).size.height * 0.8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                color: Theme.of(context).canvasColor,
              ),
            ),
          );
        });
  }

  // String validateSearch() {
  //   if (controller.text.trim().isEmpty && exclude.isEmpty && include.isEmpty) {
  //     return "Enter a recipe or ingredients to search";
  //   }
  //   return null;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        leading: isSearch
            ? null
            : AnimatedContainer(
                curve: curve,
                duration: duration,
                child: Center(
                  child: ClayContainer(
                    color: Theme.of(context).primaryColor,
                    spread: 4,
                    borderRadius: 20,
                    depth: 50,
                    child: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      child: currentUser != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                currentUser.photoUrl,
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
                ),
              ),
        title: !isSearch
            ? AnimatedContainer(
                curve: curve,
                duration: duration,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      currentUser != null
                          ? 'Welcome, ${currentUser.username.split(" ")[0]} !'
                          : 'Welcome!',
                      style: Theme.of(context).textTheme.headline1.copyWith(
                            fontSize: 22,
                            color: Colors.white,
                          ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: Text(
                        "What would you like to have today?",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w300),
                      ),
                    ),
                  ],
                ),
              )
            : AnimatedContainer(
                curve: curve,
                duration: duration,
                child: TextFormField(
                  // validator: (_) => validateSearch(),

                  controller: controller,
                  onFieldSubmitted: (val) {
                    submitSearch(
                      controller.text.trim().isNotEmpty
                          ? "Showing Results For " + controller.text
                          : "Showing Recipes From Ingredients",
                      controller.text.replaceAll(" ", "%20").toLowerCase(),
                    );
                  },
                  decoration: InputDecoration(
                    hintText: "Search Recipes",
                    hintStyle: TextStyle(color: Colors.white),

                    // errorText: validateSearch(),
                  ),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  autofocus: true,
                  textInputAction: TextInputAction.search,
                  cursorColor: Colors.white,
                ),
              ),
        // Text(
        //     'Search For Recipes',
        //     style: Theme.of(context).textTheme.headline1.copyWith(
        //         fontSize: 20,
        //         color: Theme.of(context).textTheme.bodyText1.color),
        //   ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 7.0, bottom: 3, top: 3),
            child: AnimatedContainer(
              curve: curve,
              duration: duration,
              child: ClayContainer(
                color: Theme.of(context).primaryColor,
                spread: 4,
                borderRadius: 45,
                depth: 50,
                child: IconButton(
                    icon: Icon(
                      isSearch ? Icons.close : Icons.search,
                    ),
                    onPressed: () {
                      // Provider.of<AuthProvider>(context, listen: false).logout();
                      isSearch = !isSearch;
                      controller.clear();
                      include = [];
                      exclude = [];
                      setState(() {});
                    }),
              ),
            ),
          )
        ],
      ),
      body: Container(
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            children: <Widget>[
              searchAnimatedContainer(context),
              Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      if (MediaQuery.of(context).size.height > 740)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                          child: Text(
                            "Recommended Categories".toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .headline1
                                .copyWith(fontSize: 20),
                          ),
                        ),
                      if (isloading)
                        Padding(
                          padding: MediaQuery.of(context).size.height > 740
                              ? EdgeInsets.all(0)
                              : EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                          child: recommendedCategoriesBuilder(
                              context,
                              [
                                CategoryModel(
                                  title: "",
                                  categoryUrl: "",
                                  timestamp: null,
                                ),
                                CategoryModel(
                                  title: "",
                                  categoryUrl: "",
                                  timestamp: null,
                                ),
                                CategoryModel(
                                  title: "",
                                  categoryUrl: "",
                                  timestamp: null,
                                ),
                              ],
                              null),
                        ),
                      if (!isloading)
                        recommendedCategoriesBuilder(context,
                            recommendedCategoriesList, mealsFromCategory),
                      if (time >= 6 && time < 12)
                        timeRecommendation(
                          context,
                          "Treat Yourself With A Healthy Breakfast",
                          "assets/images/timesofday/morning.jpg",
                          'https://www.allrecipes.com/recipes/78/breakfast-and-brunch/',
                          TextStyle(color: Colors.black),
                        ),
                      if (time >= 12 && time < 16)
                        timeRecommendation(
                          context,
                          "It's Lunch Time",
                          "assets/images/timesofday/noon.jpg",
                          'https://www.allrecipes.com/recipes/17561/lunch/',
                          TextStyle(color: Colors.black),
                        ),
                      if (time >= 16 && time < 19)
                        timeRecommendation(
                          context,
                          "Desserts Can Make Eves Beautiful !",
                          "assets/images/timesofday/eve.jpg",
                          'https://www.allrecipes.com/recipes/79/desserts/',
                          TextStyle(color: Colors.white),
                        ),
                      if (time >= 19 && time <= 23)
                        timeRecommendation(
                          context,
                          "Finally, It's Dinner Time!",
                          "assets/images/timesofday/night.jpg",
                          'https://www.allrecipes.com/recipes/17562/dinner/',
                          TextStyle(color: Colors.white),
                        ),
                      if (time >= 0 && time < 6)
                        timeRecommendation(
                          context,
                          "Late Night Cravings? We're Here!",
                          "assets/images/fridge.jpg",
                          "https://www.allrecipes.com/recipes/454/everyday-cooking/more-meal-ideas/15-minute-meals/",
                          TextStyle(color: Colors.white),
                        ),
                      if (MediaQuery.of(context).size.height > 740)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                          child: Text(
                            "Recommended Recipes".toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .headline1
                                .copyWith(fontSize: 20),
                          ),
                        ),
                      if (isloading)
                        recommendedRecipesBuilder(context, [
                          FavouritesModel(
                            title: "",
                            desc: "",
                            coverPhotoUrl: "",
                            timestamp: null,
                            recipeUrl: "",
                          ),
                          FavouritesModel(
                            title: "",
                            desc: "",
                            coverPhotoUrl: "",
                            timestamp: null,
                            recipeUrl: "",
                          ),
                          FavouritesModel(
                            title: "",
                            desc: "",
                            coverPhotoUrl: "",
                            timestamp: null,
                            recipeUrl: "",
                          ),
                        ]),
                      if (!isloading)
                        recommendedRecipesBuilder(context, recommended),
                    ],
                  ),
                  if (isSearch)
                    GestureDetector(
                      onDoubleTap: () {
                        isSearch = false;
                        setState(() {});
                      },
                      onLongPress: () {
                        isSearch = false;
                        setState(() {});
                      },
                      child: AnimatedContainer(
                        curve: curve,
                        duration: duration,
                        height: isSearch
                            ? MediaQuery.of(context).size.height - 140
                            : 120 -
                                MediaQuery.of(context).padding.top -
                                AppBar().preferredSize.height,
                        width: MediaQuery.of(context).size.width,
                        color: !isSearch
                            ? Colors.transparent
                            : Color(0xff0f0f0f).withOpacity(0.6),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 110),
                          child: Text(
                            "Double Tap Or Hold Here To Cancel Search",
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  AnimatedContainer searchAnimatedContainer(BuildContext context) {
    return AnimatedContainer(
      curve: curve,
      duration: duration,
      height: isSearch
          ? 140
          : 120 -
              MediaQuery.of(context).padding.top -
              AppBar().preferredSize.height,
      child: Stack(
        children: [
          AnimatedContainer(
            curve: curve,
            duration: Duration(milliseconds: 0),
            height: isSearch
                ? 140
                : 120 -
                    MediaQuery.of(context).padding.top -
                    AppBar().preferredSize.height,
            color: !isSearch
                ? Theme.of(context).scaffoldBackgroundColor
                : Color(0xff0f0f0f).withOpacity(0.6),
            // Theme.of(context).scaffoldBackgroundColor,
          ),
          AnimatedContainer(
            curve: curve,
            duration: duration,
            height: isSearch
                ? 140
                : 120 -
                    MediaQuery.of(context).padding.top -
                    AppBar().preferredSize.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: isSearch ? openContainerBR : closedContainerBR,
              boxShadow: [
                if (isSearch) openContainerBS else closedContainerBS,
              ],
            ),
            child: isSearch
                ? Stack(
                    children: <Widget>[
                      AnimatedContainer(
                        curve: curve,
                        duration: duration,
                        child: SingleChildScrollView(
                          child:
                              //  SearchHomeWidget(
                              //   controller: controller,
                              //   // key: key,
                              //   suggestions: suggestions,
                              //   inclController: inclController,
                              //   // keyy: keyy,
                              //   exclController: exclController,
                              //   submitSearch: submitSearch,
                              // ),
                              Column(
                            children: <Widget>[
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  // crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    InkWell(
                                      onTap: () => onButtonPressed(
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          // mainAxisAlignment: MainAxisAlignment.end,
                                          children: <Widget>[
                                            Align(
                                              alignment: Alignment.topCenter,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  height: 7,
                                                  width: 50,
                                                  decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .accentColor
                                                        .withOpacity(0.5),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 10),
                                              child: Text(
                                                "Add Ingredients",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2
                                                    .copyWith(
                                                        fontSize: 22,
                                                        fontWeight:
                                                            FontWeight.w300),
                                              ),
                                            ),

                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                // vertical: 20,
                                                horizontal: 20,
                                              ),
                                              child: ChipsInput(
                                                initialValue: include,
                                                //  includei
                                                //     .split("[")[1]
                                                //     .split("]")[0]
                                                //     .split(",")
                                                //     .toList(),
                                                //     .forEach((element) {
                                                //   include[i] =
                                                //       element.toString();
                                                //   i++;
                                                // }),

                                                decoration: InputDecoration(
                                                  labelText:
                                                      'Select Ingredients',
                                                  // counter: Text(
                                                  //   include.length
                                                  //           .toString() ??
                                                  //       "0",
                                                  // ),
                                                ),
                                                onChanged: (data) {
                                                  // includei =
                                                  //     data.toString();
                                                  include = data;
                                                  print(include);
                                                  // setState(() {});
                                                  // print(includei);
                                                },
                                                chipBuilder:
                                                    (context, state, profile) {
                                                  return InputChip(
                                                    key: ObjectKey(profile),
                                                    label: Text(profile),
                                                    onDeleted: () => state
                                                        .deleteChip(profile),
                                                    materialTapTargetSize:
                                                        MaterialTapTargetSize
                                                            .shrinkWrap,
                                                  );
                                                },
                                                findSuggestions:
                                                    (String query) {
                                                  if (query.length != 0) {
                                                    var lowercaseQuery =
                                                        query.toLowerCase();
                                                    return SearchSuggestions
                                                        .suggestions
                                                        .where((ingredient) {
                                                      return ingredient
                                                          .toLowerCase()
                                                          .contains(query
                                                              .toLowerCase());
                                                    }).toList(growable: false)
                                                          ..sort((a, b) => a
                                                              .toLowerCase()
                                                              .indexOf(
                                                                  lowercaseQuery)
                                                              .compareTo(b
                                                                  .toLowerCase()
                                                                  .indexOf(
                                                                      lowercaseQuery)));
                                                  } else {
                                                    return [];
                                                  }
                                                },
                                                suggestionBuilder: (context,
                                                    state, ingredient) {
                                                  return ListTile(
                                                    key: ObjectKey(ingredient),
                                                    title: Text(ingredient),
                                                    onTap: () =>
                                                        state.selectSuggestion(
                                                            ingredient),
                                                  );
                                                },
                                              ),
                                            ),
                                            // FlatButton(),
                                          ],
                                        ),
                                      ),
                                      child: ClayContainer(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius: 25,
                                        child: Container(
                                          height: 50,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2.5,
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                        .brightness ==
                                                    Brightness.light
                                                ? Theme.of(context).primaryColor
                                                : Colors.black38,
                                            borderRadius: BorderRadius.circular(
                                              25,
                                            ),
                                          ),
                                          child: Center(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                // Icon(Icons.add_circle),
                                                // SizedBox(
                                                //   width: 10,
                                                // ),
                                                Text(
                                                  'Add Ingredients',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .button
                                                      .copyWith(
                                                        color: Colors.white,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () => onButtonPressed(
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Align(
                                              alignment: Alignment.topCenter,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  height: 7,
                                                  width: 50,
                                                  decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .accentColor
                                                        .withOpacity(0.5),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 10),
                                              child: Text(
                                                "Remove Ingredients",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2
                                                    .copyWith(
                                                        fontSize: 22,
                                                        fontWeight:
                                                            FontWeight.w300),
                                              ),
                                            ),

                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                // vertical: 20,
                                                horizontal: 20,
                                              ),
                                              child: ChipsInput(
                                                initialValue: exclude,
                                                //  includei
                                                //     .split("[")[1]
                                                //     .split("]")[0]
                                                //     .split(",")
                                                //     .toList(),
                                                //     .forEach((element) {
                                                //   include[i] =
                                                //       element.toString();
                                                //   i++;
                                                // }),

                                                decoration: InputDecoration(
                                                  labelText:
                                                      'Select Ingredients',
                                                  // counter: Text(
                                                  //   include.length
                                                  //           .toString() ??
                                                  //       "0",
                                                  // ),
                                                ),
                                                onChanged: (data) {
                                                  // includei =
                                                  //     data.toString();
                                                  exclude = data;
                                                  print(exclude);
                                                  // setState(() {});
                                                  // print(includei);
                                                },
                                                chipBuilder:
                                                    (context, state, profile) {
                                                  return InputChip(
                                                    key: ObjectKey(profile),
                                                    label: Text(profile),
                                                    onDeleted: () => state
                                                        .deleteChip(profile),
                                                    materialTapTargetSize:
                                                        MaterialTapTargetSize
                                                            .shrinkWrap,
                                                  );
                                                },
                                                findSuggestions:
                                                    (String query) {
                                                  if (query.length != 0) {
                                                    var lowercaseQuery =
                                                        query.toLowerCase();
                                                    return SearchSuggestions
                                                        .suggestions
                                                        .where((ingredient) {
                                                      return ingredient
                                                          .toLowerCase()
                                                          .contains(query
                                                              .toLowerCase());
                                                    }).toList(growable: false)
                                                          ..sort((a, b) => a
                                                              .toLowerCase()
                                                              .indexOf(
                                                                  lowercaseQuery)
                                                              .compareTo(b
                                                                  .toLowerCase()
                                                                  .indexOf(
                                                                      lowercaseQuery)))
                                                          ..sort((a, b) => a
                                                              .replaceAll(
                                                                  " ", "")
                                                              .length
                                                              .compareTo(b
                                                                  .replaceAll(
                                                                      " ", "")
                                                                  .length));
                                                  } else {
                                                    return [];
                                                  }
                                                },
                                                suggestionBuilder: (context,
                                                    state, ingredient) {
                                                  return ListTile(
                                                    key: ObjectKey(ingredient),
                                                    title: Text(ingredient),
                                                    onTap: () =>
                                                        state.selectSuggestion(
                                                            ingredient),
                                                  );
                                                },
                                              ),
                                            ),
                                            // FlatButton(),
                                          ],
                                        ),
                                      ),
                                      child: ClayContainer(
                                        borderRadius: 25,
                                        color: Theme.of(context).primaryColor,
                                        child: Container(
                                          height: 50,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2.5,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            color: Theme.of(context)
                                                        .brightness ==
                                                    Brightness.light
                                                ? Theme.of(context).primaryColor
                                                : Colors.black38,
                                          ),
                                          child: Center(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                // Icon(Icons.remove_circle),
                                                // SizedBox(
                                                //   width: 10,
                                                // ),
                                                Text(
                                                  'Remove Ingredients',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .button
                                                      .copyWith(
                                                        color: Colors.white,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: ClayContainer(
                          color: Theme.of(context).primaryColor,
                          depth: 60,
                          spread: 2,
                          customBorderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(40),
                            bottomRight: Radius.circular(40),
                          ),
                          child: InkWell(
                            child: AnimatedContainer(
                              curve: curve,
                              duration: duration,
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 45),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(40),
                                  bottomRight: Radius.circular(40),
                                ),
                                color: isSearch
                                    ? Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Theme.of(context)
                                            .scaffoldBackgroundColor
                                        : Theme.of(context).accentColor
                                    : Colors.transparent,
                              ),
                              child: Text(
                                'Search'.toUpperCase(),
                                style: isSearch
                                    ? Theme.of(context)
                                        .textTheme
                                        .bodyText2
                                        .copyWith(
                                          // color: Colors.white,
                                          fontSize: 22,
                                          letterSpacing: 1.2,
                                        )
                                    : TextStyle(color: Colors.transparent),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            onTap: () {
                              submitSearch(
                                controller.text.trim().isNotEmpty
                                    ? "Showing Results For " + controller.text
                                    : "Showing Recipes From Ingredients",
                                controller.text
                                    .replaceAll(" ", "%20")
                                    .toLowerCase(),
                              );

                              // show
                            },
                          ),
                        ),
                      ),
                    ],
                  )
                : AnimatedContainer(
                    curve: curve,
                    duration: duration,
                    child: Center(
                      child: Text(
                        "Start Searching Recipes From Ingredients"
                            .toUpperCase(),
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(fontSize: 10, color: Colors.white),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
//  Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: GestureDetector(
//                   onTap: () => {},
//                   //  Navigator.push(context,
//                   //     MaterialPageRoute(builder: (context) => SearchScreen())),
//                   child: Stack(
//                     children: [
//                       Column(
//                         children: <Widget>[
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(25),
//                             child: Container(
//                               child: Image.asset(
//                                 'assets/images/fridge.jpg',
//                                 fit: BoxFit.cover,
//                               ),
//                               // child: BackdropFilter(
//                               //   filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
//                               // ),
//                               // child: Image.asset('assets/images/fridge.jpg'),
//                             ),
//                           ),
//                           SizedBox(
//                             height: 20,
//                           ),
//                         ],
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(17.0),
//                         child: Text(
//                           'Find Recipes From The Items In Your Fridge'
//                               .toUpperCase(),
//                           textAlign: TextAlign.right,
//                           style: Theme.of(context).textTheme.caption.copyWith(
//                                 color: Colors.white,
//                                 fontSize: 30,
//                                 fontWeight: FontWeight.w200,
//                                 wordSpacing: 2,
//                                 letterSpacing: 1.2,
//                               ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
