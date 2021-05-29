import 'dart:io';
import 'dart:core';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DetailScreen extends StatefulWidget {
  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  String selectedItem = '';

  late File pickedImage;
  var imageFile;
  bool isImageLoaded = false;

  var resultText = '';
  List resultArray = [];
  var takeName = '';
  var takeNIK = '';

  Future getImageFromGallery() async {
    resultText = '';
    resultArray = [];

    var tempStore = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      pickedImage = File(tempStore!.path);
      isImageLoaded = true;
    });

    FirebaseVisionImage myImage = FirebaseVisionImage.fromFile(pickedImage);
    TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();
    VisionText readText = await recognizeText.processImage(myImage);

    for (TextBlock block in readText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement word in line.elements) {
          /* setState(() {
            resultText += word.text + ' ';
          }); */
        }
        setState(() {
          resultArray.addAll({line.text});
        });
      }
    }

    setState(() {
      takeName = resultArray[3];

      var beforeNIK = resultArray[2];
      var targetNIK = beforeNIK.substring(0, 3);
      if (targetNIK == 'NIK') {
        takeNIK = beforeNIK.substring(4, 20);
      } else {
        takeNIK = resultArray[2];
      }
    });

    print(resultArray);
  }

  Future getImageFromCamera() async {
    resultText = '';
    resultArray = [];

    var tempStore = await ImagePicker().getImage(source: ImageSource.camera);
    setState(() {
      pickedImage = File(tempStore!.path);
      isImageLoaded = true;
    });

    FirebaseVisionImage myImage = FirebaseVisionImage.fromFile(pickedImage);
    TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();
    VisionText readText = await recognizeText.processImage(myImage);

    for (TextBlock block in readText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement word in line.elements) {
          /* setState(() {
            resultText += word.text + ' ';
          }); */
        }
        setState(() {
          resultArray.addAll({line.text});
        });
      }
    }

    print(resultArray);
    setState(() {
      takeName = resultArray[3];

      var beforeNIK = resultArray[2];
      var targetNIK = beforeNIK.substring(0, 3);
      if (targetNIK == 'NIK') {
        takeNIK = beforeNIK.substring(4, 20);
      } else {
        takeNIK = resultArray[2];
      }
    });
  }

  /* Future readTextFromAnImage() async {
    resultText = '';
    FirebaseVisionImage myImage = FirebaseVisionImage.fromFile(pickedImage);
    TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();
    VisionText readText = await recognizeText.processImage(myImage);

    for (TextBlock block in readText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement word in line.elements) {
          resultText += word.text + ' ';
        }
      }
    }
  } */

  @override
  Widget build(BuildContext context) {
    /* selectedItem = ModalRoute.of(context).settings.arguments.toString(); */
    selectedItem = ModalRoute.of(context).toString();
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedItem),
        actions: [
          RaisedButton(
            onPressed: () {
              getImageFromGallery();
            },
            child: Icon(
              Icons.add_a_photo,
              color: Colors.white,
            ),
            color: Colors.blue,
          ),
        ],
      ),
      body: ListView(
        children: [
          SizedBox(height: 100),
          isImageLoaded
              ? Center(
                  child: Container(
                    height: 250,
                    width: 250,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: FileImage(pickedImage),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )
              : Container(),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(resultText),
          ),
          SizedBox(
            height: 30,
          ),
          Column(
            children: [
              Text('Nama : ${takeName}'),
              Text('NIK : ${takeNIK}'),
              /* resultArray == []
                  ? Column(
                      children: [
                        Text('Nama : '),
                        Text('NIK : '),
                      ],
                    )
                  : Column(
                      children: [
                        Text('Nama : ${resultArray[2]}'),
                        Text('NIK : ${resultArray[3]}'),
                      ],
                    ), */
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          /* readTextFromAnImage(); */
          getImageFromCamera();
        },
        child: Icon(
          Icons.camera_alt,
        ),
      ),
    );
  }
}
