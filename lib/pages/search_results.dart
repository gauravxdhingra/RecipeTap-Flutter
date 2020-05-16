import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:recipetap/models/recipe_card.dart';
import 'package:recipetap/pages/recipe_view_page.dart';

class SearchResultsScreen extends StatefulWidget {
  static const routeName = 'search_result_screen';
  final incl;
  final excl;
  SearchResultsScreen({Key key, this.incl, this.excl}) : super(key: key);

  @override
  _SearchResultsScreenState createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  bool isLoading = true;
  // static String incl; //= 'milk,sugar';
  // static String excl; //= 'salt,chicken';

  List<RecipeCard> recipeCards = [];

  @override
  void initState() {
    final String incl = widget.incl;
    final String excl = widget.excl;
    final String url =
        'https://www.allrecipes.com/search/results/?ingIncl=$incl&ingExcl=$excl';
    getSearchResults(url);
    super.initState();
  }

  getSearchResults(url) async {
    final response = await http.get(url);
    dom.Document document = parser.parse(response.body);

    final recipeCardsFromHtml =
        document.getElementsByClassName("fixed-recipe-card");

    recipeCardsFromHtml.forEach((element) {
      final imageUrlRecipe = element
          .getElementsByClassName("grid-card-image-container")[0]
          // .querySelector("div")
          // .querySelector("a")
          .querySelector("img")
          .attributes["data-original-src"];
      // .getElementsByClassName("fixed-recipe-card__img ng-isolate-scope")[0]
      // .attributes["src"];
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

      recipeCards.add(RecipeCard(
        title: titleRecipe,
        desc: desc,
        photoUrl: imageUrlRecipe,
        href: href,
      ));
    });
    print(recipeCards);
    setState(() {
      isLoading = false;
    });
  }

  goToRecipe(url, coverImageUrl) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RecipeViewPage(
                  url: url,
                  coverImageUrl: coverImageUrl,
                )));
  }

  @override
  Widget build(BuildContext context) {
    // final inclexclArgs = ModalRoute.of(context).settings.arguments;
    // print(inclexclArgs.incl);
    return Scaffold(
      appBar: AppBar(),
      body: isLoading
          ? CircularProgressIndicator()
          : Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                ),
                itemCount: recipeCards.length,
                itemBuilder: (context, i) => GestureDetector(
                  onTap: () =>
                      goToRecipe(recipeCards[i].href, recipeCards[i].photoUrl),
                  child: GridTile(
                    child: Image.network(
                      recipeCards[i].photoUrl,
                    ),
                    header: Text(recipeCards[i].title),
                    footer: Text(recipeCards[i].desc),
                  ),
                ),
              ),
            ),
    );
  }
}
