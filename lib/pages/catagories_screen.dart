import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

class CatagoriesScreen extends StatefulWidget {
  CatagoriesScreen({Key key}) : super(key: key);

  @override
  _CatagoriesScreenState createState() => _CatagoriesScreenState();
}

class _CatagoriesScreenState extends State<CatagoriesScreen> {
  List catagories = [];

  @override
  void initState() {
    super.initState();
  }

  getData() async {
    final String url = "https://www.allrecipes.com/recipes/";
    final response = await http.get(url);
    dom.Document document = parser.parse(response.body);

    document.getElementsByClassName("heading__h3").forEach((element) {
      catagories.add(element.text);
      print(element.text);
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
