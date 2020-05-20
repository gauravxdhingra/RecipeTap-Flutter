import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoadingNormalSearchScreen extends StatelessWidget {
  const LoadingNormalSearchScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          // SvgPicture.asset(assetName)
          Text('Getting The Best Recipes For You!'),
          
          // Text('Great Things Take Time'),
        ],
      ),
    );
  }
}
