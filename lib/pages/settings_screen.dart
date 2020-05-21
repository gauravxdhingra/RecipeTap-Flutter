import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key key}) : super(key: key);

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
        child: Column(
          children: <Widget>[
            Container(
              height: 180,
              color: Colors.orange,
              child: Column(
                children: <Widget>[
                  Container(
                    height: 150,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.red,
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('User'),
                              SizedBox(
                                height: 20,
                              ),
                              Text('Google Account'),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Align(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text('Manage Account'),
                    ),
                    alignment: Alignment.topRight,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
