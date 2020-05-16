import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

class RecipeViewPage extends StatefulWidget {
  RecipeViewPage({Key key}) : super(key: key);
  static const routeName = 'recipe_view_page';
  @override
  _RecipeViewPageState createState() => _RecipeViewPageState();
}

class _RecipeViewPageState extends State<RecipeViewPage> {
  bool isLoading = true;

  final String url =
      // "https://www.allrecipes.com/recipe/262499/tandoori-paneer-tikka-masala/?internalSource=hub%20recipe&referringContentType=Search&clickId=cardslot%201";
      // "https://www.allrecipes.com/recipe/129000/caribbean-nachos/?internalSource=staff%20pick&referringId=1228&referringContentType=Recipe%20Hub&clickId=cardslot%201#nutrition";
      // "https://www.allrecipes.com/recipe/127491/easy-oreo-truffles/?internalSource=hub%20recipe&referringContentType=Search&clickId=cardslot%202";
      "https://www.allrecipes.com/recipe/228899/palak-paneer/?internalSource=hub%20recipe&referringContentType=Search&clickId=cardslot%201";
  // "https://www.allrecipes.com/recipe/259199/grilled-tandoori-lamb/?internalSource=user%20pref&referringContentType=Homepage&clickId=cardslot%209";

  bool oldWebsite;

  String headline;
  String desc;
  String time;
  String servings;
  List images = [];
  List ingredients = [];
  List directions = [];
  List nutritionalFacts = [];
  List nutritionalFactsNew = [];
  List cooksNotes = [];

  bool nutritionalFactsExits = false;
  bool cooksNotesExits = false;

  getData() async {
    final response = await http.get(url);
    dom.Document document = parser.parse(response.body);

//
    // oldWebsite =

    try {
      document.getElementsByClassName("magazine-bar__social")[0].text;
      oldWebsite = false;
    } catch (e) {
      print('old website');
      oldWebsite = true;
    }

    if (oldWebsite) {
      headline =
          document.getElementsByClassName("headline heading-content")[3].text;
// margin-0-auto

      var coverimg = document
          .getElementsByClassName(
              "icon icon-pinterest-circle-solid social-icon pinterest-transparent")[0]
          .querySelector("a")
          .attributes["href"]
          .toString()
          .split("%3Furl%3D")[1]
          .split("&descri")[0]
          .replaceAll("%253A", ":")
          .replaceAll("%252F", "/")
          .replaceAll("%3A", ":")
          .replaceAll("%2F", "/");

      // .querySelector("img")
      // .attributes["src"];
      // print(coverimg);
      images.add(coverimg);

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
              coverimg) {
            images.add(
              "https://images.media-allrecipes.com/userphotos/" +
                  newElement +
                  ".jpg",
            );
          }
        }
      });
      print(images);
      // 0 prep
      // 1 cook
      // 2 total
      // 3 servings
      // 4. Servings

      time = document
          .getElementsByClassName("recipe-meta-item-body")[2]
          .text
          .trim();
      servings = document
          .getElementsByClassName("recipe-meta-item-body")[3]
          .text
          .trim();

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
          if (element != '') nutritionalFacts.add(element.trim());
        });
      }

      // nutritionalFacts = roughNutri;
      final selector = document.getElementsByClassName("recipe-note container");
      cooksNotesExits = selector.isNotEmpty;
      if (selector.isNotEmpty)
        selector.forEach((element) {
          final inote = element.text.trim();
          if (inote != '' && inote != "Cook's Notes:") cooksNotes.add(inote);
        });
    } else {
      headline = document.getElementsByClassName("recipe-summary__h1")[0].text;
// margin-0-auto

// TODO add to images list
      final imagerow = document
          .getElementsByClassName("photo-strip__items")[0]
          .querySelectorAll("li");
      // [0]
      // .querySelector("a")
      // .querySelector("img");

      imagerow.forEach((element) {
        if (element.querySelector("a").attributes["href"] != "#") {
          final src =
              element.querySelector("a").querySelector("img").attributes["src"];
          print(src);
        }
      });

      // print(imagerow.attributes["src"]);

      time = document.getElementsByClassName("ready-in-time")[0].text.trim();
      // final servingss = document
      //     .getElementsByClassName("recipe-ingredients ng-scope");

      final servingss = document
          .querySelector('[ng-controller="ar_controllers_recipe_ingredient"]')
          .attributes["ng-init"]
          .split("(")[1]
          .split(",")[0];
      servings = servingss;
      print(servingss);

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

      document
          .getElementsByClassName("recipe-directions__list--item")
          .forEach((element) {
        final istep = element.text.trim();
        directions.add(istep);
      });
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
      final selector = document.getElementsByClassName("recipe-footnotes__h4");
      // recipe-footnotes__header
      cooksNotesExits = selector[0].text.trim() == "Footnotes";
      if (selector.isNotEmpty) {
        document.getElementsByClassName("recipe-footnotes").forEach((element) {
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
      }
    }
    setState(() {
      print(headline);
      print(ingredients[0]);
      isLoading = false;
    });
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => getData(),
      ),
      appBar: AppBar(
        title: isLoading ? Text('') : Text(headline),
      ),
      body: isLoading
          ? CircularProgressIndicator()
          : SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  // Description
                  Text(desc),
                  // Time
                  Text(time),
                  // Servings
                  Text(servings),
                  // Ingredients
                  Container(
                    height: 200,
                    child: ListView.builder(
                      itemCount: oldWebsite
                          ? ingredients.length
                          : ingredients.length - 2,
                      itemBuilder: (BuildContext context, int index) {
                        return Text(ingredients[index]);
                      },
                    ),
                  ),
                  // directons/steps
                  Container(
                    height: 200,
                    child: ListView.builder(
                      itemCount: directions.length - 1,
                      itemBuilder: (BuildContext context, int index) {
                        return Text(directions[index]);
                      },
                    ),
                  ),
                  // nutritional facts
                  if (nutritionalFactsExits)
                    Container(
                      height: 100,
                      // child: Text(directions[directions.length - 1]),
                      child: oldWebsite
                          ? ListView.builder(
                              itemCount: nutritionalFacts.length - 1,
                              itemBuilder: (BuildContext context, int index) {
                                print(nutritionalFacts[index]
                                    .toString()
                                    .trimRight());
                                return Text(nutritionalFacts[index]
                                    .toString()
                                    .trimRight());
                              },
                            )
                          : ListView.builder(
                              itemCount: nutritionalFactsNew.length,
                              itemBuilder: (BuildContext context, int index) {
                                print(nutritionalFactsNew[index]
                                    .toString()
                                    .trim());
                                return Text(nutritionalFactsNew[index]
                                    .toString()
                                    .trim());
                              },
                            ),
                    ),
                  // extra cooks notes
                  if (cooksNotesExits)
                    // Container(
                    //   child:
                    //       Text(cooksNotes[0].toString().substring(20).trim()),
                    // ),
                    Container(
                      height: 100,
                      child: oldWebsite
                          ? ListView.builder(
                              itemCount: cooksNotes.length,
                              itemBuilder: (BuildContext context, int index) {
                                print(cooksNotes.length);
                                return Text(cooksNotes[index]
                                    .toString()
                                    .substring(20)
                                    .trim());
                              })
                          : ListView.builder(
                              itemCount: cooksNotes[0].length,
                              itemBuilder: (BuildContext context, int index) {
                                print(cooksNotes[0].length);
                                return Text(cooksNotes[0][index].trim());
                              }),
                    ),
                ],
              ),
            ),
    );
  }
}
