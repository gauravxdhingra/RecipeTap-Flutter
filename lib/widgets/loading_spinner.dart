import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingSpinner extends StatelessWidget {
  const LoadingSpinner({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpinKitRipple(
      size: 70,
      color: Colors.white,
    );
  }
}
