import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipetap/pages/home_screen.dart';
import '../provider/auth_provider.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _isLoading = false;

  var isInit = false;

  @override
  void didChangeDependencies() async {
    if (!isInit) {
      setState(() {
        _isLoading = true;
      });

      await Provider.of<AuthProvider>(context, listen: false).tryGoogleSignIn();

      _isLoading = false;

      isInit = true;
    }
    super.didChangeDependencies();
  }

  Future<void> _submit() async {
    setState(() {
      _isLoading = true;
    });

    await Provider.of<AuthProvider>(context, listen: false).login();
  }

  Future<void> _skipSignIn() async {
    setState(() {
      _isLoading = true;
    });

    // Provider.of<AuthProvider>(context, listen: false).skipAuth();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.red,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('SIGN IN'),
            FlatButton(
              onPressed: _submit,
              child: Text(
                'Sign In With Google',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            FlatButton(
              onPressed: _skipSignIn,
              child: Text(
                'Skip SignIn',
                style: TextStyle(
                  color: Colors.yellow,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
