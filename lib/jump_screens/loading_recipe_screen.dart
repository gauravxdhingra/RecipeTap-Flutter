import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoadingRecipeScreen extends StatelessWidget {
  const LoadingRecipeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SvgPicture.asset(
            'assets/svg/bestManWorking.svg',
            fit: BoxFit.cover,
            height: MediaQuery.of(context).size.width * 1.4,
          ),
          SizedBox(
            height: 50,
          ),
          Text('Your Recipe Is Almost Ready'),
          Text('Great Things Take Time'),
          SizedBox(
            height: 50,
          ),
          CircularProgressIndicator(),
        ],
      ),
    );
  }
}
