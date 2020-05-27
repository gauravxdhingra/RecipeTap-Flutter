import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:recipetap/models/favourites_model.dart';
import 'package:recipetap/pages/recipe_view_page.dart';

Container recommendedRecipesBuilder(
    BuildContext context, List<FavouritesModel> recommended) {
  return Container(
    height: MediaQuery.of(context).size.height / 2.8,
    child: ListView.builder(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemCount: recommended.length,
      itemBuilder: (context, i) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          width: MediaQuery.of(context).size.width * 4 / 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RecipeViewPage(
                              url: recommended[i].recipeUrl,
                              coverImageUrl: recommended[i].coverPhotoUrl,
                            ))),
                child: ClayContainer(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: 20,
                  depth: 50,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                      child: Container(
                        color: Theme.of(context).primaryColor.withOpacity(0.2),
                        child: Column(
                          children: <Widget>[
                            Stack(
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                  child: Image.network(
                                    recommended[i].coverPhotoUrl,
                                    height: 210,
                                    width: MediaQuery.of(context).size.width,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  // top: 0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .accentColor
                                          .withOpacity(0.6),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    height: 50,
                                    width: MediaQuery.of(context).size.width,
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 15.0,
                                        ),
                                        child: Text(
                                          recommended[i].title,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 25,
                                            fontWeight: FontWeight.w300,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 20),
                              child: Text(
                                recommended[i].desc,
                                style: TextStyle(
                                  // color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w300,
                                ),
                                maxLines: 2,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}
