import 'dart:ui';

import 'package:clay_containers/clay_containers.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../models/category_model.dart';
import '../models/favourites_model.dart';
import '../models/recents_model.dart';
import '../provider/recently_viewed_provider.dart';
import '../widgets/fav_screen_widgets/build_fav_in_favourites.dart';
import '../widgets/fav_screen_widgets/build_recents_in_favourites.dart';
import '../widgets/loading_spinner.dart';
import 'categories_recipe_screen.dart';
import 'home_screen.dart';

class ParalaxConfig {
  final int level;
  final AssetImage image;

  const ParalaxConfig({
    this.level,
    this.image,
  });
}

class FavouritesScreen extends StatefulWidget {
  FavouritesScreen({Key key}) : super(key: key);

  @override
  _FavouritesScreenState createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen>
    with SingleTickerProviderStateMixin {
  bool isAuth = false;
  bool authSkipped;
  String email;
  List<RecentsModel> recentRecipesList = [];
  List<FavouritesModel> favRecipesList = [];
  List<CategoryModel> favCategoriesList = [];

  var _isLoading = false;
  var isInit = false;

  @override
  void initState() {
    _spoonController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    if (!isInit) {
      setState(() {
        _isLoading = true;
      });

      // final auth = Provider.of<AuthProvider>(context, listen: false);

      if (currentUser != null) {
        email = currentUser.email;
        final recenttag = Provider.of<RecentsProvider>(context, listen: false);

//
//
//

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

      isAuth = currentUser != null;
      // authSkipped = auth.authSkipped;
      // setState(() {
      _isLoading = false;
      // });
      isInit = true;
    }
    super.didChangeDependencies();
  }

  static const _assets = <ParalaxConfig>[
    ParalaxConfig(
      image: AssetImage("assets/ice_cream_indicator/cup2.png"),
      level: 0,
    ),
    ParalaxConfig(
      image: AssetImage("assets/ice_cream_indicator/spoon.png"),
      level: 1,
    ),
    ParalaxConfig(
      image: AssetImage("assets/ice_cream_indicator/ice1.png"),
      level: 3,
    ),
    ParalaxConfig(
      image: AssetImage("assets/ice_cream_indicator/ice3.png"),
      level: 4,
    ),
    ParalaxConfig(
      image: AssetImage("assets/ice_cream_indicator/ice2.png"),
      level: 2,
    ),
    ParalaxConfig(
      image: AssetImage("assets/ice_cream_indicator/cup.png"),
      level: 0,
    ),
    ParalaxConfig(
      image: AssetImage("assets/ice_cream_indicator/mint.png"),
      level: 5,
    ),
  ];

  static const _indicatorSize = 150.0;
  static const _imageSize = 140.0;

  IndicatorState _prevState;
  AnimationController _spoonController;
  static final _spoonTween = CurveTween(curve: Curves.easeInOut);

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

  Widget _buildImage(IndicatorController controller, ParalaxConfig asset) {
    return Transform.translate(
      offset: Offset(
        0,
        -(asset.level * (controller.value.clamp(1.0, 1.5) - 1.0) * 20) + 10,
      ),
      child: OverflowBox(
        maxHeight: _imageSize,
        minHeight: _imageSize,
        child: Image(
          image: asset.image,
          fit: BoxFit.contain,
          height: _imageSize,
        ),
      ),
    );
  }

  mealsFromCategory(categoryUrl, context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CategoryRecipesScreen(url: categoryUrl)));
  }

  var closedContainerHeight = 10;
  var openContainerHeight = 200;
  BorderRadius openContainerBR = BorderRadius.only(
    bottomLeft: Radius.circular(40),
    bottomRight: Radius.circular(40),
  );
  BorderRadius closedContainerBR = BorderRadius.only(
    bottomLeft: Radius.circular(40),
    bottomRight: Radius.circular(40),
  );
  BoxShadow openContainerBS =
      // BoxShadow(color: Colors.black45),
      BoxShadow(
    blurRadius: 0.6,
    spreadRadius: 0.6,
    color: Colors.black45,
    offset: Offset(0.1, 2.1),
  );

