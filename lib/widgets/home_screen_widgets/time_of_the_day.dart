import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';

import '../../pages/categories_recipe_screen.dart';
import '../../pages/search_results.dart';

Padding timeRecommendation(
  BuildContext context,
  String text,
  String image,
  String url,
  TextStyle textstyle,
) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
    child: ClayContainer(
      color: Theme.of(context).scaffoldBackgroundColor,
      borderRadius: 25,
      depth: 50,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.17,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 10),
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
          child: !text.contains("Late")
              ? Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    decoration: BoxDecoration(
                      // color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Text(
                      text,
                      style: textstyle.copyWith(
                        // color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w300,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 70, top: 5),
                    child: Container(
                      decoration: BoxDecoration(
                        // color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: Text(
                        text.split("?")[0] + "?\n" + text.split("?")[1],
                        style: textstyle.copyWith(
                          // color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                ),
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
    ),
  );
}
