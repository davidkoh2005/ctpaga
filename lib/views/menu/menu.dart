import 'package:ctpaga/animation/slideRoute.dart';
import 'package:ctpaga/providers/provider.dart';
import 'package:ctpaga/env.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  List statusButton = [];

  @override
  Widget build(BuildContext context) {
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    var size = MediaQuery.of(context).size;

    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            color: colorGreen,
            child: ListView.builder(
              padding: EdgeInsets.only(top:40),
              itemCount: listMenu.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () => nextPage(listMenu[index]['title'], listMenu[index]['page'], index),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left:25),
                        child: Container(
                          width: 60,
                          height: 60,
                          child: Padding(
                            padding: EdgeInsets.only(top:15, bottom: 15, left: 10, right: 10),
                            child: Visibility(
                              visible: listMenu[index]['icon'] == ''? false : true,
                              child: Image.asset(
                                listMenu[index]['icon'],
                                color: statusButton.contains(index)? Colors.black : Colors.white,
                              )
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left:10),
                          child: Text(
                            listMenu[index]['title'],
                            style: TextStyle(
                              fontSize: size.width / 20,
                              color: statusButton.contains(index)? Colors.black : Colors.white,
                              fontWeight: listMenu[index]['title'] == "Cerrar sesión"? FontWeight.bold : statusButton.contains(index)? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
          )
        ),
        Align(
          alignment: Alignment(0, -0.9),
          child: GestureDetector(
            onTap: () => myProvider.statusButtonMenu = false,
            child: ClipPath(
              clipper: CustomMenuClipper() ,
              child: Container(
                width: 35,
                height: 110,
                color: colorGreen,
                child: Icon(Icons.chevron_left, size: 30,),
              )
            )
          )
        )
      ],
    );
  }

 

  nextPage(title, page, index)async{
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    setState(() =>statusButton.add(index));
    await Future.delayed(Duration(milliseconds: 150));
    setState(() =>statusButton.remove(index));

    if(title == "Productos" || title == "Servicios"){
      if(verifyDataCommerce(myProvider)){
        showMessage("Debe ingresar los datos de la empresa", false);
        await Future.delayed(Duration(seconds: 1));
        Navigator.pop(context);
      }else if(myProvider.dataRates.length == 0 ){
        showMessage("Debe ingresar la tasa de cambio", false);
        await Future.delayed(Duration(seconds: 1));
        Navigator.pop(context);
      }else if(title == "Productos"){
        myProvider.selectProductsServices = 0;
        myProvider.getListCategories();
      }else if(title == "Servicios"){
        myProvider.selectProductsServices = 1;
        myProvider.getListCategories();
      }
      myProvider.statusButtonMenu = false;
      Navigator.push(context, SlideLeftRoute(page: page));
    }else if(title == "Cerrar sesión"){
      _onLoading();
      var myProvider = Provider.of<MyProvider>(context, listen: false);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var result, response, jsonResponse;
      try {
        result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          response = await http.post(
            urlApi+"logout",
            headers:{
              'Content-Type': 'application/json',
              'X-Requested-With': 'XMLHttpRequest',
              'authorization': 'Bearer ${myProvider.accessTokenUser}',
            },
          );

          jsonResponse = jsonDecode(response.body); 
          print(jsonResponse);
          prefs.remove("access_token");
          prefs.remove('selectCommerce');
          myProvider.removeSession(context);
          Navigator.pop(context);
          myProvider.statusButtonMenu = false;
          Navigator.pushReplacement(context, SlideLeftRoute(page: page));
        }
      } on SocketException catch (_) {
        print("error");
      } 
    }else if(title == "Compartir un comercio"){
      launchWhatsApp(false);
    }else if(title == "Pedir ayuda"){
      launchWhatsApp(true);
    }else{
      myProvider.statusButtonMenu = false;
      Navigator.push(context, SlideLeftRoute(page: page));
    }
  }

  verifyDataCommerce(myProvider){
    if(myProvider.dataCommercesUser.length != 0){
      if(myProvider.dataCommercesUser[myProvider.selectCommerce].rif != '' || myProvider.dataCommercesUser[myProvider.selectCommerce].name != '')
        return false;
    }

    return true;
  }

  Future<void> showMessage(_titleMessage, _statusCorrectly) async {
    var size = MediaQuery.of(context).size;

    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _statusCorrectly? Padding(
                padding: EdgeInsets.all(5),
                child: Icon(
                  Icons.check_circle,
                  color: colorGreen,
                  size: size.width / 8,
                )
              )
              : Padding(
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
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: size.width / 20,
                  )
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void launchWhatsApp(status) async {
    String url() {
      if(status){
        if (Platform.isIOS) {
          return "whatsapp://wa.me/$phoneCtpaga/?text=$messageHelp";
        } else {
          return "whatsapp://send?phone=$phoneCtpaga&text=$messageHelp";
        }
      }else{
        if (Platform.isIOS) {
          return "whatsapp://wa.me/?text=$recommend";
        } else {
          return "whatsapp://send?text=$recommend";
        }
      }
    }

    if (await canLaunch(url())) {
      await launch(url());
    } else {
      throw 'Could not launch ${url()}';
    }
  }


  Future<void> _onLoading() async {
    var size = MediaQuery.of(context).size;

    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
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
                          fontSize: size.width / 20,
                        )
                      ),
                      TextSpan(
                        text: "...",
                        style: TextStyle(
                          color: colorGreen,
                          fontSize: size.width / 20,
                        )
                      ),
                    ]
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CustomMenuClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Paint paint = Paint();
    paint.color = Colors.white;

    final width = size.width;
    final height = size.height;

    Path path = Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(0, 8, 10, 16);
    path.quadraticBezierTo(width - 1, height / 2 - 20, width, height / 2);
    path.quadraticBezierTo(width + 1, height / 2 + 20, 10, height - 16);
    path.quadraticBezierTo(0, height - 8, 0, height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}