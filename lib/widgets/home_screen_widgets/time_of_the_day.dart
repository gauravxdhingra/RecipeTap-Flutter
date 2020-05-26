import 'package:flutter/material.dart';
import 'package:recipetap/pages/categories_recipe_screen.dart';
import 'package:recipetap/pages/search_results.dart';

Padding timeRecommendation(
    BuildContext context, String text, String image, String url) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
    child: Container(
      height: MediaQuery.of(context).size.height * 0.2,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        image: DecorationImage(
          image: AssetImage(
            image,
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: InkWell(
        child: Center(
            child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.w300,
          ),
        )),
        onTap: () {
          if (image == "assets/images/fridge.jpg") {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SearchResultsScreen(
                  excl: "",
                  incl: "",
                  appBarTitle: "Midnight Cravings",
                  url: url,
                ),
              ),
            );
          } else
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CategoryRecipesScreen(
                  url: url,
                  categoryName: "",
                ),
              ),
            );
        },
      ),
    ),
  );
}
