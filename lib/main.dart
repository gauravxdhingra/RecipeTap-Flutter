import 'package:flutter/material.dart';
import 'package:recipetap/pages/search_screen.dart';

import 'pages/recipe_view_page.dart';

void main() {
  runApp(MyApp());
}

// TODO: Handle Text Overflows Everywhere in the app

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // home: MyHomePage(),
      routes: {
        '/': (context) => SearchScreen(),
        SearchScreen.routeName: (context) => SearchScreen(),
        RecipeViewPage.routeName: (context) => RecipeViewPage(),
      },
    );
  }
}
