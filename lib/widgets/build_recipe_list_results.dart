import 'package:flutter/material.dart';
// import 'package:recipetap/jump_screens/aww_snap_screen.dart';
import 'package:recipetap/models/recipe_card.dart';
import 'package:recipetap/pages/recipe_view_page.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

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
// TODO bummer page
// TODO handle less than 10 results circle indicator
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
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 4 / 3,
        mainAxisSpacing: 20,
      ),
      // itemExtent: ,
      controller: _scrollController,
      physics: BouncingScrollPhysics(),
      itemCount: hasMore ? recipeCards.length + 1 : recipeCards.length,
      itemBuilder: (context, i) {
        // print(recipeCards.length);
        if (i == recipeCards.length) return CircularProgressIndicator();
        return GestureDetector(
          onTap: () =>
              goToRecipe(recipeCards[i].href, recipeCards[i].photoUrl, context),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(40),
              bottomLeft: Radius.circular(40),
            ),
            child: GridTile(
              child: Image.network(
                recipeCards[i].photoUrl,
                fit: BoxFit.cover,
              ),
              header: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                child: Text(
                  recipeCards[i].title,
                  style: TextStyle(color: Colors.white, fontSize: 25),
                  overflow: TextOverflow.ellipsis,
                ),
                color: Colors.black54,
              ),
              footer: Container(
                padding: EdgeInsets.only(
                  left: 25,
                  top: 10,
                  bottom: 10,
                  right: 15,
                ),
                child: Text(
                  recipeCards[i].desc,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                  maxLines: 2,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
                color: Colors.black54,
              ),
            ),
          ),
        );
      },
    );
  }
}
