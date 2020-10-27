import 'package:ctpaga/views/navbar/navbar.dart';
import 'package:ctpaga/providers/provider.dart';
import 'package:ctpaga/env.dart';

import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart';

List<CameraDescription> cameras;

class IdentificationPage extends StatefulWidget {

  @override
  _IdentificationPageState createState() => _IdentificationPageState();
}

class _IdentificationPageState extends State<IdentificationPage> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  bool isCameraReady = false, showCapturedPhoto = false , clickBotton = false, clickCamera = false;
  var ImagePath;

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
    _controller = CameraController(cameras[0],ResolutionPreset.high);
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

    Provider.of<MyProvider>(context, listen: false).getDataUser(false, context);
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Navbar("Identificación", false),

          showInstructionsOrCamera(context),

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

                  }
                },
                child: Container(
                  width:size.width - 100,
                  height: size.height / 20,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        clickBotton? colorGrey : colorGreen,
                        clickBotton? colorGrey : colorGreen,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: Text(
                      "Tomar Foto",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: size.width / 20,
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

  Widget showInstructionsOrCamera(BuildContext context){
    var size = MediaQuery.of(context).size;

    if(!clickCamera){
      return Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              "assets/icons/escaner.png",
              width: size.width / 3,
              height: size.width / 3,
            ),

            Padding(
              padding: EdgeInsets.all(30),
              child: Text(
                "Necesitamos una foto de tu identificacíon para comparar con tu selfie y cumplir con regulaciones finacieras.",
                textAlign: TextAlign.center,
                style:  TextStyle(
                  fontSize: size.width / 20,
                  color: colorGrey
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
                  Container(
                    padding: EdgeInsets.only(top:100, bottom: 100),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.0),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),

                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.only(top:50, left:30, right: 30, bottom: 30),
                      child: Text(
                        "Coloca tu identificacíon dentro del cuadro blanco y toma foto",
                        textAlign: TextAlign.center,
                        style:  TextStyle(
                          fontSize: size.width / 20,
                          color: Colors.white,
                        ),
                      )
                    ),
                  ),

                  Center(
                    child: Container(
                      width: size.width - 50,
                      height: size.height - 570,
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
        )
      );
    }
  }

  void onCaptureButtonPressed() async {  //on camera button press
    try {

      final path = join(
        (await getTemporaryDirectory()).path, //Temporary path
        'test${DateTime.now()}.png',
      );
      ImagePath = path;
      await _controller.takePicture(path); //take photo

      setState(() {
        showCapturedPhoto = true;
      });
    } catch (e) {
      print(e);
    }
  }
}