import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:provider/provider.dart';
import 'package:recipetap/interactive_recipe_pages/start_cooking.dart';
import 'package:recipetap/jump_screens/loading_recipe_screen.dart';
import 'package:recipetap/models/recipe_model.dart';
import 'package:recipetap/provider/recently_viewed_provider.dart';
import 'package:recipetap/widgets/recipe_view_page_widget.dart';

class RecipeViewPage extends StatefulWidget {
  final String url;
  final String coverImageUrl;
  RecipeViewPage({Key key, this.url, this.coverImageUrl}) : super(key: key);
  static const routeName = '/recipe_view_page';
  @override
  _RecipeViewPageState createState() => _RecipeViewPageState();
}

class _RecipeViewPageState extends State<RecipeViewPage> {
  bool isLoading = true;

  // TODO handle empty image
  // TODO solve-if image rail is empty
  // TODO: Validate time and Servings mixing prevent
  // TODO: all getData functions in try and catch
  // TODO: Solve no image bug
  // https://images.media-allrecipes.com/images/82579.png

  // final String url =
  //     widget.url;
  // "https://www.allrecipes.com/recipe/262499/tandoori-paneer-tikka-masala/?internalSource=hub%20recipe&referringContentType=Search&clickId=cardslot%201";
  // "https://www.allrecipes.com/recipe/129000/caribbean-nachos/?internalSource=staff%20pick&referringId=1228&referringContentType=Recipe%20Hub&clickId=cardslot%201#nutrition";
  // "https://www.allrecipes.com/recipe/127491/easy-oreo-truffles/?internalSource=hub%20recipe&referringContentType=Search&clickId=cardslot%202";
  // "https://www.allrecipes.com/recipe/228899/palak-paneer/?internalSource=hub%20recipe&referringContentType=Search&clickId=cardslot%201";
  // "https://www.allrecipes.com/recipe/259199/grilled-tandoori-lamb/?internalSource=user%20pref&referringContentType=Homepage&clickId=cardslot%209";

  bool oldWebsite;

  String headline;
  String desc;
  String time;
  String servings;
  String yeild;
  List<String> images = [];
  List ingredients = [];
  List directions = [];
  List nutritionalFacts = [];
  List nutritionalFactsNew = [];
  List cooksNotes = [];

  bool nutritionalFactsExits = false;
  bool cooksNotesExits = false;
  bool yeildExists = false;
  bool timeExists = false;
  bool servingsExist = false;
  bool newWebsiteFooterNotesExist = false;
  RecipeModel recipe;

