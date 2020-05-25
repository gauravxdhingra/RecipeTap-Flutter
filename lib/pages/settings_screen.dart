import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipetap/pages/home_screen.dart';
// import 'package:recipetap/provider/auth_provider.dart';

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

      // final auth = Provider.of<AuthProvider>(context, listen: false);

      profilePhotoUrl = currentUser.photoUrl;
      username = currentUser.username;
      email = currentUser.email;
      isAuth = currentUser != null;
      // authSkipped = auth.authSkipped;
      // logout = auth.logout;
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
    // TODO: Implement SignIn
    // await Provider.of<AuthProvider>(context, listen: false).login();
    await googleSignIn.signIn();
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
    await googleSignIn.signOut();
    setState(() {
      _isLoading = false;
    });
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        // leading: Icon(Icons.settings),
        
        title: Text('Settings'),
        centerTitle: true,
        elevation: 0,
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
          ? CircularProgressIndicator()
          : Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  if (currentUser != null)
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
                      await _signIn().whenComplete(() => setState(() {}));
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
