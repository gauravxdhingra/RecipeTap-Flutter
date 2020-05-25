import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:neuomorphic_container/neuomorphic_container.dart';
// import 'package:flutter_neumorphic/flutter_neumorphic.dart';
// import 'package:recipetap/jump_screens/aww_snap_screen.dart';
import 'package:recipetap/models/recipe_card.dart';
import 'package:recipetap/pages/recipe_view_page.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

import 'loading_spinner.dart';

class BuildRecipeListResults extends StatefulWidget {
  const BuildRecipeListResults({
    Key key,
    @required this.recipeCards,
    @required this.url,
  }) : super(key: key);

  final List<RecipeCard> recipeCards;
  final String url;

  @override
  _BuildRecipeListResultsState createState() => _BuildRecipeListResultsState();
}

class _BuildRecipeListResultsState extends State<BuildRecipeListResults> {
  List<RecipeCard> recipeCards = [];
  bool firstPage = true;
  int page = 2;
  bool hasMore = true;
  int currentMax;

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
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
      getSearchResults(widget.url + "?page=" + '$page');
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

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Theme.of(context).primaryColor,
      padding: const EdgeInsets.only(
        top: 20.0,
        right: 20,
        left: 20,
      ),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: 4 / 3.1,
          mainAxisSpacing: 20,
        ),
        // itemExtent: ,
        controller: _scrollController,
        physics: BouncingScrollPhysics(),
        itemCount: hasMore ? recipeCards.length + 1 : recipeCards.length,
        itemBuilder: (context, i) {
          // print(recipeCards.length);
          if (i == recipeCards.length)
            return LoadingSpinner();
          else
            return ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
              child: ClayContainer(
                borderRadius: 20,
                depth: 90,
                spread: 6,
                // depth: 90,
                // color: Theme.of(context).primaryColor,
                child: GestureDetector(
                  onTap: () => goToRecipe(
                      recipeCards[i].href, recipeCards[i].photoUrl, context),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                    child: Container(
                      color: Theme.of(context).primaryColor.withOpacity(0.2),
                      child: Column(
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                child: Image.network(
                                  recipeCards[i].photoUrl,
                                  height: 210,
                                  width: MediaQuery.of(context).size.width,
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
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  height: 50,
                                  width: MediaQuery.of(context).size.width,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
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
            );
        },
      ),
    );
  }
}
