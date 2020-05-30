import 'dart:ui';

import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';

import '../../models/favourites_model.dart';
import '../../pages/home_screen.dart';
import '../../pages/recipe_view_page.dart';
import '../../provider/recently_viewed_provider.dart';

class BuildFavInFavourites extends StatefulWidget {
  const BuildFavInFavourites({
    Key key,
    @required this.favRecipesList,
  }) : super(key: key);

  final List<FavouritesModel> favRecipesList;

  @override
  _BuildFavInFavouritesState createState() => _BuildFavInFavouritesState();
}

class _BuildFavInFavouritesState extends State<BuildFavInFavourites> {
  @override
  Widget build(BuildContext context) {
    return Container(
      
      height: MediaQuery.of(context).size.height >= 700
          ? MediaQuery.of(context).size.height / 2.5
          : MediaQuery.of(context).size.height / 2.0,

      // MediaQuery.of(context).size.height / 2.5,
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: widget.favRecipesList.length,
        itemBuilder: (context, i) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            width: MediaQuery.of(context).size.width * 4 / 5,
            child: Stack(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 10, bottom: 5),
                      child: InkWell(
                        onTap: () async {
                          final recipeurl1 = widget.favRecipesList[i].recipeUrl
                              .split("/recipe/")[1];
                          final recipeurll = recipeurl1.split("/")[0] +
                              "-" +
                              recipeurl1.split("/")[1];
                          await favoritesRef
                              .document(currentUser.email)
                              .collection('favs')
                              .document(recipeurll)
                              .delete();
                          widget.favRecipesList.removeAt(i);
                          setState(() {});
                          // favoritesRef.document(currentUser.email).collection('favs').document(favRecipesList[i].)
                        },
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Theme.of(context).primaryColor
                                    : Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.4),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Text('Remove'),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RecipeViewPage(
                                    url: widget.favRecipesList[i].recipeUrl,
                                    coverImageUrl:
                                        widget.favRecipesList[i].coverPhotoUrl,
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
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.2),
                              child: Column(
                                children: <Widget>[
                                  Stack(
                                    children: <Widget>[
                                      ClipRRect(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                        child: (widget.favRecipesList[i]
                                                        .coverPhotoUrl ==
                                                    null ||
                                                widget.favRecipesList[i]
                                                        .coverPhotoUrl ==
                                                    "https://www.allrecipes.com/img/icons/generic-recipe.svg" ||
                                                widget.favRecipesList[i]
                                                        .coverPhotoUrl ==
                                                    "https://images.media-allrecipes.com/images/82579.png" ||
                                                widget.favRecipesList[i]
                                                        .coverPhotoUrl ==
                                                    "https://images.media-allrecipes.com/images/79591.png")
                                            ? Container(
                                                height: 210,
                                                child: Image.asset(
                                                  'assets/logo/banner.png',
                                                  // fit: BoxFit.scaleDown,
                                                  // width: 100,
                                                  scale: 3,
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
                                                widget.favRecipesList[i]
                                                    .coverPhotoUrl,
                                                height: 210,
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 15.0,
                                              ),
                                              child: Text(
                                                widget.favRecipesList[i].title,
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
                                      widget.favRecipesList[i].desc,
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

                      // Container(
                      //   height: 100,
                      //   width: 400,
                      //   child: GridTile(
                      //     header: Text(recentRecipesList[i].title),
                      //     child:
                      //         Image.network(recentRecipesList[i].coverPhotoUrl),
                      //     footer: Text(
                      //       recentRecipesList[i].desc ?? "",
                      //     ),
                      //     //  Text(
                      //     //   recentRecipesList[i]
                      //     //           .timestamp
                      //     //           .toDate()
                      //     //           .difference(DateTime.now())
                      //     //           .inMinutes
                      //     //           .toString() ??
                      //     //       "",
                      //     // ),
                      //   ),
                      // ),
                    ),
                  ],
                ),
                if (widget.favRecipesList[0].title.trim() == "")
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
      ),
    );
  }
}
