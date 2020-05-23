import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen(
      {Key key,
      this.isAuth,
      this.profilePhotoUrl,
      this.username,
      this.email,
      this.authSkipped})
      : super(key: key);
  final bool isAuth;
  final bool authSkipped;
  final String profilePhotoUrl;
  final String username;
  final String email;
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.settings),
        title: Text('Settings'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            widget.isAuth
                ? Column(
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
                              backgroundImage: NetworkImage(
                                widget.profilePhotoUrl,
                              ),
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
                                  widget.username ?? "User",
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
                                  onTap: () {},
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  )
                : Container(
                    height: 160,
                    // TODO: Google Sign In Request
                    child: Column(
                      children: <Widget>[
                        Text('Sign In With Google'),
                      ],
                    ),
                  ),
            ListTile(
              title: Text('Veg'),
            ),
          ],
        ),
      ),
    );
  }
}