  getData() async {
    final String url = widget.url;
    final String coverImageUrl = widget.coverImageUrl;
    // images.add(coverImageUrl);
    // .replaceAll("/300x300", "");
    final response = await http.get(url);
    dom.Document document = parser.parse(response.body);
    print(url);
    try {
      document.getElementsByClassName("magazine-bar__social")[0].text;
      oldWebsite = false;
      print('new website');
    } catch (e) {
      print('old website');
      oldWebsite = true;
    }

    if (oldWebsite) {
      headline =
          document.getElementsByClassName("headline heading-content")[3].text;

      final srcfirstSplit = coverImageUrl.split("photos/")[0];
      final srcsecondsplit = coverImageUrl.split("photos/")[1].split("/")[1];
      final srcc = srcfirstSplit + "photos/" + srcsecondsplit;
      print(srcc);
      images.add(srcc);

      var otherImagesRef = document.getElementsByClassName("ugc-photos-link");
      int count = 0;
      otherImagesRef.forEach((element) {
        count++;
        if (count > 2) {
          final newElement = element
              // .querySelector("a")
              // .querySelector("div")
              .attributes["data-cms-id"];
          if ("https://images.media-allrecipes.com/userphotos/" +
                  newElement +
                  ".jpg" !=
              coverImageUrl) {
            if (!images.contains(
                "https://images.media-allrecipes.com/userphotos/" +
                    newElement +
                    ".jpg")) {
              images.add(
                "https://images.media-allrecipes.com/userphotos/" +
                    newElement +
                    ".jpg",
              );
            }
          }
        }
      });
      print(images);

      // 0 prep
      // 1 cook
      // 2 total
      // 3 servings
      // 4. Servings

      final infoBoxes = document
          .getElementsByClassName(
              "recipe-meta-container two-subcol-content clearfix")[0]
          .getElementsByClassName("recipe-meta-item");

      try {
        int counttt = 0;
        infoBoxes.forEach((element) {
          counttt++;
          if (element
              .getElementsByClassName("recipe-meta-item-header")[counttt]
              .text
              .trim()
              .contains("total")) {
            time = element
                .getElementsByClassName("recipe-meta-item-body")[counttt]
                .text
                .trim();
            timeExists = true;
          }
        });
      } catch (e) {
        time = "--";
        timeExists = false;
      }

      try {
        int counttt = 0;
        infoBoxes.forEach((element) {
          if (element
              .getElementsByClassName("recipe-meta-item-header")[counttt]
              .text
              .trim()
              .contains("erving")) {
            servings = element
                .getElementsByClassName("recipe-meta-item-body")[counttt]
                .text
                .trim();
            servingsExist = true;
          }
        });
      } catch (e) {
        servings = "--";
        servingsExist = false;
      }

      try {
        infoBoxes.forEach((element) {
          int counttt = 0;
          if (element
              .getElementsByClassName("recipe-meta-item-header")[counttt]
              .text
              .trim()
              .contains("ield")) {
            yeild = element
                .getElementsByClassName("recipe-meta-item-body")[counttt]
                .text
                .trim();
            yeildExists = true;
          }
        });
      } catch (e) {
        yeild = "--";
        yeildExists = false;
      }

      desc = document.getElementsByClassName("margin-0-auto")[0].text.trim();

      document
          .getElementsByClassName("ingredients-item-name")
          .forEach((element) {
        final iingred = element.text.trim();
        ingredients.add(iingred);
      });

      document.getElementsByClassName("section-body").forEach((element) {
        final istep = element.text.trim();
        directions.add(istep);
      });
      // section-body
      // subcontainer instructions-section-item

      nutritionalFactsExits = document
          .getElementsByClassName("partial recipe-nutrition-section")
          .isNotEmpty;

      if (nutritionalFactsExits) {
        String nutritionText = directions[directions.length - 1];
        List<String> roughNutri = nutritionText.split("  ");
        roughNutri.forEach((element) {
          if (element != '')
            nutritionalFacts.add(
              element.trim().replaceAll(";", "").replaceAll(".", ""),
            );
        });
      }

      // nutritionalFacts = roughNutri;
      final selector = document.getElementsByClassName("recipe-note container");
      cooksNotesExits = selector.isNotEmpty;
      if (selector.isNotEmpty)
        selector.forEach((element) {
          final inote = element.text.trim();
          if (inote != '' && inote.contains("Cook's Note:"))
            cooksNotes.add(inote.substring(20).trim());
        });

      cooksNotes.forEach((element) {
        if (element.toString().contains("Reynold")) {
          cooksNotesExits = false;
        }
        if (element.toString().contains("Partner")) {
          cooksNotesExits = false;
        }
      });
//
//
//
//
//
    } else {
      headline = document.getElementsByClassName("recipe-summary__h1")[0].text;

      final imagerow = document
          .getElementsByClassName("photo-strip__items")[0]
          .querySelectorAll("li");

      final srcfirstSplit = coverImageUrl.split("photos/")[0];
      final srcsecondsplit = coverImageUrl.split("photos/")[1].split("/")[1];
      final srcc = srcfirstSplit + "photos/" + srcsecondsplit;
      // print(srcc);
      images.add(srcc);

      imagerow.forEach((element) {
        if (element.querySelector("a").attributes["href"] != "#" ||
            element.querySelector("a") == null) {
          final src =
              element.querySelector("a").querySelector("img").attributes["src"];
          final srcfirstSplit = src.split("photos/")[0];
          final srcsecondsplit = src.split("photos/")[1].split("/")[1];
          final srcc = srcfirstSplit + "photos/" + srcsecondsplit;
          print(srcc);
          if (!images.contains(srcc)) {
            images.add(srcc);
          }
        }
      });

      // print(imagerow.attributes["src"]);
      try {
        time = document.getElementsByClassName("ready-in-time")[0].text.trim();
        timeExists = true;
      } catch (e) {
        timeExists = false;
      }
      // final servingss = document
      //     .getElementsByClassName("recipe-ingredients ng-scope");

      try {
        final servingss = document
            .querySelector('[ng-controller="ar_controllers_recipe_ingredient"]')
            .attributes["ng-init"]
            .split("(")[1]
            .split(",")[0];
        servings = servingss;
        servingsExist = true;
        print(servingss);
      } catch (e) {
        servingsExist = false;
      }

      desc = document
          .getElementsByClassName("submitter__description")[0]
          .text
          .trim();

      document
          .getElementsByClassName("recipe-ingred_txt added")
          .forEach((element) {
        final iingred = element.text.trim();
        ingredients.add(iingred);
      });

      int countt = 0;
      if (countt <
          document
                  .getElementsByClassName("recipe-directions__list--item")
                  .length -
              1) {
        countt++;
        document
            .getElementsByClassName("recipe-directions__list--item")
            .forEach((element) {
          final istep = element.text.trim().replaceAll("Watch Now", "");
          directions.add(istep);
          print(istep);
        });
      }
      // section-body
      // subcontainer instructions-section-item

      nutritionalFactsExits =
          document.getElementsByClassName("nutrition-summary-facts").isNotEmpty;

      if (nutritionalFactsExits) {
        document.getElementsByClassName("nutrition-summary-facts");

        // print(nutritionalFactsNew[0]);
        // 1. calories
        // 2. Fat
        // 3. Carbohydrates
        // 4. Protien
        // 5. Cholestrol
        // 6. Sodium

        nutritionalFactsNew.add(document
            .querySelector('[itemprop="calories"]')
            .text
            .replaceAll(";", ""));
        nutritionalFactsNew.add(
            document.querySelector('[itemprop="fatContent"]').text + "g fat");
        nutritionalFactsNew.add(
            document.querySelector('[itemprop="carbohydrateContent"]').text +
                "g carbohydrates");
        nutritionalFactsNew.add(
            document.querySelector('[itemprop="proteinContent"]').text +
                "g protein");
        nutritionalFactsNew.add(
            document.querySelector('[itemprop="cholesterolContent"]').text +
                "mg cholestrol");
        nutritionalFactsNew.add(
            document.querySelector('[itemprop="sodiumContent"]').text +
                "mg sodium");
      }

      // Footer notes
      try {
        final selector =
            document.getElementsByClassName("recipe-footnotes__h4");
        // recipe-footnotes__header

        if (selector[0].hasContent()) {
          cooksNotesExits = selector[0].text.trim() == "Footnotes";
          if (selector.isNotEmpty) {
            document
                .getElementsByClassName("recipe-footnotes")
                .forEach((element) {
              final inote = element.text.trim();
              if (inote != '' || inote != "Footnotes") {
                cooksNotes.add(inote.trim());
                // cooksNotes = cooksNotes[0].toString().split("  ");
              }
            });
            cooksNotes[0] = cooksNotes[0]
                .toString()
                .substring(10)
                .trim()
                .split("                ");
            print('ckn' + cooksNotes[0].length.toString());
            if (cooksNotes[0].toString().contains("Reynold")) {
              cooksNotesExits = false;
            }
            if (cooksNotes[0].toString().contains("Partner")) {
              cooksNotesExits = false;
            }
            if (cooksNotes[0].toString().contains("Facts")) {
              cooksNotesExits = false;
            }
          }
        }
        newWebsiteFooterNotesExist = true;
        if (cooksNotes[0].toString().contains("Facts")) {
          newWebsiteFooterNotesExist = false;
        }
        if (cooksNotes[0].toString().contains("Partner")) {
          newWebsiteFooterNotesExist = false;
        }
        if (cooksNotes[0].toString().contains("Facts")) {
          newWebsiteFooterNotesExist = false;
        }
      } catch (err) {
        newWebsiteFooterNotesExist = false;
      }
    }

    if (oldWebsite) {
      if (cooksNotesExits) {
        for (int i = 0; i < cooksNotes.length; i++) {
          cooksNotes[i] = cooksNotes[i].substring(20).trim();
        }
      }
    } else {
      if (newWebsiteFooterNotesExist) {
        for (int i = 0; i < cooksNotes[0].length; i++) {
          cooksNotes[0][i] = cooksNotes[0][i].trim();
        }
      }
    }
    setState(() {
      print(headline);
      print(ingredients[0]);
      isLoading = false;
      if (time == null) timeExists = false;
    });
    recipe = RecipeModel(
      title: headline,
      coverPhotoUrl: images,
      desc: desc,
      time: time,
      servings: servings,
      yeild: yeild,
      ingredients: ingredients,
      steps: directions,
      nutritionalFacts: nutritionalFacts,
      cooksNotes: oldWebsite
          ? cooksNotes
          : newWebsiteFooterNotesExist ? cooksNotes[0] : [],
    );
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print(cooksNotes);
    // getData();
    return Scaffold(
      // appBar: AppBar(
      //   title: isLoading ? Text('') : Text(headline),
      // ),

      // TODO no empty search field
      body: isLoading
          ? LoadingRecipeScreen()
          : Consumer<RecentsProvider>(
              builder: (ctx, auth, _) => RecipeViewPageWidget(
                headline: headline,
                images: images,
                desc: desc,
                timeExists: timeExists,
                time: time,
                servingsExist: servingsExist,
                servings: servings,
                nutritionalFactsExits: nutritionalFactsExits,
                oldWebsite: oldWebsite,
                nutritionalFacts: nutritionalFacts,
                nutritionalFactsNew: nutritionalFactsNew,
                yeildExists: yeildExists,
                yeild: yeild,
                ingredients: ingredients,
                directions: directions,
                cooksNotesExits: cooksNotesExits,
                newWebsiteFooterNotesExist: newWebsiteFooterNotesExist,
                cooksNotes: cooksNotes,
                recipe: recipe,
              ),
            ),
      floatingActionButton: isLoading
          ? null
          : FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StartCooking(
                      recipe: recipe,
                    ),
                  ),
                );
              },
              label: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Start Cooking'),
                  Icon(Icons.navigate_next),
                ],
              ),
            ),
    );
  }
}
