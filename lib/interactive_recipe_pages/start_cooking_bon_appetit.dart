import 'package:flutter/material.dart';
import 'package:share_extend/share_extend.dart';
import 'package:url_launcher/url_launcher.dart';

class StartCookingBonAppetit extends StatelessWidget {
  const StartCookingBonAppetit({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Ready!'),
        centerTitle: true,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context)),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/family.png'),
            Text(
              'Bon Appetit!',
              style: Theme.of(context).textTheme.headline1.copyWith(
                    fontWeight: FontWeight.w300,
                  ),
            ),
            Text(
              'Enjoy Your Food :-)',
              style: Theme.of(context).textTheme.headline1.copyWith(
                    fontWeight: FontWeight.w300,
                    fontSize: 20,
                  ),
            ),
            SizedBox(
              height: 70,
            ),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(20),
              ),
              height: 70,
              width: 250,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FlatButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Icon(
                        Icons.share,
                        color: Colors.white,
                      ),
                      Text(
                        'Share With Friends',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  onPressed: () {
                    ShareExtend.share(
                      "I found out this cool app on Google Play that lets you search recipes with the help of ingredients\nhttps://play.google.com/store/apps/details?id=com.gauravxdhingra.recipetap",
                      "text",
                      // " ",
                      sharePanelTitle: "Share RecipeTap",
                      // sharePositionOrigin: Rect.
                    );
                  },
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(20),
              ),
              height: 70,
              width: 250,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FlatButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Icon(
                        Icons.sentiment_very_satisfied,
                        color: Colors.white,
                      ),
                      Text(
                        'Rate The Experience',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  onPressed: () async {
                    const url =
                        "https://play.google.com/store/apps/details?id=com.gauravxdhingra.recipetap";
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
        },
        label: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Return'),
            Icon(Icons.navigate_next),
          ],
        ),
      ),
    );
  }
}
