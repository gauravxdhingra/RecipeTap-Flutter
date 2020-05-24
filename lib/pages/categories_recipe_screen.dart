import 'package:clay_containers/clay_containers.dart';
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
    }

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
        // backgroundColor: Theme.of(context).primaryColor,
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
                                        builder: (context) =>
                                            SearchResultsScreen(
                                                excl: "",
                                                incl: "",
                                                appBarTitle:
                                                    categoryOptionsRecipeCards[
                                                            i]
                                                        .title,
                                                url: categoryOptionsRecipeCards[
                                                        i]
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
                                              categoryOptionsRecipeCards[i]
                                                  .title,
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
                  SliverToBoxAdapter(
                      child: Container(
                    height: 10,
                  )),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, i) {
                        // print(recipeCards.length);
                        if (i == recipeCards.length) return LoadingSpinner();
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          child: GestureDetector(
                            onTap: () => goToRecipe(recipeCards[i].href,
                                recipeCards[i].photoUrl, context),
                            child: ClayContainer(
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
                                            child: Image.network(
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
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 15.0,
                                                  ),
                                                  child: Text(
                                                    recipeCards[i].title,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 25,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                    ),
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
                                      // TODO Fab Fav
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
      ),
    );
  }
}
