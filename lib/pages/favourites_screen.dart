import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipetap/provider/auth_provider.dart';
import 'package:recipetap/provider/recently_viewed_provider.dart';
import 'package:recipetap/models/recents_model.dart';

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
              Container(
                height: 300,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: recentRecipesList.length,
                  itemBuilder: (context, i) {
                    return Container(
                      height: 100,
                      width: 400,
                      child: GridTile(
                        header: Text(recentRecipesList[i].title),
                        child:
                            Image.network(recentRecipesList[i].coverPhotoUrl),
                        footer: Text(
                          recentRecipesList[i].desc ?? "",
                        ),
                        //  Text(
                        //   recentRecipesList[i]
                        //           .timestamp
                        //           .toDate()
                        //           .difference(DateTime.now())
                        //           .inMinutes
                        //           .toString() ??
                        //       "",
                        // ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ));
  }
}
