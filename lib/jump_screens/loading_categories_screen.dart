import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:recipetap/widgets/loading_spinner.dart';

class LoadingCategoriesScreen extends StatelessWidget {
  const LoadingCategoriesScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // SvgPicture.asset(
            //   'assets/svg/bestManWorking.svg',
            //   fit: BoxFit.cover,
            //   height: MediaQuery.of(context).size.width * 1.4,
            // ),
            SizedBox(
              height: 50,
            ),
            Text('Loading Categories'),
            SizedBox(
              height: 50,
            ),
            LoadingSpinner(
              size: 140,
            ),
          ],
        ),
      ),
    );
  }
}
