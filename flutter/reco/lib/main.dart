import 'package:flutter/material.dart';
import 'package:reco/screens/home.dart';

void main() {
  //10.0.2.2 -> localhost
  runApp(MaterialApp(
    title: 'Reco',
    home: Home(title: "Reco"),
    debugShowCheckedModeBanner: false,
    initialRoute: "/",
  ));
}
