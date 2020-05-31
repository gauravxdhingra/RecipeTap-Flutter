import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:recipetap/pages/splash_screen.dart';

import './provider/recently_viewed_provider.dart';
import 'jump_screens/aww_snap_screen.dart';
import 'onboarding_screens/Welcome.dart';
import 'pages/home_screen.dart';
import 'pages/recipe_view_page.dart';
import 'utility/shared_prefs.dart';

// PushNotificationsManager pushNotificationsManager = PushNotificationsManager();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  alreadyVisited = await getVisitingFlag();
  // alreadyVisited = false;
  print(alreadyVisited);
  // await pushNotificationsManager.init();
  runApp(MyApp());
}

bool alreadyVisited = false;

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    // bool alreadyVisited = await getVisitingFlag();
    return MultiProvider(
      providers: [
        // ChangeNotifierProvider.value(
        //   value: AuthProvider(),
        // ),
        // ChangeNotifierProvider.value(
        //   value: FavoritesProvider(),
        // ),
        ChangeNotifierProvider.value(
          value: RecentsProvider(),
        ),
      ],
      child:
          //  Consumer<AuthProvider>(
          //   builder: (ctx, auth, _) =>
          MaterialApp(
        title: 'RecipeTap',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          // primaryColor: Colors.white,
          // primaryColor: Color(0xffEC008C),
          primaryColor:
              //  Color(0xfff54291),
              //  Colors.deepPurple[900],
              Color(0xffF01E91),

          accentColor: Color(0xff010a43),

          // Colors.blueGrey[900],
          textTheme: ltexttheme,
          appBarTheme: AppBarTheme(
              textTheme: ltexttheme.copyWith(
            title: TextStyle(
              fontSize: 25,
              color: Colors.white,
              fontWeight: FontWeight.w300,
              fontFamily: 'OpenSans',
            ),
          )),
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: <TargetPlatform, PageTransitionsBuilder>{
              TargetPlatform.android: FadeThroughPageTransitionsBuilder(),
              // ZoomPageTransitionsBuilder(),
            },
          ),
        ),
        darkTheme: ThemeData.dark().copyWith(
          accentColor: Colors.pink[900],
          textTheme: dtexttheme,
          appBarTheme: AppBarTheme(
            textTheme: dtexttheme.copyWith(
              title: TextStyle(
                fontSize: 25,
                color: Colors.white,
                fontWeight: FontWeight.w300,
                fontFamily: 'OpenSans',
              ),
            ),
          ),
        ),

        routes: {
          '/': (context) => !alreadyVisited ? Welcome() : SplashScreen(),
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
      // ),
    );
  }
}

final TextTheme ltexttheme = TextTheme(
  bodyText1: TextStyle(
    fontFamily: 'OpenSans',
    // fontSize: 20,
    color: Colors.white,
  ),
  bodyText2: TextStyle(
    fontFamily: 'OpenSans',
    // fontSize: 20,
    color: Colors.black,
  ),
  headline1: TextStyle(
    fontFamily: 'OpenSans',
    fontSize: 30,
  ),
  headline3: TextStyle(
    fontFamily: 'OpenSans',
    fontSize: 20,
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
);

final TextTheme dtexttheme = TextTheme(
  bodyText1: TextStyle(
    fontFamily: 'OpenSans',
    // fontSize: 20,
    color: Colors.black,
  ),
  bodyText2: TextStyle(
    fontFamily: 'OpenSans',
    // fontSize: 20,
    color: Colors.white,
  ),
  headline1: TextStyle(
    fontFamily: 'OpenSans',
    fontSize: 30,
  ),
  headline3: TextStyle(
    fontFamily: 'OpenSans',
    fontSize: 20,
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
);
