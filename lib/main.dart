import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:recipetap/jump_screens/aww_snap_screen.dart';
import 'package:recipetap/pages/home_screen.dart';
import 'package:recipetap/pages/login_page.dart';
import 'package:recipetap/pages/search_screen.dart';
import 'package:recipetap/utility/route_generator.dart';
import 'package:recipetap/widgets/loading_spinner.dart';

import 'pages/recipe_view_page.dart';

import './provider/auth_provider.dart';
import './provider/favorites_provider.dart';
import './provider/recently_viewed_provider.dart';

void main() {
  runApp(MyApp());
}

// TODO: Handle Text Overflows Everywhere in the app

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: AuthProvider(),
        ),
        // ChangeNotifierProvider.value(
        //   value: FavoritesProvider(),
        // ),
        ChangeNotifierProvider.value(
          value: RecentsProvider(),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'RecipeTap',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            visualDensity: VisualDensity.adaptivePlatformDensity,
            // primaryColor: Colors.white,
            // primaryColor: Color(0xffEC008C),
            primaryColor: Color(0xffF01E91),
            accentColor: Colors.blueGrey[900],
            textTheme: TextTheme(
              headline1: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 30,
              ),
              headline3: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 20,
              ),
              bodyText2: TextStyle(
                fontFamily: 'OpenSans',
                // fontSize: 20,
                color: Colors.black,
              ),
              bodyText1: TextStyle(
                fontFamily: 'OpenSans',
                // fontSize: 20,
                // color: Colors.black,
              ),
              headline2: TextStyle(
                fontFamily: 'OpenSans',
              ),
              headline4: TextStyle(
                fontFamily: 'OpenSans',
              ),
              subtitle2: TextStyle(
                fontFamily: 'OpenSans',
              ),
              subtitle1: TextStyle(
                fontFamily: 'OpenSans',
              ),
              headline6: TextStyle(
                fontFamily: 'OpenSans',
              ),
              headline5: TextStyle(
                fontFamily: 'OpenSans',
              ),
              overline: TextStyle(
                fontFamily: 'OpenSans',
              ),
              caption: TextStyle(
                fontFamily: 'OpenSans',
              ),
              button: TextStyle(
                fontFamily: 'OpenSans',
              ),
            ),
          ),
          darkTheme: ThemeData.dark().copyWith(),

          routes: {
            '/':
                // (context) => LoginPage(),
                (context) => (auth.isAuth || auth.authSkipped)
                    ? HomeScreen()
                    : LoginPage(),
            HomeScreen.routeName: (context) => HomeScreen(),
            // SearchScreen.routeName: (context) => SearchScreen(),
            RecipeViewPage.routeName: (context) => RecipeViewPage(),
          },
          // onGenerateRoute: (settings) {
          //   return RouteGenerator.generateRoute(settings);
          // },
          onUnknownRoute: (_) =>
              MaterialPageRoute(builder: (_) => AwwSnapScreen()),
        ),
      ),
    );
  }
// TODO: Firebase Login
// TODO: Favourites on Firebase
// TODO: Recent Recipes on Firebase
// TODO: Favourite categories on Firebse
// TODO: Favoutite Category Options on Firebase
}
