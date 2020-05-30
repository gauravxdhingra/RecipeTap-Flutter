import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
import 'package:recipetap/pages/home_screen.dart';
// import '../provider/auth_provider.dart';
import 'package:flutter_brand_icons/flutter_brand_icons.dart';
import 'package:clay_containers/clay_containers.dart';
import 'dart:ui';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // var _isLoading = false;

  var isInit = false;

  // @override
  // void didChangeDependencies() async {
  //   if (!isInit) {
  //     setState(() {
  //       _isLoading = true;
  //     });

  //     await Provider.of<AuthProvider>(context, listen: false).tryGoogleSignIn();

  //     _isLoading = false;

  //     isInit = true;
  //   }
  //   super.didChangeDependencies();
  // }

  Future<void> _submit() async {
    // setState(() {
    //   _isLoading = true;
    // });
    await googleSignIn.signIn();

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomeScreen()));
    // await Provider.of<AuthProvider>(context, listen: false).login();
  }

  _skipSignIn() {
    setState(() {
      authSkipped = true;
    });
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomeScreen()));
    // Provider.of<AuthProvider>(context, listen: false).skipAuth();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          // image: DecorationImage(
          //   image: AssetImage(
          //     "assets/onboarding/ingredients.jpg",
          //   ),
          //   fit: BoxFit.cover,
          // ),
          ),
      // color: Colors.red,
      child: Stack(
        children: <Widget>[
          // BackdropFilter(
          //   filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
          //   child: Container(
          //     child: Text(" "),
          //     decoration: BoxDecoration(color: Colors.white.withOpacity(0.0)),
          //   ),
          // ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 10, top: 30),
              child: FlatButton(
                color: Colors.white.withOpacity(0.16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                onPressed: () => _skipSignIn(),
                child: Text(
                  'Skip For Now',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              padding: EdgeInsets.only(top: 80, left: 40, right: 40),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image.asset(
                  "assets/onboarding/favourites.jpg",
                  fit: BoxFit.cover,
                  scale: 2.2,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.lerp(
              Alignment.center,
              Alignment.bottomCenter,
              0.4,
            ),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 0),
              child: ClayContainer(
                color: Colors.redAccent[700],
                borderRadius: 15,
                depth: 90,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 70,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(15)),
                  child: FlatButton(
                    onPressed: _submit,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          BrandIcons.google,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          'Sign In With Google',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: "Login With Google ",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                    fontStyle: FontStyle.italic,
                  ),
                  children: [
                    TextSpan(
                      text: "To Save Your ",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 28,
                        fontWeight: FontWeight.w300,
                        fontStyle: FontStyle.normal,
                        letterSpacing: 1.2,
                      ),
                    ),
                    TextSpan(
                      text: "Preferences",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
