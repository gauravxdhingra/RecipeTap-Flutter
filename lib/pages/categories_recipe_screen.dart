import 'package:clay_containers/clay_containers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:provider/provider.dart';
import 'package:recipetap/jump_screens/loading_category_recipes.dart';
import 'package:recipetap/models/category_options_card.dart';
import 'package:recipetap/models/recipe_card.dart';
import 'package:recipetap/pages/search_results.dart';
// import 'package:recipetap/provider/auth_provider.dart';
import 'package:recipetap/provider/recently_viewed_provider.dart';
import 'package:recipetap/utility/shared_prefs.dart';
import 'package:recipetap/widgets/build_recipe_list_results.dart';
import 'package:recipetap/widgets/loading_spinner.dart';
import 'package:recipetap/models/category_model.dart';

import 'home_screen.dart';
import 'recipe_view_page.dart';

class CategoryRecipesScreen extends StatefulWidget {
  final String url;
  final String categoryName;
  CategoryRecipesScreen({Key key, this.url, this.categoryName})
      : super(key: key);

  @override
  _CategoryRecipesScreenState createState() => _CategoryRecipesScreenState();
}

class _CategoryRecipesScreenState extends State<CategoryRecipesScreen> {
  // static String incl; //= 'milk,sugar';
  // static String excl; //= 'salt,chicken';

  List<RecipeCard> recipeCards = [];
  List<CategoryOptionsRecipeCard> categoryOptionsRecipeCards = [];
  String categoryTitle;
  String categoryDesc;
  bool firstPage = true;
  int page = 2;
  bool hasMore = true;
  int currentMax;
  bool isFav = false;

  ScrollController _scrollController = ScrollController();

  bool isLoading = true;

