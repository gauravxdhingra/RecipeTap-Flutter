import 'dart:ui';

import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:recipetap/models/recents_model.dart';
import 'package:recipetap/pages/home_screen.dart';
import 'package:recipetap/pages/recipe_view_page.dart';
import 'package:recipetap/provider/recently_viewed_provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class BuildRecentsInFavourites extends StatefulWidget {
  const BuildRecentsInFavourites({
    Key key,
    @required this.recentRecipesList,
  }) : super(key: key);

  final List<RecentsModel> recentRecipesList;

  @override
  _BuildRecentsInFavouritesState createState() =>
      _BuildRecentsInFavouritesState();
}

class _BuildRecentsInFavouritesState extends State<BuildRecentsInFavourites> {
  @override
  Widget build(BuildContext context) {
    // final width = MediaQuery.of(context).size.width * 4 / 5;
    // const widthh = const width;
    return Container(
      // TODO: Changed from height / 3 + 50
      height: MediaQuery.of(context).size.height / 2.4,
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: widget.recentRecipesList.length,
        itemBuilder: (context, i) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            width: MediaQuery.of(context).size.width * 4 / 5,
            child: Stack(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 4 / 5 - 95,
                        bottom: 5,
                      ),
                      child: InkWell(
                        onTap: () async {
                          final recipeurl1 = widget
                              .recentRecipesList[i].recipeUrl
                              .split("/recipe/")[1];
                          final recipeurll = recipeurl1.split("/")[0] +
                              "-" +
                              recipeurl1.split("/")[1];
                          await recentsRef
                              .document(currentUser.email)
                              .collection('recents')
                              .document(recipeurll)
                              .delete();
                          widget.recentRecipesList.removeAt(i);
                          setState(() {});
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
                                    url: widget.recentRecipesList[i].recipeUrl,
                                    coverImageUrl: widget
                                        .recentRecipesList[i].coverPhotoUrl,
                                  ))),
                      child: ClayContainer(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        depth: 50,
                        borderRadius: 20,
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
                                      child: Image.network(
                                        widget
                                            .recentRecipesList[i].coverPhotoUrl,
                                        height: 210,
                                        width:
                                            MediaQuery.of(context).size.width,
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
                                              widget.recentRecipesList[i].title,
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
                                    widget.recentRecipesList[i].desc,
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
                    Padding(
                      padding: const EdgeInsets.only(left: 10, top: 5),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).primaryColor.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Text(widget.recentRecipesList[i].timestamp !=
                                null
                            ? timeago.format(
                                widget.recentRecipesList[i].timestamp.toDate())
                            : "                 "),
                      ),
                    ),
                  ],
                ),
                if (widget.recentRecipesList[0].title.trim() == "")
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                    child: Container(
                      height: 80,
                      width: MediaQuery.of(context).size.width,
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
