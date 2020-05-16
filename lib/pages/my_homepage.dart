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
  String headline;

  List ingredients = [];
  List directions = [];
  List nutritionalFacts = [];

  getData() async {
    final response = await http.get(url);
    dom.Document document = parser.parse(response.body);

    headline =
        document.getElementsByClassName("headline heading-content")[3].text;

    document.getElementsByClassName("ingredients-item-name").forEach((element) {
      final iingred = element.text.trim();
      ingredients.add(iingred);
    });

    document.getElementsByClassName("section-body").forEach((element) {
      final istep = element.text.trim();
      directions.add(istep);
    });
// section-body
// subcontainer instructions-section-item
    String nutritionText = directions[directions.length - 1];
    List<String> roughNutri = nutritionText.split("  ");
    roughNutri.forEach((element) {
      element = element.trim();
    });
    nutritionalFacts = roughNutri;

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
          : Column(
              children: <Widget>[
                Container(
                  height: 250,
                  child: ListView.builder(
                    itemCount: ingredients.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Text(ingredients[index]);
                    },
                  ),
                ),
                Container(
                  height: 250,
                  child: ListView.builder(
                    itemCount: directions.length - 1,
                    itemBuilder: (BuildContext context, int index) {
                      return Text(directions[index]);
                    },
                  ),
                ),
                Container(
                  height: 250,
                  // child: Text(directions[directions.length - 1]),
                  child: ListView.builder(
                    itemCount: nutritionalFacts.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Text(nutritionalFacts[index]);
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
