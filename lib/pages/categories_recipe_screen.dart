import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:recipetap/models/recipe_card.dart';
import 'package:recipetap/widgets/build_recipe_list_results.dart';

import 'recipe_view_page.dart';

class CategoryRecipesScreen extends StatefulWidget {
  final String url;
  CategoryRecipesScreen({Key key, this.url}) : super(key: key);

  @override
  _CategoryRecipesScreenState createState() => _CategoryRecipesScreenState();
}

class _CategoryRecipesScreenState extends State<CategoryRecipesScreen> {
  bool isLoading = true;
  // static String incl; //= 'milk,sugar';
  // static String excl; //= 'salt,chicken';

  List<RecipeCard> recipeCards = [];

  @override
  void initState() {
    final String url = widget.url;
    // 'https://www.allrecipes.com/search/results/?ingIncl=$incl&ingExcl=$excl&sort=re';
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
    // TODO Layout: Options form Catagories , CatagoryRecipes
    return Scaffold(
      appBar: AppBar(),
      body: isLoading
          ? CircularProgressIndicator()
          : BuildRecipeListResults(recipeCards: recipeCards),
    );
  }
}
