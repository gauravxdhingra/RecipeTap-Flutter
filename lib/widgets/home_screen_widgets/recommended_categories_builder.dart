import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:recipetap/models/category_model.dart';
import 'dart:ui';

Container recommendedCategoriesBuilder(BuildContext context,
    List<CategoryModel> recommendedCategoriesList, Function mealsFromCategory) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 70,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      physics: BouncingScrollPhysics(),
      itemBuilder: (context, i) {
        return Container(
          child: Stack(
            children: <Widget>[
              Container(
                child: InkWell(
                  onTap: () => mealsFromCategory(
                    recommendedCategoriesList[i].categoryUrl,
                    context,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: ClayContainer(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: 25,
                      depth: 60,
                      spread: 5,
                      child: Container(
                        height: 70,
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Theme.of(context).accentColor,
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              recommendedCategoriesList[i].title.isEmpty
                                  ? ""
                                  : "#" + recommendedCategoriesList[i].title,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
                                    color: Colors.white,
                                  ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (recommendedCategoriesList[0].title.trim().isEmpty)
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                  child: Container(
                    // height: 80,
                    // width: MediaQuery.of(context).size.width,
                    decoration:
                        BoxDecoration(color: Colors.white.withOpacity(0.0)),
                  ),
                ),
            ],
          ),
        );
      },
      itemCount: recommendedCategoriesList.length,
    ),
  );
}
