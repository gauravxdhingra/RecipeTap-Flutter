import 'package:flutter/material.dart';
import 'package:recipetap/models/category_model.dart';

Container recommendedCategoriesBuilder(BuildContext context,
    List<CategoryModel> recommendedCategoriesList, Function mealsFromCategory) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 70,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      physics: BouncingScrollPhysics(),
      itemBuilder: (context, i) {
        return InkWell(
          onTap: () => mealsFromCategory(
            recommendedCategoriesList[i].categoryUrl,
            context,
          ),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
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
                  "#" + recommendedCategoriesList[i].title,
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                        color: Colors.white,
                      ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        );
      },
      itemCount: recommendedCategoriesList.length,
    ),
  );
}
