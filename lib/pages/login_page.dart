import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
              onPressed: login,
              child: Text(
                'Sign In With Google',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            FlatButton(
              onPressed: () {
                setState(() {
                  authSkipped = true;
                });
              },
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
