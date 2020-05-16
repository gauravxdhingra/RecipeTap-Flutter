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
      "https://www.allrecipes.com/recipe/262499/tandoori-paneer-tikka-masala/?internalSource=hub%20recipe&referringContentType=Search&clickId=cardslot%201";

  String headline;

  List ingredients = [];

  getData() async {
    final response = await http.get(url);
    dom.Document document = parser.parse(response.body);

    headline =
        document.getElementsByClassName("headline heading-content")[3].text;

    document.getElementsByClassName("ingredients-item-name").forEach((element) {
      final iingred = element.text.trim();
      ingredients.add(iingred);
    });
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
      appBar: AppBar(
          // title: Text(headline),
          ),
      body: isLoading
          ? CircularProgressIndicator()
          : Container(
              height: 250,
              child: Column(
                children: <Widget>[
                  Text('ingredients'),
                  // Text(ingredients[0]),
                  // ListView.builder(
                  //   itemBuilder: (context, index) {
                  //     return Text(ingredients[index]);
                  //   },
                  // ),
                ],
              ),
            ),
    );
  }
}
