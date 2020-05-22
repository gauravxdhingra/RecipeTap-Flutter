import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:recipetap/jump_screens/loading_category_recipes.dart';
import 'package:recipetap/models/category_options_card.dart';
import 'package:recipetap/models/recipe_card.dart';
import 'package:recipetap/pages/search_results.dart';
import 'package:recipetap/widgets/build_recipe_list_results.dart';
import 'package:recipetap/widgets/loading_spinner.dart';

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
  bool firstPage = true;
  int page = 2;
  bool hasMore = true;
  int currentMax;

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    final String url = widget.url;
    // 'https://www.allrecipes.com/search/results/?ingIncl=$incl&ingExcl=$excl&sort=re';
    getSearchResults(url);
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print("loading More");
        loadMore();
      }
    });
  }

  getSearchResults(url) async {
    print(url);
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

// TODO fix resolution

      final title =
          element.querySelector("a").querySelector("span").text.trim();

      categoryOptionsRecipeCards.add(CategoryOptionsRecipeCard(
        title: title,
        href: href,
        photoUrl: photoUrl,
      ));
    });

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
// TODO: Category recipe of the day
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
// TODO bummer page
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
    // TODO Layout: CatagoryOptions , CatagoryRecipes
    // TODO Loading Progress
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        // appBar: isLoading
        //     ? AppBar()
        //     : AppBar(
        //         title: Text(categoryTitle),
        //         elevation: 0,
        //       ),
        body: isLoading
            ? LoadingCategoryRecipes()
            : CustomScrollView(
                physics: BouncingScrollPhysics(),
                controller: _scrollController,
                slivers: <Widget>[
                  SliverAppBar(
                    title: isLoading ? Text("") : Text(categoryTitle),
                    // elevation: 0.1,
                    // expandedHeight: MediaQuery.of(context).size.height / 3,
                    pinned: true,
                    // backgroundColor: Colors.white,
                    actions: <Widget>[
                      IconButton(icon: Icon(Icons.favorite), onPressed: () {})
                    ],
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
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
                                      CircleAvatar(
                                        radius: 50,
                                        backgroundImage: NetworkImage(
                                          categoryOptionsRecipeCards[i]
                                              .photoUrl,
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 10.0),
                                        child: Text(
                                          categoryOptionsRecipeCards[i].title,
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
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
                      // width: MediaQuery.of(context).size.width,
                      color: Theme.of(context).primaryColor,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                      child: Text(
                        categoryDesc,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                      child: Container(
                    height: 30,
                    color: Theme.of(context).primaryColor,
                  )),
                  SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, i) {
                        // print(recipeCards.length);
                        if (i == recipeCards.length) return LoadingSpinner();
                        return Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: GestureDetector(
                            onTap: () => goToRecipe(recipeCards[i].href,
                                recipeCards[i].photoUrl, context),
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                // topRight: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                                // bottomRight: Radius.circular(20),
                                topLeft: Radius.circular(20),
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
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                  ),
                                  color: Theme.of(context)
                                      .accentColor
                                      .withOpacity(0.6),
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
                                    textAlign: TextAlign.left,
                                  ),
                                  color: Theme.of(context)
                                      .accentColor
                                      .withOpacity(0.6),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      childCount:
                          hasMore ? recipeCards.length + 1 : recipeCards.length,
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      childAspectRatio: 20 / 13,
                      mainAxisSpacing: 20,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
