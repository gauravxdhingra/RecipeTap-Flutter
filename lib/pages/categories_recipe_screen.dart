import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:recipetap/models/category_options_card.dart';
import 'package:recipetap/models/recipe_card.dart';
import 'package:recipetap/pages/search_results.dart';
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

  // TODO: ImagePLaceholders on lazy loading images

  List<RecipeCard> recipeCards = [];
  List<CategoryOptionsRecipeCard> categoryOptionsRecipeCards = [];
  String categoryTitle;
  String categoryDesc;

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

    categoryTitle = document
        .getElementsByClassName("title-section__text title")[0]
        .text
        .trim();
    categoryDesc = document
        .getElementsByClassName("title-section__text subtitle")[0]
        .text
        .trim();

    final categoryOptionsFromHtml = document
        .getElementById("insideScroll")
        .querySelector("ul")
        .querySelectorAll("li");

    categoryOptionsFromHtml.forEach((element) {
      // title
      // photoUrl
      // href
      final href = element
          .querySelector("a")
          .attributes["href"]
          .split("?internalSource=")[0];

      final photoUrl = element
          .querySelector("a")
          .querySelector("img")
          .attributes["src"]
          .replaceAll("/140x140", "");

      final title =
          element.querySelector("a").querySelector("span").text.trim();

      categoryOptionsRecipeCards.add(CategoryOptionsRecipeCard(
        title: title,
        href: href,
        photoUrl: photoUrl,
      ));
      // print("**********************************");
      // print(title);
      // print(href);
      // print(photoUrl);
      // print("**********************************");
    });
    // print("**********************************");

    // print(categoryOptionsRecipeCards[1].href);

    // print("**********************************");

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
    // print(recipeCards);
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
    // TODO Layout: CatagoryOptions , CatagoryRecipes
    return Scaffold(
      appBar: isLoading
          ? AppBar()
          : AppBar(
              title: Text(categoryTitle),
            ),
      body: isLoading
          ? CircularProgressIndicator()
          : Column(
              children: <Widget>[
                Container(
                  height: 170,
                  // width: 400,
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.only(
                      top: 15,
                    ),
                    scrollDirection: Axis.horizontal,
                    itemCount: categoryOptionsRecipeCards.length,
                    itemBuilder: (context, i) => GestureDetector(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SearchResultsScreen(
                              url: categoryOptionsRecipeCards[i].href))),
                      child: Container(
                        height: 110,
                        width: 120,
                        child: Column(
                          children: <Widget>[
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(
                                categoryOptionsRecipeCards[i].photoUrl,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Text(
                                categoryOptionsRecipeCards[i].title,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  child: Text(categoryDesc),
                ),
                Container(
                  height: 400,
                  child: BuildRecipeListResults(
                    recipeCards: recipeCards,
                  ),
                ),
              ],
            ),
    );
  }
}
