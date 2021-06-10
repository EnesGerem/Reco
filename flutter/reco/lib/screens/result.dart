import 'dart:io';

import 'package:flutter/material.dart';
import 'package:reco/style/theme.dart';
import 'package:reco/shared/loading.dart';

class Result extends StatefulWidget {
  Result({Key key, this.title, this.image, this.result}) : super(key: key);

  final String title;
  final File image;
  final String result;

  @override
  _ResultState createState() => _ResultState();
}

class _ResultState extends State<Result> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final _image = this.widget.image;

    return _loading
        ? Loading()
        : Scaffold(
            backgroundColor: backgroundColor,
            appBar: AppBar(
              backgroundColor: appBarColor,
              elevation: 0,
              titleSpacing: 0,
              leadingWidth: size.width * 0.23,
              title: Text(
                widget.title,
                style: TextStyle(
                    color: primaryColor,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w700,
                    fontSize: 25),
              ),
              leading: TextButton.icon(
                onPressed: () {
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                },
                icon: Icon(
                  Icons.arrow_back_ios_outlined,
                  color: primaryColor,
                ),
                label: Text("Home",
                    style:
                        TextStyle(color: primaryColor, fontFamily: "Poppins")),
              ),
              centerTitle: true,
            ),
            body: Center(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _image != null
                        ? Center(
                            child: Image.file(
                            _image,
                            scale: 3,
                          ))
                        : Text("No image selected..."),
                    SizedBox(
                      height: 80,
                    ),
                    Text(this.widget.result,
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 25,
                            color: primaryColor,
                            fontWeight: FontWeight.w600))
                  ],
                ),
              ),
            ));
  }
}
