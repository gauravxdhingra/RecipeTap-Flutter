import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipetap/pages/recipe_view_page.dart';
import 'package:recipetap/provider/auth_provider.dart';
import 'package:recipetap/provider/recently_viewed_provider.dart';
import 'package:recipetap/models/recents_model.dart';
import 'package:recipetap/widgets/fav_screen_widgets/build_recents_in_favourites.dart';

class FavouritesScreen extends StatefulWidget {
  FavouritesScreen({Key key}) : super(key: key);

  @override
  _FavouritesScreenState createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  bool isAuth;
  bool authSkipped;
  String email;
  List<RecentsModel> recentRecipesList = [];

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

      await Provider.of<RecentsProvider>(context, listen: false)
          .fetchRecentRecipes(email);

      recentRecipesList =
          Provider.of<RecentsProvider>(context, listen: false).recentRecipes;

      isAuth = auth.isAuth;
      authSkipped = auth.authSkipped;

      _isLoading = false;

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
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Text('RECENTS'),
              BuildRecentsInFavourites(recentRecipesList: recentRecipesList),
              Row(
                children: <Widget>[
                  Text('Favourites'),
                  FlatButton(
                    child: Text('View All'),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
