import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoadingIngredientsSearchScreen extends StatelessWidget {
  const LoadingIngredientsSearchScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          // SvgPicture.asset(assetName)
          Text('Getting The Best Recipes For You From Your Ingredients'),
          Text('We Thank You To Help Us Save Food :-)'),
        ],
      ),
    );
  }
}
