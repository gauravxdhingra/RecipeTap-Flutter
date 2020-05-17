import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

class CategoriesScreen extends StatefulWidget {
  CategoriesScreen({Key key}) : super(key: key);

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  bool isLoading = true;
  List categories = [];
  var categoriesMap;

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    final String url = "https://www.allrecipes.com/recipes/";
    final response = await http.get(url);
    dom.Document document = parser.parse(response.body);

    document.getElementsByClassName("heading__h3").forEach((element) {
      categories.add(element.text);
      print(element.text);
    });
    int count = 0;
    document.querySelectorAll("section").forEach((element) {
      count++;
      if (count > 10 && count < 20) {
        final category = element.getElementsByClassName("heading__h3")[0];

        categoriesMap[category] = {};

        final categoryImageUrl = element
            .getElementsByClassName("img-header")[0]
            .attributes["style"]
            .split("(")[1]
            .split("\"")[0];

        categoriesMap[category]["imageUrl"] = categoryImageUrl;

        element.querySelector("ul").querySelectorAll("li").forEach((element) {
          final text = element.querySelector("a").text;
          final link = element.querySelector("a").attributes["href"];
        });
      }
    });

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(),
    );
  }
}
