import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isLoading = true;

  final String url =
      // "https://www.allrecipes.com/recipe/262499/tandoori-paneer-tikka-masala/?internalSource=hub%20recipe&referringContentType=Search&clickId=cardslot%201";
      "https://www.allrecipes.com/recipe/129000/caribbean-nachos/?internalSource=staff%20pick&referringId=1228&referringContentType=Recipe%20Hub&clickId=cardslot%201#nutrition";

  bool oldWebsite;

  String headline;
  String desc;
  List ingredients = [];
  List directions = [];
  List nutritionalFacts = [];
  List cooksNotes = [];

  bool nutritionalFactsExits = false;
  bool cooksNotesExits = false;

  getData() async {
    final response = await http.get(url);
    dom.Document document = parser.parse(response.body);

//
    // oldWebsite =

    try {
      document.getElementsByClassName(
          "recipes-txt {active:topBrowseRecipePanel_showing} ng-isolate-scope");
      oldWebsite = false;
    } catch (e) {
      print('old website');
      oldWebsite = true;
    }

    if (oldWebsite) {
      headline =
          document.getElementsByClassName("headline heading-content")[3].text;
// margin-0-auto

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
          : oldWebsite
              ? SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      // Description
                      Text(desc),
                      // Ingredients
                      Container(
                        height: 250,
                        child: ListView.builder(
                          itemCount: ingredients.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Text(ingredients[index]);
                          },
                        ),
                      ),
                      // directons/steps
                      Container(
                        height: 250,
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
                          child: ListView.builder(
                            itemCount: nutritionalFacts.length - 1,
                            itemBuilder: (BuildContext context, int index) {
                              print(nutritionalFacts[index]
                                  .toString()
                                  .trimRight());
                              return Text(nutritionalFacts[index]
                                  .toString()
                                  .trimRight());
                            },
                          ),
                        ),
                      // extra cooks notes
                      if (cooksNotesExits)
                        Container(
                          child: Text(
                              cooksNotes[0].toString().substring(20).trim()),
                        ),
                    ],
                  ),
                )
              : Container(
                  height: 100,
                  width: 100,
                  color: Colors.black,
                ),
    );
  }
}
