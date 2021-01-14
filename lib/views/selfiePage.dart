import 'package:ctpaga/views/navbar/navbar.dart';
import 'package:ctpaga/providers/provider.dart';
import 'package:ctpaga/env.dart';

import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:convert';
import 'dart:io';

List<CameraDescription> cameras;

class SelfiePage extends StatefulWidget {

  @override
  _SelfiePageState createState() => _SelfiePageState();
}

class _SelfiePageState extends State<SelfiePage> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  bool isCameraReady = false, showCapturedPhoto = false , clickBotton = false, clickCamera = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    _controller = CameraController(cameras[1],ResolutionPreset.high);
    _initializeControllerFuture = _controller.initialize();
    if (!mounted) {
      return;
    }
    setState(() {
      isCameraReady = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    var scaleFactor = MediaQuery.of(context).textScaleFactor;
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Navbar("Selfie", false),

          showInstructionsOrCamera(),

          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.only(top: 30, bottom: 30),
              child: GestureDetector(
                onTap: () {
                  if (!clickCamera){
                    setState(() => clickCamera = true);
                    _initializeCamera(); 
                  }else{
                    onCaptureButtonPressed();
                  }
                },
                child: Container(
                  width:size.width - 100,
                  height: size.height / 20,
                  decoration: BoxDecoration(
                    color: clickBotton? colorGrey : colorGreen,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: Text(
                      "Tomar Foto",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15 * scaleFactor,
                        fontFamily: 'MontserratExtraBold',
                      ),
                    ),
                  ),
                ),
              )
            )
          ),
        ],
      ),
    );
  }

  Widget showInstructionsOrCamera(){
    var scaleFactor = MediaQuery.of(context).textScaleFactor;
    var size = MediaQuery.of(context).size;
    var parser = EmojiParser();

    if(!clickCamera){
      return Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              "assets/icons/selfie-color.png",
              width: size.width / 3,
              height: size.width / 3,
            ),

            Padding(
              padding: EdgeInsets.all(30),
              child: Text(
                "Necesitamos una foto de tu cara (Sin Lentes ${parser.emojify(':sunglasses:')} ) para comparar con tu identificacion y cumplir con regulaciones finacieras.",
                textAlign: TextAlign.center,
                style:  TextStyle(
                  fontSize: 15 * scaleFactor,
                  color: colorText,
                  fontFamily: 'MontserratExtraBold',
                ),
              ),
            ),

        ],
        )
      );
    }else{
      return Expanded(
        child: FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // If the Future is complete, display the preview.
              return Stack(
                children: [
                  CameraPreview(_controller),

                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.only(top:20, left:30, right: 30, bottom: 30),
                      child: Text(
                        "Coloca tu cara dentro del cuadro blanco y toma foto",
                        textAlign: TextAlign.center,
                        style:  TextStyle(
                          fontSize: 15 * scaleFactor,
                          color: Colors.white,
                          fontFamily: 'MontserratExtraBold',
                        ),
                      )
                    ),
                  ),

                  Center(
                    child: Container(
                      width: size.width - 100,
                      height: size.height - 400,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          width: 5,
                          color: Colors.white,
                        ),
                      ),
                      child: null,
                    )
                  ), 
                ]
              );
            } else {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(colorGreen),
                ),
              ); // Otherwise, display a loading indicator.
            }
          },
        ),
      );
    }
  }

  void onCaptureButtonPressed() async {  //on camera button press
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    final DateTime now = DateTime.now();
    try {
      final Directory extDir = await getApplicationDocumentsDirectory();
      final String filePath = '${extDir.path}/Selfie_$now.jpg';
      await _controller.takePicture(filePath);
      _onLoading();
      _controller?.dispose();


      String base64Image = base64Encode(File(filePath).readAsBytesSync());
      String fileName = filePath.split("/").last;

      var response = await http.post(
        urlApi+"updateUserImg",
        headers:{
          'X-Requested-With': 'XMLHttpRequest',
          'authorization': 'Bearer ${myProvider.accessTokenUser}',
        },
        body: {
          "image": base64Image,
          "name": fileName,
          "description": "Selfie",
          "commerce_id": myProvider.dataCommercesUser[myProvider.selectCommerce].id.toString(),
        }
      );

      var jsonResponse = jsonDecode(response.body); 
      print(jsonResponse); 
      if (jsonResponse['statusCode'] == 201) {
        myProvider.listVerification.add("Selfie");       
        myProvider.getDataUser(false, false, context);
        Navigator.pop(context);
        Navigator.pop(context);
      }

    } catch (e) {
      Navigator.pop(context);
      setState(() => clickCamera = false);
      showMessage("Sin conexión a internet");
    }
  }

  Future<void> showMessage(_titleMessage) async {
    var scaleFactor = MediaQuery.of(context).textScaleFactor;
    var size = MediaQuery.of(context).size;

    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(5),
                child: Icon(
                  Icons.error,
                  color: Colors.red,
                  size: size.width / 8,
                )
              ),
              Container(
                padding: EdgeInsets.all(5),
                child: Text(
                  _titleMessage,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15 * scaleFactor,
                    fontFamily: 'MontserratExtraBold',
                  )
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _onLoading() async {
    var scaleFactor = MediaQuery.of(context).textScaleFactor;

    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            backgroundColor: Colors.white,
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(5),
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(colorGreen),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Cargando ",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15 * scaleFactor,
                            fontFamily: 'MontserratExtraBold',
                          )
                        ),
                        TextSpan(
                          text: "...",
                          style: TextStyle(
                            color: colorGreen,
                            fontSize: 15 * scaleFactor,
                            fontFamily: 'MontserratExtraBold',
                          )
                        ),
                      ]
                    ),
                  ),
                ),
              ],
            ),
          )
        );
      },
    );
  }
}