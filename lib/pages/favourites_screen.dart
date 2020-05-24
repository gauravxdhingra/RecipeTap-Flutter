import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipetap/pages/categories_recipe_screen.dart';
import 'package:recipetap/pages/recipe_view_page.dart';
import 'package:recipetap/provider/auth_provider.dart';
import 'package:recipetap/provider/recently_viewed_provider.dart';
import 'package:recipetap/models/recents_model.dart';
import 'package:recipetap/models/favourites_model.dart';
import 'package:recipetap/models/category_model.dart';
import 'package:recipetap/widgets/fav_screen_widgets/build_recents_in_favourites.dart';
import 'package:recipetap/widgets/fav_screen_widgets/build_fav_in_favourites.dart';

class FavouritesScreen extends StatefulWidget {
  FavouritesScreen({Key key}) : super(key: key);

  @override
  _FavouritesScreenState createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  bool isAuth = false;
  bool authSkipped;
  String email;
  List<RecentsModel> recentRecipesList = [];
  List<FavouritesModel> favRecipesList = [];
  List<CategoryModel> favCategoriesList = [];

  var _isLoading = false;

  var isInit = false;

  @override
  void didChangeDependencies() async {
    if (!isInit) {
      setState(() {
        _isLoading = true;
      });

      final auth = Provider.of<AuthProvider>(context, listen: false);

      email = auth.email;

      if (auth.isAuth) {
        final recenttag = Provider.of<RecentsProvider>(context);

        await recenttag.fetchRecentRecipes(email);

        recentRecipesList = recenttag.recentRecipes;

        // "********"

        // final favtag = Provider.of<RecentsProvider>(context, listen: false);

        await recenttag.fetchFavoriteRecipes(email);

        favRecipesList = recenttag.favRecipes;

        //

        //
        await recenttag.fetchFavoriteCategories(email);

        favCategoriesList = recenttag.getFavouriteCategoriesList;
      }

      isAuth = auth.isAuth;
      authSkipped = auth.authSkipped;
      // setState(() {
      _isLoading = false;
      // });
      isInit = true;
    }
    super.didChangeDependencies();
  }

  // Future<void> refreshFav() async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   if (Provider.of<AuthProvider>(context, listen: false).isAuth) {
  //     final recenttag = Provider.of<RecentsProvider>(context, listen: false);

  //     await recenttag.fetchRecentRecipes(email);

  //     recentRecipesList = recenttag.recentRecipes;

  //     // "********"

  //     // final favtag = Provider.of<RecentsProvider>(context, listen: false);

  //     await recenttag.fetchFavoriteRecipes(email);

  //     favRecipesList = recenttag.favRecipes;
  //   }
  //   setState(() {
  //     _isLoading = false;
  //   });
  // }

  mealsFromCategory(categoryUrl, context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CategoryRecipesScreen(url: categoryUrl)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favourites"),
      ),
      body: _isLoading
          ? CircularProgressIndicator()
          : Provider.of<AuthProvider>(context, listen: false).isAuth
              ? SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    // TODO : Timeago
                    // TODO Add Shadow to Categories Pinned Appbars

                    children: <Widget>[
                      Text('FAVOURITE CATEGORIES'),
                      if (favCategoriesList.length != 0)
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, i) {
                              return InkWell(
                                onTap: () => mealsFromCategory(
                                  favCategoriesList[i].categoryUrl,
                                  context,
                                ),
                                child: Container(
                                  height: 50,
                                  width: 150,
                                  child: ListTile(
                                    title: Text(
                                      favCategoriesList[i].title,
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemCount: favCategoriesList.length,
                          ),
                        ),
                      Text('RECENTS'),
                      if (recentRecipesList.length != 0)
                        BuildRecentsInFavourites(
                            recentRecipesList: recentRecipesList),
                      Row(
                        children: <Widget>[
                          Text('Favourites'),
                          FlatButton(
                            child: Text('View All'),
                            onPressed: () {},
                          ),
                        ],
                      ),
                      if (favRecipesList.length != 0)
                        BuildFavInFavourites(favRecipesList: favRecipesList),
                    ],
                  ),
                )
              : Text("login to see fav and recents"),
    );
  }
}
