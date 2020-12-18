import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;

import '../models/recipe_card.dart';
import '../pages/recipe_view_page.dart';
import '../utility/shared_prefs.dart';
import 'loading_spinner.dart';

class BuildRecipeListResults extends StatefulWidget {
  const BuildRecipeListResults({
    Key key,
    @required this.recipeCards,
    @required this.url,
    this.categoryOption,
  }) : super(key: key);

  final List<RecipeCard> recipeCards;
  final String url;
  final bool categoryOption;

  @override
  _BuildRecipeListResultsState createState() => _BuildRecipeListResultsState();
}

class _BuildRecipeListResultsState extends State<BuildRecipeListResults> {
  List<RecipeCard> recipeCards = [];
  bool firstPage = true;
  int page = 2;
  bool hasMore = true;
  int currentMax;
  String diet;
  bool categoryOption;

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    categoryOption = widget.categoryOption;
    recipeCards = widget.recipeCards;
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print("loading More");
        loadMore();
      }
    });
    currentMax = recipeCards.length;
  }

  getSearchResults(url) async {
    // print(url);
    final response = await http.get(url);

    dom.Document document = parser.parse(response.body);
    diet = await getDiet();
    try {
      document.getElementsByClassName("component card card__category")[0];
      hasMore = true;
      print("**************************HAS MORE SUBSC******************");
      print(hasMore);
    } catch (e) {
      try {
        int count = int.parse(document
            .getElementsByClassName("search-results__text")[0]
            .text
            .split(" recipe results")[0]
            .trim());
        if (count > recipeCards.length) {
          hasMore = true;
          print(hasMore);
        } else {
          hasMore = false;
          print(hasMore);
        }
      } catch (e) {
        hasMore = false;
        print(hasMore);
        return;
      }
    }

    setState(() {});
    try {
      final recipeCardsFromHtml =
          document.getElementsByClassName("fixed-recipe-card");
      var x = recipeCardsFromHtml[0];

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

        checkFilter(
            desc: desc,
            titleRecipe: titleRecipe,
            href: href,
            imageUrlRecipe: imageUrlRecipe);
      });
    } catch (e) {
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

        checkFilter(
            desc: desc,
            href: href,
            imageUrlRecipe: imageUrlRecipe,
            titleRecipe: titleRecipe);
      });
    }
    setState(() {});
  }

  loadMore() {
    if (hasMore) {
      if (categoryOption)
        getSearchResults(widget.url + "?page=" + '$page');
      else {
        getSearchResults(widget.url + "&page=" + '$page');
      }
      page++;
      firstPage = false;
      setState(() {
        print(recipeCards.length);
      });
    } else
      return;
    // page++;
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   setState(() {});
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

  checkFilter(
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
          !desc.toLowerCase().contains("veal") &&
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
    print(widget.url);
    return Container(
      // color: Theme.of(context).primaryColor,
      // padding: const EdgeInsets.only(
      //   top: 20.0,
      //   right: 20,
      //   left: 20,
      // ),
      child: recipeCards.length == 0
          ? Center(
              child: Text("No results Found!"),
            )
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 4 / 3.1,
                mainAxisSpacing: 20,
              ),
              // itemExtent: ,
              controller: _scrollController,
              physics: BouncingScrollPhysics(),
              itemCount: recipeCards.length == 0
                  ? 0
                  : hasMore
                      ? recipeCards.length + 1
                      : recipeCards.length,
              itemBuilder: (context, i) {
                // print(recipeCards.length);
                if (i == recipeCards.length && hasMore)
                  return LoadingSpinner(
                    size: 70,
                    color: Colors.grey,
                  );
                // if (i == recipeCards.length && !hasMore)
                //   return SizedBox(
                //     height: 30,
                //   );
                else
                  return Padding(
                    padding: const EdgeInsets.only(
                        top: 10.0, bottom: 0, left: 20, right: 20),
                    child: ClayContainer(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: 20,
                      depth: 50,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                        child: GestureDetector(
                          onTap: () => goToRecipe(recipeCards[i].href,
                              recipeCards[i].photoUrl, context),
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
                                                height: 210,
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
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 15.0,
                                              ),
                                              child: Text(
                                                recipeCards[i].title,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.w300,
                                                ),
                                                overflow: TextOverflow.ellipsis,
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
                                      style: TextStyle(
                                        // color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w300,
                                      ),
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
                    ),
                  );
              },
            ),
    );
  }
}
