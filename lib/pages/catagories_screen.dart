import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:recipetap/jump_screens/retry_screen.dart';
import 'package:recipetap/widgets/all_categories_scroll.dart';

import 'categories_recipe_screen.dart';

class CategoriesScreen extends StatefulWidget {
  CategoriesScreen({Key key}) : super(key: key);

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  bool isLoading = true;
  List categories = [];
  bool showRetry = false;
  Map<String, Map<String, Map<String, String>>> categoriesMap = {};

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    try {
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
        if (count > 5 && count < 14) {
          final category = element.querySelector("h3");

          categoriesMap[category.text] = {};

          print(element.querySelector("div").attributes["style"]);
          int i = 1;
          final categoryImageUrl = element
              .querySelector("div")
              .attributes["style"]
              .split("(")[i]
              .split("\"")[0];

          categoriesMap[category.text]
              ["imageUrl"] = {"imageUrl": categoryImageUrl};
          categoriesMap[category.text]["categories"] = {};
          element.querySelector("ul").querySelectorAll("li").forEach((element) {
            final text = element.querySelector("a").text;
            final link = element.querySelector("a").attributes["href"];

            categoriesMap[category.text]["categories"]
                .putIfAbsent(text, () => link);
          });
        }
      });

      setState(() {
        isLoading = false;
      });

      print(categoriesMap);
    } catch (e) {
      setState(() {
        showRetry = true;
      });
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: isLoading
          ? showRetry ? RetryScreen() : CircularProgressIndicator()
          : Stack(
              children: [
                AllCategoriesScroll(
                  categoriesMap: categoriesMap,
                ),
                // Container(
                //   height: MediaQuery.of(context).padding.top,
                //   color: Colors.black,
                // ),
              ],
            ),
    );
  }
}
