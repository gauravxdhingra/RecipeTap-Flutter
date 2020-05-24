import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipetap/pages/recipe_view_page.dart';
import 'package:recipetap/provider/auth_provider.dart';
import 'package:recipetap/provider/recently_viewed_provider.dart';
import 'package:recipetap/models/recents_model.dart';
import 'package:recipetap/models/favourites_model.dart';
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
        final recenttag = Provider.of<RecentsProvider>(context, listen: false);

        await recenttag.fetchRecentRecipes(email);

        recentRecipesList = recenttag.recentRecipes;

        // "********"

        // final favtag = Provider.of<RecentsProvider>(context, listen: false);

        await recenttag.fetchFavoriteRecipes(email);

        favRecipesList = recenttag.favRecipes;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favourites"),
      ),
      body: _isLoading
          ? CircularProgressIndicator()
          : isAuth
              ? RefreshIndicator(
                  onRefresh: () async {
                    if (isAuth) {
                      await Provider.of<RecentsProvider>(context, listen: false)
                          .fetchRecentRecipes(email);

                      recentRecipesList =
                          Provider.of<RecentsProvider>(context, listen: false)
                              .recentRecipes;

                      await Provider.of<RecentsProvider>(context, listen: false)
                          .fetchFavoriteRecipes(email);

                      favRecipesList =
                          Provider.of<RecentsProvider>(context, listen: false)
                              .favRecipes;
                    }
                  },
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      // TODO : Timeago
                      // TODO Add Shadow to Categories Pinned Appbars

                      children: <Widget>[
                        Text('RECENTS'),
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
                        BuildFavInFavourites(favRecipesList: favRecipesList),
                      ],
                    ),
                  ),
                )
              : Text("login to see fav and recents"),
    );
  }
}
