import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipetap/provider/auth_provider.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isAuth;
  bool authSkipped;
  String profilePhotoUrl;
  String username;
  String email;
  Function logout;

  var _isLoading = false;

  var isInit = false;

  @override
  void didChangeDependencies() async {
    if (!isInit) {
      setState(() {
        _isLoading = true;
      });

      final auth = Provider.of<AuthProvider>(context, listen: false);

      profilePhotoUrl = auth.profilePhotoUrl;
      username = auth.username;
      email = auth.email;
      isAuth = auth.isAuth;
      authSkipped = auth.authSkipped;
      logout = auth.logout;
      // if (authSkipped)
      // Provider.of<AuthProvider>(context, listen: false).tryGoogleSignIn();

      // setState(() {
      _isLoading = false;
      // });

      isInit = true;
    }
    super.didChangeDependencies();
  }

  //   @override
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

  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
    });
    // Provider.of<AuthProvider>(context, listen: false).tryGoogleSignIn();
    // TODO: Login not working
    await Provider.of<AuthProvider>(context, listen: false).login();
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _signOut() async {
    setState(() {
      _isLoading = true;
    });
    // Provider.of<AuthProvider>(context, listen: false).tryGoogleSignIn();
    // TODO: Login not working
    await Provider.of<AuthProvider>(context, listen: false).logout();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.settings),
        title: Text('Settings'),
      ),
      body: _isLoading
          ? CircularProgressIndicator()
          : Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  if (Provider.of<AuthProvider>(context, listen: false).isAuth)
                    Column(
                      children: <Widget>[
                        Container(
                          // color: Colors.red,
                          height: 160,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              CircleAvatar(
                                radius: 60,
                                backgroundImage: isAuth
                                    ? NetworkImage(
                                        profilePhotoUrl,
                                      )
                                    : null,
                                backgroundColor: Theme.of(context).primaryColor,
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              Column(
                                // mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    height: 25,
                                  ),
                                  Text(
                                    username ?? "User",
                                    style: TextStyle(
                                      fontSize: 25,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text('Google Account'),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  InkWell(
                                    child: Text(
                                      "Manage Account",
                                      style: TextStyle(
                                        color: Colors.blue,
                                      ),
                                    ),
                                    onTap: () async {
                                      _signOut();
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    )
                  else
                    Container(
                      height: 160,
                      // TODO: Google Sign In Request
                      child: Column(
                        children: <Widget>[
                          Text('Sign In With Google'),
                        ],
                      ),
                    ),
                  InkWell(
                    onTap: () async {
                      await _signIn();
                      setState(() {});
                    },
                    child: ListTile(
                      title: Text('Veg'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
