import 'package:ctpaga/views/navbar/navbar.dart';
import 'package:ctpaga/providers/provider.dart';
import 'package:ctpaga/env.dart';

import 'package:path_provider/path_provider.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart';

List<CameraDescription> cameras;

class SelfiePage extends StatefulWidget {

  @override
  _SelfiePageState createState() => _SelfiePageState();
}

class _SelfiePageState extends State<SelfiePage> {
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

    Provider.of<MyProvider>(context, listen: false).getDataUser(false, context);
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Navbar("Selfie", false),
          SizedBox(height: 20),

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
              return Container(
                color: colorGrey,
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Container(
                      width: size.width - 200,
                      height: size.height / 3,
                      child: CameraPreview(_controller)
                    ),
                  )
                ),
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