  @override
  void initState() {
    isLoading = true;
    categoryTitle = widget.categoryName;
    final String url = widget.url;
    _scaffoldKey = GlobalKey<ScaffoldState>();
    // 'https://www.allrecipes.com/search/results/?ingIncl=$incl&ingExcl=$excl&sort=re';
    getSearchResults(url).whenComplete(() {
      Future.delayed(Duration(microseconds: 0)).then(
        (value) => checkFav(),
      );
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print("loading More");
        loadMore();
      }
    });
    // Future.delayed(Duration(microseconds: 0)).then(
    //   (value) => checkFav(),
    // );
    super.initState();
  }

  String diet;
  checkFav() async {
    // var isAuth = Provider.of<AuthProvider>(context, listen: false);
    if (currentUser != null) {
      isFav = await Provider.of<RecentsProvider>(context, listen: false)
          .checkIfFavCategory(
        categoryTitle,
        currentUser.email,
      );
    }
    isLoading = false;
    setState(() {
      isLoading = false;
    });
  }

  Future<void> getSearchResults(url) async {
    // if (this.mounted) {
    setState(() {
      isLoading = true;
    });
    // }
    print(url);
    final response = await http.get(url);
    dom.Document document = parser.parse(response.body);
    diet = await getDiet();

    categoryTitle = document
        .getElementsByClassName("title-section__text title")[0]
        .text
        .trim();

    categoryDesc = document
        .getElementsByClassName("title-section__text subtitle")[0]
        .text
        .trim();

    final categoryOptionsFromHtmll = document.getElementById("insideScroll");

    if (!categoryOptionsFromHtmll.className.contains("video")) {
      final categoryOptionsFromHtml =
          categoryOptionsFromHtmll.querySelector("ul").querySelectorAll("li");

      categoryOptionsFromHtml.forEach((element) {
        // title
        // photoUrl
        // href
        final href = element
            .querySelector("a")
            .attributes["href"]
            .split("?internalSource=")[0];

        var photoUrl =
            element.querySelector("a").querySelector("img").attributes["src"];

        try {
          final srcfirstSplit = photoUrl.split("photos/")[0];
          final srcsecondsplit = photoUrl.split("photos/")[1].split("/");
          var srcc;
          if (srcsecondsplit.length > 1) {
            srcc = srcfirstSplit + "photos/" + srcsecondsplit[1];
            print(srcc);
            photoUrl = srcc;
          }
        } catch (e) {}
        final title =
            element.querySelector("a").querySelector("span").text.trim();

        categoryOptionsRecipeCards.add(CategoryOptionsRecipeCard(
          title: title,
          href: href,
          photoUrl: photoUrl,
        ));
      });
    }

    final recipeCardsFromHtml =
        document.getElementsByClassName("fixed-recipe-card");

    recipeCardsFromHtml.forEach((element) {
      var imageUrlRecipe = element
          .getElementsByClassName("grid-card-image-container")[0]
          // .querySelector("div")
          // .querySelector("a")
          .querySelector("img")
          .attributes["data-original-src"];
      // .getElementsByClassName("fixed-recipe-card__img ng-isolate-scope")[0]
      // .attributes["src"];

      final srcfirstSplit = imageUrlRecipe.split("photos/")[0];
      final srcsecondsplit = imageUrlRecipe.split("photos/")[1].split("/");
      var srcc;
      if (srcsecondsplit.length > 1) {
        srcc = srcfirstSplit + "photos/" + srcsecondsplit[1];
        print(srcc);
        imageUrlRecipe = srcc;
      }

      print(imageUrlRecipe);

      final titleRecipe = element
          .getElementsByClassName("fixed-recipe-card__title-link")[0]
          .text
          .trim();
      print(titleRecipe);

      final desc = element.text.split(titleRecipe)[1].split("By ")[0].trim();
      print(desc);

      final href = element
          .getElementsByClassName("fixed-recipe-card__info")[0]
          .querySelector("a")
          .attributes["href"]
          .split("?internal")[0];
      print(href);

      if (diet == "all") {
        if (!titleRecipe.toLowerCase().contains("beef") &&
            !titleRecipe.toLowerCase().contains("pork") &&
            !titleRecipe.toLowerCase().contains("bacon") &&
            !titleRecipe.toLowerCase().contains("ham") &&
            !titleRecipe.toLowerCase().contains("steak") &&
            !titleRecipe.toLowerCase().contains("veal") &&
            !desc.toLowerCase().contains("beef") &&
            !desc.toLowerCase().contains("pork") &&
            !desc.toLowerCase().contains("bacon") &&
            !desc.toLowerCase().contains("ham") &&
            !desc.toLowerCase().contains("steak") &&
            !desc.toLowerCase().contains("veal"))
          recipeCards.add(RecipeCard(
            title: titleRecipe,
            desc: desc,
            photoUrl: imageUrlRecipe,
            href: href,
          ));
      }
// turkey,lamb,steak,duck,camel,goat,quail,shrimp,prawn,crab,lobster,oyster,chevon,veal
      if (diet == "chicken") {
        if (!titleRecipe.toLowerCase().contains("beef") &&
            !titleRecipe.toLowerCase().contains("pork") &&
            !titleRecipe.toLowerCase().contains("bacon") &&
            !titleRecipe.toLowerCase().contains("ham") &&
            !titleRecipe.toLowerCase().contains("turkey") &&
            !titleRecipe.toLowerCase().contains("lamb") &&
            !titleRecipe.toLowerCase().contains("steak") &&
            !titleRecipe.toLowerCase().contains("duck") &&
            !titleRecipe.toLowerCase().contains("quail") &&
            !titleRecipe.toLowerCase().contains("shrimp") &&
            !titleRecipe.toLowerCase().contains("prawn") &&
            !titleRecipe.toLowerCase().contains("crab") &&
            !titleRecipe.toLowerCase().contains("lobster") &&
            !titleRecipe.toLowerCase().contains("oyster") &&
            !titleRecipe.toLowerCase().contains("chevon") &&
            !titleRecipe.toLowerCase().contains("veal") &&
            !desc.toLowerCase().contains("beef") &&
            !desc.toLowerCase().contains("pork") &&
            !desc.toLowerCase().contains("bacon") &&
            !desc.toLowerCase().contains("ham") &&
            !desc.toLowerCase().contains("turkey") &&
            !desc.toLowerCase().contains("lamb") &&
            !desc.toLowerCase().contains("steak") &&
            !desc.toLowerCase().contains("duck") &&
            !desc.toLowerCase().contains("quail") &&
            !desc.toLowerCase().contains("shrimp") &&
            !desc.toLowerCase().contains("prawn") &&
            !desc.toLowerCase().contains("crab") &&
            !desc.toLowerCase().contains("lobster") &&
            !desc.toLowerCase().contains("oyster") &&
            !desc.toLowerCase().contains("chevon") &&
            !desc.toLowerCase().contains("veal"))
          recipeCards.add(RecipeCard(
            title: titleRecipe,
            desc: desc,
            photoUrl: imageUrlRecipe,
            href: href,
          ));
      }

      if (diet == "veg") {
        if (!titleRecipe.toLowerCase().contains("chicken") &&
            !titleRecipe.toLowerCase().contains("tuna") &&
            !titleRecipe.toLowerCase().contains("salmon") &&
            !titleRecipe.toLowerCase().contains("mutton") &&
            !titleRecipe.toLowerCase().contains("egg") &&
            !titleRecipe.toLowerCase().contains("beef") &&
            !titleRecipe.toLowerCase().contains("pork") &&
            !titleRecipe.toLowerCase().contains("bacon") &&
            !titleRecipe.toLowerCase().contains("ham") &&
            !titleRecipe.toLowerCase().contains("turkey") &&
            !titleRecipe.toLowerCase().contains("lamb") &&
            !titleRecipe.toLowerCase().contains("steak") &&
            !titleRecipe.toLowerCase().contains("duck") &&
            !titleRecipe.toLowerCase().contains("quail") &&
            !titleRecipe.toLowerCase().contains("shrimp") &&
            !titleRecipe.toLowerCase().contains("prawn") &&
            !titleRecipe.toLowerCase().contains("crab") &&
            !titleRecipe.toLowerCase().contains("lobster") &&
            !titleRecipe.toLowerCase().contains("oyster") &&
            !titleRecipe.toLowerCase().contains("chevon") &&
            !titleRecipe.toLowerCase().contains("veal") &&
            !desc.toLowerCase().contains("chicken") &&
            !desc.toLowerCase().contains("tuna") &&
            !desc.toLowerCase().contains("salmon") &&
            !desc.toLowerCase().contains("mutton") &&
            !desc.toLowerCase().contains("egg") &&
            !desc.toLowerCase().contains("beef") &&
            !desc.toLowerCase().contains("pork") &&
            !desc.toLowerCase().contains("bacon") &&
            !desc.toLowerCase().contains("ham") &&
            !desc.toLowerCase().contains("turkey") &&
            !desc.toLowerCase().contains("lamb") &&
            !desc.toLowerCase().contains("steak") &&
            !desc.toLowerCase().contains("duck") &&
            !desc.toLowerCase().contains("quail") &&
            !desc.toLowerCase().contains("shrimp") &&
            !desc.toLowerCase().contains("prawn") &&
            !desc.toLowerCase().contains("crab") &&
            !desc.toLowerCase().contains("lobster") &&
            !desc.toLowerCase().contains("oyster") &&
            !desc.toLowerCase().contains("chevon") &&
            !desc.toLowerCase().contains("veal"))
          recipeCards.add(RecipeCard(
            title: titleRecipe,
            desc: desc,
            photoUrl: imageUrlRecipe,
            href: href,
          ));
      }
      // recipeCards.add(RecipeCard(
      //   title: titleRecipe,
      //   desc: desc,
      //   photoUrl: imageUrlRecipe,
      //   href: href,
      // ));
    });
    // print(recipeCards);

    // if (this.mounted)
  }

