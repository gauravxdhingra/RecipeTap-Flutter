import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_brand_icons/flutter_brand_icons.dart';
import 'package:provider/provider.dart';
import 'package:recipetap/pages/home_screen.dart';
import 'package:recipetap/widgets/loading_spinner.dart';
import 'package:share_extend/share_extend.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:recipetap/provider/auth_provider.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // bool isAuth;
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
      if (currentUser != null) {
        profilePhotoUrl = currentUser.photoUrl;
        username = currentUser.username;
        email = currentUser.email;
        // isAuth = currentUser != null;
      }
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
    // await Provider.of<AuthProvider>(context, listen: false).login();
    await googleSignIn.signIn();

    _isLoading = false;

    setState(() {});
  }

  Future<void> _signOut() async {
    setState(() {
      _isLoading = true;
    });
    // Provider.of<AuthProvider>(context, listen: false).tryGoogleSignIn();
    await googleSignIn.signOut();

    _isLoading = false;

    setState(() {});
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

  String pref = "all";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        // leading: Icon(Icons.settings),
        leading: null,
        title: Text('Preferences'),
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
                  child: Text(""),
                ),
              ],
            ),
          ),
          preferredSize: Size.fromHeight(
            120 -
                MediaQuery.of(context).padding.top -
                AppBar().preferredSize.height,
          ),
        ),
      ),
      body: _isLoading
          ? Center(child: LoadingSpinner(size: 100, color: Colors.grey))
          : Container(
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: <Widget>[
                        if (currentUser != null)
                          Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: ClayContainer(
                                  borderRadius: 25,
                                  depth: 60,
                                  // spread: 5,
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  child: Container(
                                    // color: Colors.red,
                                    // height: 160,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5.0, vertical: 5),
                                            child: ClayContainer(
                                              borderRadius: 40,
                                              depth: 60,
                                              spread: 6,
                                              color: Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                              // spread: 5,
                                              child: CircleAvatar(
                                                radius: 40,
                                                backgroundImage: currentUser !=
                                                        null
                                                    ? NetworkImage(
                                                        currentUser.photoUrl,
                                                      )
                                                    : null,
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .primaryColor,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Column(
                                            // mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              // SizedBox(
                                              //   height: 25,
                                              // ),
                                              Text(
                                                currentUser.username ?? "User",
                                                style: TextStyle(
                                                  fontSize: 24,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
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
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          30,
                                                        ),
                                                      ),
                                                      title: Text(
                                                          "Manage Account"),
                                                      elevation: 10,
                                                      content: Container(
                                                        height: 120,
                                                        child:
                                                            SingleChildScrollView(
                                                          child: Column(
                                                            children: <Widget>[
                                                              ListTile(
                                                                contentPadding:
                                                                    EdgeInsets
                                                                        .all(0),
                                                                title: Text(
                                                                    "Logout"),
                                                                onTap:
                                                                    () async {
                                                                  await _signOut()
                                                                      .then(
                                                                          (value) {
                                                                    currentUser =
                                                                        null;
                                                                    setState(
                                                                        () {
                                                                      currentUser =
                                                                          null;
                                                                    });
                                                                    Navigator.pop(
                                                                        context);
                                                                  });
                                                                },
                                                              ),
                                                              ListTile(
                                                                contentPadding:
                                                                    EdgeInsets
                                                                        .all(0),
                                                                title: Text(
                                                                    "Delete Account"),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      actions: <Widget>[
                                                        FlatButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text("Cancel"),
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                  // _signOut();
                                                },
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        else
                          InkWell(
                            onTap: () async {
                              await _signIn()
                                  .whenComplete(() => setState(() {}));
                            },
                            child: Column(
                              children: <Widget>[
                                Container(
                                  height: 100,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: ClayContainer(
                                      borderRadius: 25,
                                      depth: 60,
                                      // spread: 5,
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      child: Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Icon(
                                                  BrandIcons.google,
                                                  size: 35,
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Text(
                                                  "Sign In With Google",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText2
                                                      .copyWith(fontSize: 27),
                                                ),
                                              ],
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
                        SizedBox(
                          height: 20,
                        ),
                        ListTile(
                          title: Text("Search Preferences"),
                          subtitle: pref == "veg"
                              ? Text("Vegetarian Only")
                              : pref == "chicken"
                                  ? Text(
                                      "Non Vegetarian - Chicken, Mutton, Fish")
                                  : Text("All Vegetarian and Non Vegetarian"),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 8),
                                title: Text("Search Preferences"),
                                content: Container(
                                  height: 250,
                                  child: Column(
                                    children: <Widget>[
                                      ListTile(
                                        contentPadding: EdgeInsets.all(0),
                                        title: Text("Vegetarian"),
                                        subtitle: Text(
                                            "Include Only Pure Vegetarian"),
                                        leading: pref == "veg"
                                            ? Icon(
                                                Icons.chevron_right,
                                                color: Theme.of(context)
                                                            .brightness ==
                                                        Brightness.dark
                                                    ? Colors.white
                                                    : Colors.black,
                                              )
                                            : Icon(
                                                Icons.chevron_right,
                                                color: Theme.of(context)
                                                    .dialogBackgroundColor,
                                              ),
                                        onTap: () {
                                          setState(() {
                                            pref = "veg";
                                          });
                                          Navigator.pop(context);
                                        },
                                      ),
                                      ListTile(
                                        contentPadding: EdgeInsets.all(0),
                                        title: Text("Non-Vegetarian"),
                                        subtitle: Text(
                                            "Include Only Chicken, Eggs, Mutton and Fish"),
                                        leading: pref == "chicken"
                                            ? Icon(
                                                Icons.chevron_right,
                                                color: Theme.of(context)
                                                            .brightness ==
                                                        Brightness.dark
                                                    ? Colors.white
                                                    : Colors.black,
                                              )
                                            : Icon(
                                                Icons.chevron_right,
                                                color: Theme.of(context)
                                                    .dialogBackgroundColor,
                                              ),
                                        onTap: () {
                                          setState(() {
                                            pref = "chicken";
                                          });
                                          Navigator.pop(context);
                                        },
                                      ),
                                      SizedBox(height: 8),
                                      ListTile(
                                        contentPadding: EdgeInsets.all(0),
                                        title: Text("Show All"),
                                        subtitle: Text(
                                            "Include All Non Vegetarian Dishes"),
                                        leading: pref == "all"
                                            ? Icon(
                                                Icons.chevron_right,
                                                color: Theme.of(context)
                                                            .brightness ==
                                                        Brightness.dark
                                                    ? Colors.white
                                                    : Colors.black,
                                              )
                                            : Icon(
                                                Icons.chevron_right,
                                                color: Theme.of(context)
                                                    .dialogBackgroundColor,
                                              ),
                                        onTap: () {
                                          setState(() {
                                            pref = "all";
                                          });
                                          Navigator.pop(context);
                                        },
                                      )
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text("Cancel"),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        ListTile(
                          title: Text("Rate Us!"),
                          subtitle:
                              Text("Liked The Experience? Please Rate Us!"),
                          onTap: () async {
                            const url =
                                "https://play.google.com/store/apps/details?id=com.gauravxdhingra.recipetap";
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                        ),
                        ListTile(
                          title: Text("Share This App"),
                          onTap: () {
                            ShareExtend.share(
                              "I found out this cool app on Google Play that lets you search recipes with the help of ingredients\nhttps://play.google.com/store/apps/details?id=com.gauravxdhingra.recipetap",
                              "text",
                              // " ",
                              sharePanelTitle: "Share RecipeTap",
                              // sharePositionOrigin: Rect.
                            );
                          },
                        ),
                        ListTile(
                          title: Text("About"),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Container(
                                  height: 30,
                                  // width: MediaQuery.of(context).size.width / 2,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset(
                                        "assets/logo/icon.png",
                                        fit: BoxFit.cover,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text("RecipeTap"),
                                      SizedBox(
                                        width: 10,
                                      ),
                                    ],
                                  ),
                                ),
                                content: ListTile(
                                  leading: Icon(BrandIcons.github),
                                  title:
                                      Text("https://github.com/gauravxdhingra"),
                                  onTap: () async {
                                    const url =
                                        "https://gauravxdhingra.github.io/GauravDhingra/";
                                    if (await canLaunch(url)) {
                                      await launch(url);
                                      Navigator.pop(context);
                                    } else {
                                      throw 'Could not launch $url';
                                    }
                                  },
                                  subtitle: Text(
                                    "RecipeTap v1.0.0",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  // trailing: Text("GoTo"),
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40)),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  if (MediaQuery.of(context).size.height > 700)
                    Positioned(
                      bottom: 55,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Container(
                          // width: MediaQuery.of(context).size.width * 0.5,
                          padding: EdgeInsets.symmetric(horizontal: 100),
                          child: Image.asset(
                            "assets/logo/banner.png",
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : null,
                            fit: BoxFit.cover,
                            // colorBlendMode: BlendMode.hardLight,
                          ),
                        ),
                      ),
                    ),
                  if (MediaQuery.of(context).size.height > 700)
                    Positioned(
                      bottom: 20,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text("Made Using | "),
                                Text("Secured By"),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(BrandIcons.flutter),
                                SizedBox(
                                  width: 50,
                                ),
                                Icon(BrandIcons.firebase),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}
