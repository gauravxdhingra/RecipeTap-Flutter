import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
import 'package:recipetap/pages/home_screen.dart';
// import '../provider/auth_provider.dart';
import 'package:flutter_brand_icons/flutter_brand_icons.dart';
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
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              "assets/onboarding/ingredients.jpg",
            ),
            fit: BoxFit.cover,
          ),
        ),
        // color: Colors.red,
        child: Stack(
          children: <Widget>[
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
              child: Container(
                child: Text(" "),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.0)),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 10, top: 30),
                child: FlatButton(
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
                padding: EdgeInsets.only(top: 100),
                child: Image.asset(
                  "assets/logo/banner.png",
                  fit: BoxFit.cover,
                  scale: 2.2,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 70,
                  decoration: BoxDecoration(
                      color: Colors.white54,
                      borderRadius: BorderRadius.circular(15)),
                  child: FlatButton(
                    onPressed: _submit,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(BrandIcons.google),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          'Sign In With Google',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
