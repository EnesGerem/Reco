import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reco/screens/result.dart';
import 'package:reco/style/theme.dart';
import 'package:reco/shared/loading.dart';
import 'package:dio/dio.dart';

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final url = "http://10.0.2.2:5000";

  Future<File> file;
  File tempFile;
  String error = "Error";
  String base64Image;
  String status;
  String prediction;

  var imageBytes;

  bool _loading = false;
  File _image;
  String _imageName;

  final picker = ImagePicker();

  Future getImage(ImageSource source) async {
    final pickedImage = await picker.getImage(source: source);
    _image = File(pickedImage.path);
    _imageName = pickedImage.path.split("/").last;
    imageBytes = _image.readAsBytesSync();

    status = "";
  }

  setLoading() {
    setState(() {
      _loading = !_loading;
    });
  }

  upload() async {
    MultipartFile multiPartFile =
        await MultipartFile.fromFile(_image.path, filename: _imageName);
    Map<String, dynamic> body = {"file": multiPartFile};
    FormData formData = FormData.fromMap(body);

    var dio = Dio();

    try {
      final response2 = await dio.post(url, data: formData);
      prediction = response2.data["prediction"];
    } on Exception catch (_) {
      status = "Error - couldn't send data";
    }
  }

  FloatingActionButton buildFloatingActionButton(
      BuildContext context, ImageSource source, Icon icon, String heroTag) {
    return FloatingActionButton(
        heroTag: heroTag,
        backgroundColor: primaryColor,
        elevation: 0,
        child: icon,
        onPressed: () async {
          await getImage(source);
          setLoading();
          await upload();
          setLoading();

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Result(
                      image: _image, title: "Result", result: prediction)));
        });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return _loading
        ? Loading()
        : Scaffold(
            backgroundColor: backgroundColor,
            appBar: AppBar(
              backgroundColor: appBarColor,
              elevation: 0,
              title: Text(
                widget.title,
                style: TextStyle(
                    color: primaryColor,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w700,
                    fontSize: 25),
              ),
              centerTitle: true,
            ),
            body: Padding(
                padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
                child: Stack(
                  children: <Widget>[
                    Column(
                      children: [
                        Center(
                          child: Image.asset(
                            'assets/logo.png',
                            height: size.height * .25,
                          ),
                        ),
                        SizedBox(
                          height: 100,
                        ),
                        Text(
                          'Select an image to classify...',
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: primaryColor),
                        ),
                      ],
                    ),
                    Align(
                        alignment: Alignment.bottomLeft,
                        child: buildFloatingActionButton(
                            context,
                            ImageSource.camera,
                            Icon(Icons.camera_alt_rounded),
                            "camera")),
                    Align(
                        alignment: Alignment.bottomRight,
                        child: buildFloatingActionButton(context,
                            ImageSource.gallery, Icon(Icons.photo), "gallery")),
                  ],
                )));
  }
}
