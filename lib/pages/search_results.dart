import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:recipetap/models/recipe_card.dart';
import 'package:recipetap/pages/recipe_view_page.dart';
import 'package:recipetap/widgets/build_recipe_list_results.dart';
import 'package:recipetap/widgets/loading_spinner.dart';

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

  SearchResultsScreen({
    Key key,
    @required this.url,
    @required this.appBarTitle,
    this.incl,
    this.excl,
    this.include,
    this.exclude,
  }) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    // final inclexclArgs = ModalRoute.of(context).settings.arguments;
    // print(inclexclArgs.incl);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.appBarTitle ?? "",
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        bottom: (widget.incl.toString().isNotEmpty ||
                widget.excl.toString().isNotEmpty)
            ? PreferredSize(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Including: "),
                        Text(
                          widget.include.toString().split("[")[1].split("]")[0],
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Excluding: "),
                        Text(
                          widget.exclude.toString().split("[")[1].split("]")[0],
                          overflow: TextOverflow.ellipsis,
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
            ),
    );
  }
}