// TODO: First Check if next Page Exists

  getSearchResultsNext(url) async {
    // print(url);
    final response = await http.get(url);
    dom.Document document = parser.parse(response.body);
    try {
      document
          .getElementsByClassName("title-section__text title")[0]
          .text
          .trim();
      hasMore = true;
    } catch (e) {
      setState(() {
        hasMore = false;
      });
      return;
    }

    final recipeCardsFromHtml =
        document.getElementsByClassName("fixed-recipe-card");

    recipeCardsFromHtml.forEach((element) {
      final imageUrlRecipe = element
          .getElementsByClassName("grid-card-image-container")[0]
          .querySelector("img")
          .attributes["data-original-src"];

      // print(imageUrlRecipe);

      final titleRecipe = element
          .getElementsByClassName("fixed-recipe-card__title-link")[0]
          .text
          .trim();
      // print(titleRecipe);

      final desc = element.text.split(titleRecipe)[1].split("By ")[0].trim();
      // print(desc);

      final href = element
          .getElementsByClassName("fixed-recipe-card__info")[0]
          .querySelector("a")
          .attributes["href"]
          .split("?internal")[0];
      // print(href);

      recipeCards.add(RecipeCard(
        title: titleRecipe,
        desc: desc,
        photoUrl: imageUrlRecipe,
        href: href,
      ));
    });
    setState(() {});
  }

  loadMore() {
    if (hasMore) {
      getSearchResultsNext(widget.url + "?page=" + '$page');
      page++;
      firstPage = false;
      setState(() {
        print(recipeCards.length);
      });
    } else
      return;
    // page++;
  }

  // // var _isLoading = false;
  // var isInit = false;

  // @override
  // void didChangeDependencies() async {
  //   if (!isInit) {
  //     if (this.mounted)
  //       setState(() {
  //         isLoading = true;
  //       });

  //     if (Provider.of<AuthProvider>(context, listen: false).isAuth) {
  //       isFav = await Provider.of<RecentsProvider>(context, listen: false)
  //           .checkIfFavCategory(
  //         categoryTitle,
  //         currentUser.email,
  //       );
  //     }

  //     // setState(() {
  //     //   _isLoading = false;
  //     // });
  //     if (this.mounted)
  //       setState(() {
  //         isLoading = false;
  //       });

  //     isInit = true;
  //   }
  //   super.didChangeDependencies();
  // }

  goToRecipe(url, coverImageUrl, context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeViewPage(
          url: url,
          coverImageUrl: coverImageUrl,
        ),
      ),
    );
  }

  GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  Widget build(BuildContext context) {
    // isLoading = true;

    return Scaffold(
      key: _scaffoldKey,

      floatingActionButton: isLoading
          ? null
          : FloatingActionButton(
              backgroundColor: Theme.of(context).accentColor,
              child: Icon(
                isFav ? Icons.favorite : Icons.favorite_border,
                size: 30,
                color: Colors.white,
              ),
              onPressed: isFav
                  ? () async {
                      isFav = false;
                      setState(() {});
                      await Provider.of<RecentsProvider>(context, listen: false)
                          .removeFavCategory(categoryTitle, currentUser.email);
                      _scaffoldKey.currentState.showSnackBar((new SnackBar(
                        content: new Text(
                          '$categoryTitle Removed From Favourites',
                        ),
                      )));
                      if (await Provider.of<RecentsProvider>(context,
                              listen: false)
                          .checkIfFavCategory(
                        categoryTitle,
                        currentUser.email,
                      )) {
                        isFav = true;
                        setState(() {});
                      }
                    }
                  : () async {
                      if (currentUser != null) {
                        isFav = true;
                        setState(() {});
                        await Provider.of<RecentsProvider>(context,
                                listen: false)
                            .addToFavouriteCategories(
                          CategoryModel(
                            title: categoryTitle,
                            categoryUrl: widget.url,
                            timestamp: Timestamp.now(),
                          ),
                          currentUser.email,
                        );
                        _scaffoldKey.currentState.showSnackBar((new SnackBar(
                          content:
                              new Text('$categoryTitle Added To Favourites'),
                        )));

                        if (!await Provider.of<RecentsProvider>(context,
                                listen: false)
                            .checkIfFavCategory(
                          categoryTitle,
                          currentUser.email,
                        )) {
                          isFav = false;
                          setState(() {});
                        }
                      } else {
                        _scaffoldKey.currentState.showSnackBar(new SnackBar(
                            content:
                                new Text("Log In To Add To Favourites !")));
                      }
                    },
            ),
      // backgroundColor: Theme.of(context).primaryColor,
      // appBar: isLoading
      //     ? AppBar()
      //     : AppBar(
      //         title: Text(categoryTitle),
      //         elevation: 0,
      //       ),
      body: isLoading
          ? Center(
              child: LoadingSpinner(
              color: Colors.grey,
              size: 120,
            ))
          : CustomScrollView(
              physics: BouncingScrollPhysics(),
              controller: _scrollController,
              slivers: <Widget>[
                SliverAppBar(
                  centerTitle: true,
                  leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),

                  title: isLoading
                      ? Text("")
                      : Text(
                            categoryTitle,
                            // style: TextStyle(color: Colors.white),
                          ) ??
                          "",
                  // elevation: 0.1,
                  // expandedHeight: MediaQuery.of(context).size.height / 3,
                  pinned: true,
                  // backgroundColor: Colors.white,
                ),
                SliverToBoxAdapter(
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      if (categoryOptionsRecipeCards.length != 0)
                        Container(
                          color: Theme.of(context).primaryColor,
                          height: 170,
                          // width: 400,
                          child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            padding: EdgeInsets.only(
                              top: 15,
                              left: 15,
                            ),
                            scrollDirection: Axis.horizontal,
                            itemCount: categoryOptionsRecipeCards.length,
                            itemBuilder: (context, i) => GestureDetector(
                              onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => SearchResultsScreen(
                                          categoryOption: true,
                                          excl: "",
                                          incl: "",
                                          appBarTitle:
                                              categoryOptionsRecipeCards[i]
                                                  .title,
                                          url: categoryOptionsRecipeCards[i]
                                              .href))),
                              child: Padding(
                                padding: const EdgeInsets.only(right: 15),
                                child: Container(
                                  height: 110,
                                  width: 100,
                                  child: Column(
                                    children: <Widget>[
                                      ClayContainer(
                                        // curveType: CurveType.convex,
                                        borderRadius: 50,
                                        surfaceColor:
                                            Theme.of(context).primaryColor,
                                        color: Theme.of(context).primaryColor,
                                        parentColor:
                                            Theme.of(context).primaryColor,

                                        depth: 20,
                                        child: CircleAvatar(
                                          radius: 50,
                                          backgroundColor:
                                              Theme.of(context).primaryColor,
                                          backgroundImage: NetworkImage(
                                            categoryOptionsRecipeCards[i]
                                                .photoUrl,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 10.0),
                                        child: Center(
                                          child: Text(
                                            categoryOptionsRecipeCards[i].title,
                                            style:
                                                TextStyle(color: Colors.white),
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    color: Theme.of(context).primaryColor,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    child: Text(
                      categoryDesc ?? "",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                    child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      )),
                  height: 30,
                )),
                SliverToBoxAdapter(
                    child: Container(
                  height: 10,
                )),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) {
                      // print(recipeCards.length);
                      if (i == recipeCards.length)
                        return LoadingSpinner(
                          color: Colors.grey,
                          size: 70,
                        );
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                        child: GestureDetector(
                          onTap: () => goToRecipe(recipeCards[i].href,
                              recipeCards[i].photoUrl, context),
                          child: ClayContainer(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            borderRadius: 20,
                            depth: 50,
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                              child: Container(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.2),
                                child: Column(
                                  children: <Widget>[
                                    Stack(
                                      children: <Widget>[
                                        ClipRRect(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(20),
                                          ),
                                          child: (recipeCards[i].photoUrl ==
                                                      null ||
                                                  recipeCards[i].photoUrl ==
                                                      "https://www.allrecipes.com/img/icons/generic-recipe.svg" ||
                                                  recipeCards[i].photoUrl ==
                                                      "https://images.media-allrecipes.com/images/82579.png" ||
                                                  recipeCards[i].photoUrl ==
                                                      "https://images.media-allrecipes.com/images/79591.png")
                                              ? Container(
                                                  height: 210,
                                                  child: Image.asset(
                                                    'assets/logo/banner.png',
                                                    // fit: BoxFit.scaleDown,
                                                    // width: 100,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    scale: 3,
                                                    alignment: Alignment.lerp(
                                                        Alignment.center,
                                                        Alignment.bottomCenter,
                                                        0.5),
                                                    color: Theme.of(context)
                                                                .brightness ==
                                                            Brightness.dark
                                                        ? Colors.white
                                                        : null,
                                                  ),
                                                )
                                              : Image.network(
                                                  recipeCards[i].photoUrl,
                                                  height: 220,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  fit: BoxFit.cover,
                                                ),
                                        ),
                                        Positioned(
                                          // top: 0,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .accentColor
                                                  .withOpacity(0.6),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            height: 50,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 15.0,
                                                ),
                                                child: Text(
                                                  recipeCards[i].title,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1
                                                      .copyWith(
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight.w300,
                                                          color: Colors.white),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 20),
                                      child: Text(
                                        recipeCards[i].desc,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            .copyWith(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w300,
                                                color: Theme.of(context)
                                                            .brightness ==
                                                        Brightness.dark
                                                    ? Colors.white
                                                    : Colors.black),

                                        //  TextStyle(
                                        //   // color: Colors.white,
                                        //   fontSize: 17,
                                        //   fontWeight: FontWeight.w300,
                                        // ),
                                        maxLines: 2,
                                        softWrap: true,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    childCount:
                        hasMore ? recipeCards.length + 1 : recipeCards.length,
                  ),

                  // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  //   crossAxisCount: 1,
                  //   // childAspectRatio: 20 / 13,
                  //   mainAxisSpacing: 20,
                  // ),
                ),
              ],
            ),
    );
  }
}