  BoxShadow closedContainerBS = BoxShadow(
    blurRadius: 0.3,
    spreadRadius: 0.3,
    color: Colors.black45,
    offset: Offset(0.1, 2),
  );

  Duration duration = Duration(milliseconds: 200);

  @override
  void dispose() {
    _spoonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favourites"),
        elevation: 0,
        centerTitle: true,
        leading: null,
        bottom: PreferredSize(
          child: Container(
            height: 120 -
                MediaQuery.of(context).padding.top -
                AppBar().preferredSize.height,
            child: Stack(
              children: [
                Container(
                  height: 120 -
                      MediaQuery.of(context).padding.top -
                      AppBar().preferredSize.height,
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                Container(
                  height: 120 -
                      MediaQuery.of(context).padding.top -
                      AppBar().preferredSize.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: closedContainerBR,
                    boxShadow: [
                      closedContainerBS,
                    ],
                  ),
                  child: currentUser != null
                      ? Center(
                          child: Text(
                            "Pull To Refresh",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : Center(
                          child: Text(
                          "Log In To See Favourites",
                          style: TextStyle(color: Colors.white),
                        )),
                ),
              ],
            ),
          ),
          preferredSize: Size.fromHeight(120 -
              MediaQuery.of(context).padding.top -
              AppBar().preferredSize.height),
        ),
      ),
      body: _isLoading
          ? Center(
              child: LoadingSpinner(
                size: 100,
                color: Colors.grey,
              ),
            )
          : currentUser != null
              ? CustomRefreshIndicator(
                  offsetToArmed: _indicatorSize,
                  builder: (
                    BuildContext context,
                    Widget child,
                    IndicatorController controller,
                  ) {
                    return Stack(
                      children: <Widget>[
                        AnimatedBuilder(
                          animation: controller,
                          builder: (BuildContext context, Widget _) {
                            final currentState = controller.state;
                            if (_prevState == IndicatorState.armed &&
                                currentState == IndicatorState.loading) {
                              _spoonController.repeat(reverse: true);
                            } else if (_prevState == IndicatorState.loading &&
                                _prevState != currentState) {
                              _spoonController.stop();
                            } else if (currentState == IndicatorState.idle &&
                                _prevState != currentState) {
                              _spoonController..value = 0.0;
                            }

                            _prevState = currentState;
                            return SizedBox(
                              height: controller.value * _indicatorSize,
                              child: Stack(
                                children: <Widget>[
                                  for (int i = 0; i < _assets.length; i++)

                                    /// check if it is a spoon build animated builed and attach spoon controller
                                    if (i == 1)
                                      AnimatedBuilder(
                                        animation: _spoonController,
                                        child:
                                            _buildImage(controller, _assets[i]),
                                        builder: (context, child) {
                                          return Transform.rotate(
                                            angle: (-_spoonTween.transform(
                                                    _spoonController.value)) *
                                                1.25,
                                            child: child,
                                          );
                                        },
                                      )
                                    else
                                      _buildImage(controller, _assets[i])
                                ],
                              ),
                            );
                          },
                        ),
                        // child,
                        AnimatedBuilder(
                          builder: (context, _) {
                            return Transform.translate(
                              offset: Offset(
                                  0.0, controller.value * _indicatorSize),
                              child: child,
                            );
                          },
                          animation: controller,
                        ),
                      ],
                    );
                  },
                  onRefresh: () async {
                    final recenttag =
                        Provider.of<RecentsProvider>(context, listen: false);

                    await recenttag.fetchRecentRecipes(email);

                    recentRecipesList = recenttag.recentRecipes;

                    await recenttag.fetchFavoriteRecipes(email);

                    favRecipesList = recenttag.favRecipes;

                    await recenttag.fetchFavoriteCategories(email);

                    favCategoriesList = recenttag.getFavouriteCategoriesList;

                    setState(() {});
                  },
                  child: SingleChildScrollView(
                    // physics: BouncingScrollPhysics(),
                    child: Container(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              'FAVOURITE CATEGORIES',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1
                                  .copyWith(fontSize: 20),
                            ),
                          ),
                          if (favCategoriesList.length != 0)
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 80,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                physics: BouncingScrollPhysics(),
                                itemBuilder: (context, i) {
                                  return InkWell(
                                    onTap: () => mealsFromCategory(
                                      favCategoriesList[i].categoryUrl,
                                      context,
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 13),
                                      child: ClayContainer(
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        borderRadius: 25,
                                        depth: 60,
                                        spread: 5,
                                        child: Container(
                                          height: 70,
                                          width: 150,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            color:
                                                Theme.of(context).accentColor,
                                          ),
                                          child: Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                "#" +
                                                    favCategoriesList[i].title,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    .copyWith(
                                                      color: Colors.white,
                                                    ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                itemCount: favCategoriesList.length,
                              ),
                            ),
                          if (favCategoriesList.length == 0)
                            Stack(
                              children: <Widget>[
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 80,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    physics: BouncingScrollPhysics(),
                                    itemBuilder: (context, i) {
                                      return Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 13),
                                        child: Stack(
                                          children: <Widget>[
                                            ClayContainer(
                                              color: Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                              borderRadius: 25,
                                              depth: 60,
                                              spread: 5,
                                              child: Container(
                                                height: 70,
                                                width: 150,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  color: Theme.of(context)
                                                      .accentColor,
                                                ),
                                                child: Center(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      "         ",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText1
                                                          .copyWith(
                                                            color: Colors.white,
                                                          ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 2,
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            BackdropFilter(
                                              filter: ImageFilter.blur(
                                                  sigmaX: 4.0, sigmaY: 4.0),
                                              child: Container(
                                                child: Text(" "),
                                                decoration: BoxDecoration(
                                                    color: Colors.white
                                                        .withOpacity(0.0)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    itemCount: 3,
                                  ),
                                ),
                                Container(
                                  height: 80,
                                  width: MediaQuery.of(context).size.width,
                                  color: Theme.of(context)
                                      .scaffoldBackgroundColor
                                      .withOpacity(0.82),
                                  child: Center(
                                    child: Text(
                                      "Start Adding Categories To Favourites",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 20,
                              top: 30,
                            ),
                            child: Text(
                              'RECENTS',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1
                                  .copyWith(fontSize: 20),
                            ),
                          ),
                          if (recentRecipesList.length != 0)
                            BuildRecentsInFavourites(
                                recentRecipesList: recentRecipesList),
                          if (recentRecipesList.length == 0)
                            Stack(
                              children: <Widget>[
                                BuildRecentsInFavourites(
                                  recentRecipesList: [
                                    RecentsModel(
                                      title: "",
                                      desc: "",
                                      coverPhotoUrl: "",
                                      recipeUrl: "",
                                      timestamp: null,
                                    ),
                                    RecentsModel(
                                      title: "",
                                      desc: "",
                                      coverPhotoUrl: "",
                                      recipeUrl: "",
                                      timestamp: null,
                                    ),
                                  ],
                                ),
                                BackdropFilter(
                                  filter: ImageFilter.blur(
                                      sigmaX: 4.0, sigmaY: 4.0),
                                  child: Container(
                                    // height: 80,
                                    // width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.0)),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height >=
                                          700
                                      ? MediaQuery.of(context).size.height / 2.5
                                      : MediaQuery.of(context).size.height /
                                          2.0,
                                  color: Theme.of(context)
                                      .scaffoldBackgroundColor
                                      .withOpacity(0.82),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(60.0),
                                      child: Text(
                                        "Your Recently Viewed Recipes Will Be Displayed Here",
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.grey,
                                            height: 1.6),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 20,
                                  top: 20,
                                ),
                                child: Text(
                                  'FAVOURITES',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline1
                                      .copyWith(fontSize: 20),
                                ),
                              ),
                            ],
                          ),
                          if (favRecipesList.length != 0)
                            BuildFavInFavourites(
                                favRecipesList: favRecipesList),
                          if (favRecipesList.length == 0)
                            Stack(
                              children: <Widget>[
                                BuildFavInFavourites(
                                  favRecipesList: [
                                    FavouritesModel(
                                      title: "",
                                      coverPhotoUrl: "",
                                      recipeUrl: "",
                                      desc: "",
                                    ),
                                    FavouritesModel(
                                      title: "",
                                      coverPhotoUrl: "",
                                      recipeUrl: "",
                                      desc: "",
                                    ),
                                  ],
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height >=
                                          700
                                      ? MediaQuery.of(context).size.height / 2.5
                                      : MediaQuery.of(context).size.height /
                                          2.0,
                                  color: Theme.of(context)
                                      .scaffoldBackgroundColor
                                      .withOpacity(0.82),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(80),
                                      child: Text(
                                        "Start Adding Recipes To Favourites",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 15,
                                            height: 1.6),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'FAVOURITE CATEGORIES',
                          style: Theme.of(context)
                              .textTheme
                              .headline1
                              .copyWith(fontSize: 20),
                        ),
                      ),
                      Stack(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 80,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (context, i) {
                                return Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 13),
                                  child: Stack(
                                    children: <Widget>[
                                      ClayContainer(
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        borderRadius: 25,
                                        depth: 60,
                                        spread: 5,
                                        child: Container(
                                          height: 70,
                                          width: 150,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            color:
                                                Theme.of(context).accentColor,
                                          ),
                                          child: Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                "         ",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    .copyWith(
                                                      color: Colors.white,
                                                    ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      BackdropFilter(
                                        filter: ImageFilter.blur(
                                            sigmaX: 4.0, sigmaY: 4.0),
                                        child: Container(
                                          child: Text(" "),
                                          decoration: BoxDecoration(
                                              color: Colors.white
                                                  .withOpacity(0.0)),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              itemCount: 3,
                            ),
                          ),
                          Container(
                            height: 80,
                            width: MediaQuery.of(context).size.width,
                            color: Theme.of(context)
                                .scaffoldBackgroundColor
                                .withOpacity(0.82),
                            child: Center(
                              child: Text(
                                "",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                          top: 30,
                        ),
                        child: Text(
                          'RECENTS',
                          style: Theme.of(context)
                              .textTheme
                              .headline1
                              .copyWith(fontSize: 20),
                        ),
                      ),
                      Stack(
                        children: <Widget>[
                          BuildRecentsInFavourites(
                            recentRecipesList: [
                              RecentsModel(
                                title: "",
                                desc: "",
                                coverPhotoUrl: "",
                                recipeUrl: "",
                                timestamp: null,
                              ),
                              RecentsModel(
                                title: "",
                                desc: "",
                                coverPhotoUrl: "",
                                recipeUrl: "",
                                timestamp: null,
                              ),
                            ],
                          ),
                          BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.0)),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height >= 700
                                ? MediaQuery.of(context).size.height / 2.5
                                : MediaQuery.of(context).size.height / 2.0,
                            color: Theme.of(context)
                                .scaffoldBackgroundColor
                                .withOpacity(0.82),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(60.0),
                                child: Text(
                                  "",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey,
                                      height: 1.6),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 20,
                              top: 20,
                            ),
                            child: Text(
                              'FAVOURITES',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1
                                  .copyWith(fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                      Stack(
                        children: <Widget>[
                          BuildFavInFavourites(
                            favRecipesList: [
                              FavouritesModel(
                                title: "",
                                coverPhotoUrl: "",
                                recipeUrl: "",
                                desc: "",
                              ),
                              FavouritesModel(
                                title: "",
                                coverPhotoUrl: "",
                                recipeUrl: "",
                                desc: "",
                              ),
                            ],
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height >= 700
                                ? MediaQuery.of(context).size.height / 2.5
                                : MediaQuery.of(context).size.height / 2.0,
                            color: Theme.of(context)
                                .scaffoldBackgroundColor
                                .withOpacity(0.82),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(80),
                                child: Text(
                                  "",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 15,
                                      height: 1.6),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
    );
  }
}
