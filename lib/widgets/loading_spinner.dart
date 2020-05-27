import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingSpinner extends StatelessWidget {
  final Color color;
  final double size;
  const LoadingSpinner({Key key, this.color, @required this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpinKitRipple(
      size: size,
      color: color == null
          ? Theme.of(context).brightness == Brightness.light
              ? Colors.white
              : Colors.grey
          : color,
    );
  }
}
