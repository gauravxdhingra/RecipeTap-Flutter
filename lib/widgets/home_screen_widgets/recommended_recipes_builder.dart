import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:recipetap/models/favourites_model.dart';
import 'package:recipetap/pages/recipe_view_page.dart';
import 'dart:ui';

Container recommendedRecipesBuilder(
    BuildContext context, List<FavouritesModel> recommended) {
  return Container(
    height: MediaQuery.of(context).size.height >= 720
        ? MediaQuery.of(context).size.height / 2.5
        : MediaQuery.of(context).size.height / 2.0,
    //  MediaQuery.of(context).size.height / 2.5,
    child: ListView.builder(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemCount: recommended.length,
      itemBuilder: (context, i) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          width: MediaQuery.of(context).size.height >= 740
              ? MediaQuery.of(context).size.width * 4 / 5
              : MediaQuery.of(context).size.width * 3.5 / 5,
          child: Stack(
            children: <Widget>[
              Column(
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
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.2),
                            child: Column(
                              children: <Widget>[
                                Stack(
                                  children: <Widget>[
                                    ClipRRect(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                      child: (recommended[i].coverPhotoUrl ==
                                                  null ||
                                              recommended[i].coverPhotoUrl ==
                                                  "https://www.allrecipes.com/img/icons/generic-recipe.svg" ||
                                              recommended[i].coverPhotoUrl ==
                                                  "https://images.media-allrecipes.com/images/82579.png" ||
                                              recommended[i].coverPhotoUrl ==
                                                  "https://images.media-allrecipes.com/images/79591.png")
                                          ? Container(
                                              // height: 210,
                                              child: Image.asset(
                                                'assets/logo/banner.png',
                                                // fit: BoxFit.scaleDown,
                                                // width: 100,
                                                scale: 3,
                                                height: MediaQuery.of(context)
                                                            .size
                                                            .height >=
                                                        720
                                                    ? MediaQuery.of(context)
                                                            .size
                                                            .height /
                                                        5
                                                    : MediaQuery.of(context)
                                                            .size
                                                            .height /
                                                        4.0,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                alignment: Alignment.lerp(
                                                    Alignment.center,
                                                    Alignment.bottomCenter,
                                                    0.5),
                                                color: Theme.of(context)
                                                            .brightness ==
                                                        Brightness.dark
                                                    ? Colors.white
                                                    : null,
                                              ),
                                            )
                                          : Image.network(
                                              recommended[i].coverPhotoUrl,
                                              // height: 210,
                                              height: MediaQuery.of(context)
                                                          .size
                                                          .height >=
                                                      720
                                                  ? MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      5
                                                  : MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      4.0,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
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
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        height: 50,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 15.0,
                                            ),
                                            child: Text(
                                              recommended[i].title,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
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
              if (recommended[0].title.trim() == "")
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
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
    ),
  );
}
