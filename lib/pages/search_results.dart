import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;

import '../models/recipe_card.dart';
import '../utility/shared_prefs.dart';
import '../widgets/build_recipe_list_results.dart';
import '../widgets/loading_spinner.dart';

class SearchResultsScreen extends StatefulWidget {
  static const routeName = 'search_result_screen';
  // final incl;
  // final excl;
  final appBarTitle;
  final url;
  final incl;
  final excl;
  final List include;
  final List exclude;
  final bool categoryOption;

  SearchResultsScreen({
    Key key,
    @required this.url,
    @required this.appBarTitle,
    this.incl,
    this.excl,
    this.include,
    this.exclude,
    this.categoryOption,
  }) : super(key: key);

  @override
  _SearchResultsScreenState createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  bool isLoading = true;
  String diet;
  // static String incl; //= 'milk,sugar';
  // static String excl; //= 'salt,chicken';

  List<RecipeCard> recipeCards = [];

  @override
  void initState() {
    // final String incl = widget.incl;
    // final String excl = widget.excl;
    // final String url =
    //     'https://www.allrecipes.com/search/results/?ingIncl=$incl&ingExcl=$excl&sort=re';
    final String url = widget.url;

    super.initState();
    getSearchResults(url);
  }

  getSearchResults(url) async {
    final response = await http.get(url);
    dom.Document document = parser.parse(response.body);
    diet = await getDiet();

    try {
      // Gives Seach Results Page
      print("SEARCH");
      final recipeCardsFromHtml =
          document.getElementsByClassName("fixed-recipe-card");
      var x = recipeCardsFromHtml[0];

      recipeCardsFromHtml.forEach((element) {
        var imageUrlRecipe = element
            .getElementsByClassName("grid-card-image-container")[0]
            // .querySelector("div")
            // .querySelector("a")
            .querySelector("img")
            .attributes["data-original-src"];
        // .getElementsByClassName("fixed-recipe-card__img ng-isolate-scope")[0]
        // .attributes["src"];

        print(imageUrlRecipe);

        try {
          final srcfirstSplit = imageUrlRecipe.split("photos/")[0];
          final srcsecondsplit = imageUrlRecipe.split("photos/")[1].split("/");
          var srcc;
          if (srcsecondsplit.length > 1) {
            srcc = srcfirstSplit + "photos/" + srcsecondsplit[1];
            print(srcc);
            imageUrlRecipe = srcc;
          }
        } catch (e) {}
        // images.add(coverImageUrl);

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

        applyFilter(
            desc: desc,
            href: href,
            imageUrlRecipe: imageUrlRecipe,
            titleRecipe: titleRecipe);
      });
    } catch (e) {
      // Sub Category Page
      print("SUB CATEGORY");

      final recipeCardsFromHtml =
          document.getElementsByClassName("component card card__category");

      recipeCardsFromHtml.forEach((element) {
        var imageUrlRecipe = element
            .querySelector("div")
            .querySelector("a")
            .querySelector("div")
            .attributes["data-src"];

        print(imageUrlRecipe);

        final titleRecipe = element
            .getElementsByClassName("card__detailsContainer")[0]
            .querySelector("div")
            .querySelector("a")
            .text
            .trim();
        print(titleRecipe);

        final desc =
            element.getElementsByClassName("card__summary")[0].text.trim();
        print(desc);

        final href = element
            .getElementsByClassName("card__titleLink manual-link-behavior")[0]
            .attributes["href"];
        print(href);

        applyFilter(
            desc: desc,
            href: href,
            imageUrlRecipe: imageUrlRecipe,
            titleRecipe: titleRecipe);
      });
    }
    print(recipeCards);
    setState(() {
      isLoading = false;
    });
  }

  applyFilter(
      {String titleRecipe, String desc, String imageUrlRecipe, String href}) {
    if (diet == "all") {
      if (!titleRecipe.toLowerCase().contains("beef") &&
          !titleRecipe.toLowerCase().contains("pork") &&
          !titleRecipe.toLowerCase().contains("bacon") &&
          !titleRecipe.toLowerCase().contains("ham") &&
          !titleRecipe.toLowerCase().contains("steak") &&
          !titleRecipe.toLowerCase().contains("veal") &&
          !titleRecipe.toLowerCase().contains("buffalo") &&
          !desc.toLowerCase().contains("beef") &&
          !desc.toLowerCase().contains("pork") &&
          !desc.toLowerCase().contains("bacon") &&
          !desc.toLowerCase().contains("ham") &&
          !desc.toLowerCase().contains("steak") &&
          !desc.toLowerCase().contains("veal") &&
          !desc.toLowerCase().contains("buffalo"))
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
          !titleRecipe.toLowerCase().contains("buffalo") &&
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
          !desc.toLowerCase().contains("veal") &&
          !desc.toLowerCase().contains("buffalo"))
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
          !titleRecipe.toLowerCase().contains("goat") &&
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
          !titleRecipe.toLowerCase().contains("buffalo") &&
          !desc.toLowerCase().contains("chicken") &&
          !desc.toLowerCase().contains("tuna") &&
          !desc.toLowerCase().contains("salmon") &&
          !desc.toLowerCase().contains("mutton") &&
          !desc.toLowerCase().contains("goat") &&
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
          !desc.toLowerCase().contains("veal" ) &&
          !desc.toLowerCase().contains("buffalo"))
        recipeCards.add(RecipeCard(
          title: titleRecipe,
          desc: desc,
          photoUrl: imageUrlRecipe,
          href: href,
        ));
    }
  }

  @override
  Widget build(BuildContext context) {
    // final inclexclArgs = ModalRoute.of(context).settings.arguments;
    // print(inclexclArgs.incl);
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, false);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.appBarTitle ?? "",
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.white, fontSize: 17),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
            ),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          bottom: (widget.incl.toString().isNotEmpty ||
                  widget.excl.toString().isNotEmpty)
              ? PreferredSize(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      if (widget.incl.toString().isNotEmpty)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Including: ",
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              widget.include
                                  .toString()
                                  .split("[")[1]
                                  .split("]")[0],
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      if (widget.excl.toString().isNotEmpty)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Excluding: ",
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              widget.exclude
                                  .toString()
                                  .split("[")[1]
                                  .split("]")[0],
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      SizedBox(
                        height: 4,
                      ),
                    ],
                  ),
                  preferredSize: Size(MediaQuery.of(context).size.width, 18),
                )
              : null,
        ),
        // extendBodyBehindAppBar: true,
        body: isLoading
            ? Center(
                child: LoadingSpinner(
                size: 140,
                color: Colors.grey,
              ))
            : BuildRecipeListResults(
                recipeCards: recipeCards,
                url: widget.url,
                categoryOption: widget.categoryOption,
              ),
      ),
    );
  }
}
