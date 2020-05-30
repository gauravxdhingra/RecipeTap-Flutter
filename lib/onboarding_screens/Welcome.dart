import 'package:flutter/material.dart';
import 'package:concentric_transition/concentric_transition.dart';
import 'package:recipetap/onboarding_screens/save_as_pdf_4.dart';
import 'package:recipetap/onboarding_screens/search_onboarding_1.dart';
import 'package:recipetap/onboarding_screens/timeoftheday_5.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'category_onboarding_2.dart';
import 'directions_onboarding_3.dart';

class Welcome extends StatefulWidget {
  Welcome({Key key}) : super(key: key);

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ConcentricPageView(
        colors: <Color>[
          Colors.black,
          Colors.redAccent[700],
          Colors.white,

          Color(0xffff2e63),
          Color(0xff010a43),
          // Color(0xffffd0cc),
          // Color(0xff120136),
        ],
        itemCount: 5, // null = infinity
        // physics: NeverScrollableScrollPhysics(),

        duration: Duration(milliseconds: 1500),
        physics: BouncingScrollPhysics(),
        itemBuilder: (int index, double value) {
          return pageCard(index);
        },
      ),
    );
  }
}

pageCard(int index) {
  if (index == 0) return SearchOnboarding1();
  if (index == 1) return CategoryOnboarding2();
  if (index == 2) return DirectionsOnboarding3();
  if (index == 3) return SaveAsPdfOnboarding4();
  if (index == 4) return TimeOfTheDayOnboarding5();
}
