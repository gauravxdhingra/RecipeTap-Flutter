import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoadingRecipeScreen extends StatelessWidget {
  const LoadingRecipeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          // SvgPicture.asset(assetName)
          Text('Getting Your Recipe Ready'),
          Text('Great Things Take Time'),
        ],
      ),
    );
  }
}
