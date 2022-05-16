import 'package:ctpaga/views/navbar/navbar.dart';
import 'package:ctpaga/providers/provider.dart';
import 'package:ctpaga/env.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:convert';
import 'dart:io';

class DocumentsPage extends StatefulWidget {
  DocumentsPage(this._title);
  final String _title;
  @override
  _DocumentsPageState createState() => _DocumentsPageState(this._title);
}

class _DocumentsPageState extends State<DocumentsPage> {
  _DocumentsPageState(this._title);
  String _title;
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  bool isCameraReady = false, clickBotton = false, clickCamera = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    _controller = CameraController(cameras[0],ResolutionPreset.high);
    _initializeControllerFuture = _controller!.initialize();
    if (!mounted) {
      return;
    }
    setState(() {
      isCameraReady = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Navbar(_title == "Identification"? "Identificación" : "Registro Jurídico", false),

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
                    color: clickBotton? colorGrey : colorLogo,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: AutoSizeText(
                      "Tomar Foto",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'MontserratSemiBold',
                      ),
                      maxFontSize: 14,
                      minFontSize: 14,
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
    var size = MediaQuery.of(context).size;

    if(!clickCamera){
      return Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _title == "Identification"? Image.asset(
                "assets/icons/escaner.png",
                width: size.width / 3,
                height: size.width / 3,
              )
            : Image.asset(
                "assets/icons/escanerDocumento.png",
                width: size.width / 3,
                height: size.width / 3,
              ),

            _title == "Identification"? Padding(
                padding: EdgeInsets.all(30),
                child: AutoSizeText(
                  "Necesitamos una foto de tu identificacíon para comparar con tu selfie y cumplir con regulaciones finacieras.",
                  textAlign: TextAlign.center,
                  style:  TextStyle(
                    color: colorText,
                    fontFamily: 'MontserratSemiBold',
                  ),
                  maxFontSize: 14,
                  minFontSize: 14,
                ),
              )
            : Padding(
                padding: EdgeInsets.all(30),
                child: AutoSizeText(
                  "Necesitamos una foto de tu RIF para verificar que no sea una empresa falsa.",
                  textAlign: TextAlign.center,
                  style:  TextStyle(
                    color: colorText,
                    fontFamily: 'MontserratSemiBold',
                  ),
                  maxFontSize: 14,
                  minFontSize: 14,
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
                  Container(
                    width: size.width,
                    child:CameraPreview(_controller!) ,
                  ),
                  Container(
                    padding: EdgeInsets.only(top:100, bottom: 100),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.0),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),

                  _title == "Identification"? Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: EdgeInsets.only(top:50, left:30, right: 30, bottom: 30),
                        child: AutoSizeText(
                          "Coloca tu identificacíon dentro del cuadro blanco y toma foto",
                          textAlign: TextAlign.center,
                          style:  TextStyle(
                            color: Colors.white,
                            fontFamily: 'MontserratSemiBold',
                          ),
                          maxFontSize: 14,
                          minFontSize: 14,
                        )
                      ),
                    ) 
                  : Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: EdgeInsets.only(top:50, left:30, right: 30, bottom: 30),
                        child: AutoSizeText(
                          "Coloca tu registro jurídico dentro del cuadro blanco y toma foto",
                          textAlign: TextAlign.center,
                          style:  TextStyle(
                            color: Colors.white,
                            fontFamily: 'MontserratSemiBold',
                          ),
                          maxFontSize: 14,
                          minFontSize: 14,
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
                  valueColor: new AlwaysStoppedAnimation<Color>(colorLogo),
                ),
              ); // Otherwise, display a loading indicator.
            }
          },
        )
      );
    }
  }

  void onCaptureButtonPressed() async {  //on camera button press
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    final DateTime now = DateTime.now();
    try {
      final Directory extDir = await getApplicationDocumentsDirectory();
      final String filePath = '${extDir.path}/${_title}_$now.jpg';
      await _controller!.takePicture();
      _onLoading();
      _controller?.dispose();

      String base64Image = base64Encode(File(filePath).readAsBytesSync());
      String fileName = filePath.split("/").last;

      var response = await http.post(
        Uri.parse(urlApi+"updateUserImg"),
        headers:{
          'X-Requested-With': 'XMLHttpRequest',
          'authorization': 'Bearer ${myProvider.accessTokenUser}',
        },
        body: {
          "image": base64Image,
          "name": fileName,
          "description": _title,
          "commerce_id": myProvider.dataCommercesUser[myProvider.selectCommerce].id.toString(),
        }
      );

      var jsonResponse = jsonDecode(response.body); 
      print(jsonResponse); 
      if (jsonResponse['statusCode'] == 201) {
        myProvider.listVerification.add(_title);
        await myProvider.getDataUser(false, false, context);
        Navigator.pop(context);
        Navigator.pop(context);
      }

    } catch (e) {
      Navigator.pop(context);
      setState(() => clickCamera = false);
      showMessage("Sin conexión a internet");
    }
  }

  Future<void> showMessage(_titleMessage,) async {
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
                    fontFamily: 'MontserratSemiBold',
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _onLoading() async {
    
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
                    valueColor: new AlwaysStoppedAnimation<Color>(colorLogo),
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
                            fontFamily: 'MontserratSemiBold',
                          )
                        ),
                        TextSpan(
                          text: "...",
                          style: TextStyle(
                            color: colorLogo,
                            fontFamily: 'MontserratSemiBold',
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