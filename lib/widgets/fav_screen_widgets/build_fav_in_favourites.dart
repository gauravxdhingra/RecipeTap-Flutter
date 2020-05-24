import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:recipetap/models/favourites_model.dart';
import 'package:recipetap/pages/recipe_view_page.dart';

class BuildFavInFavourites extends StatelessWidget {
  const BuildFavInFavourites({
    Key key,
    @required this.favRecipesList,
  }) : super(key: key);

  final List<FavouritesModel> favRecipesList;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: favRecipesList.length,
        itemBuilder: (context, i) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            width: MediaQuery.of(context).size.width * 4 / 5,
            child: GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RecipeViewPage(
                            url: favRecipesList[i].recipeUrl,
                            coverImageUrl: favRecipesList[i].coverPhotoUrl,
                          ))),
              child: ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
                child: ClayContainer(
                  borderRadius: 20,
                  depth: 90,
                  spread: 6,
                  // depth: 90,
                  // color: Theme.of(context).primaryColor,
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
                                  favRecipesList[i].coverPhotoUrl,
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
                                        favRecipesList[i].title,
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
                              favRecipesList[i].desc,
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
          );
        },
      ),
    );
  }
}
