import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recipetap/jump_screens/aww_snap_screen.dart';
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
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primarySwatch: Colors.red,
      ),
      darkTheme: ThemeData.dark().copyWith(),

      // home: AwwSnapScreen(),

      routes: {
        '/': (context) => SearchScreen(),
        SearchScreen.routeName: (context) => SearchScreen(),
        RecipeViewPage.routeName: (context) => RecipeViewPage(),

      },
      onUnknownRoute: ,
    );
  }
}
