import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:reco/style/theme.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: appBarColor,
      child: Center(
        child: SpinKitFadingCube(
          color: primaryColor,
          size: 50.0,
        ),
      ),
    );
  }
}
