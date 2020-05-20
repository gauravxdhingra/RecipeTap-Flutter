import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:recipetap/widgets/loading_spinner.dart';

class LoadingRecipeScreen extends StatelessWidget {
  const LoadingRecipeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Theme.of(context).primaryColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // SvgPicture.asset(
            //   'assets/svg/bestManWorking.svg',
            //   fit: BoxFit.cover,
            //   height: MediaQuery.of(context).size.width * 1.4,
            // ),
            Container(
              height: MediaQuery.of(context).size.height * 0.7,
              // height: 800,
              child: FlareActor(
                'assets/flare/chefloading.flr',
                animation: 'Untitled Duplicate',
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),
            // SizedBox(
            //   height: 50,
            // ),
            Text('Your Recipe Is Almost Ready'),
            Text('Great Things Take Time'),
            SizedBox(
              height: 30,
            ),
            LoadingSpinner(),
          ],
        ),
      ),
    );
  }
}