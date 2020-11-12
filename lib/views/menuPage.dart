import 'package:ctpaga/animation/slideRoute.dart';
import 'package:ctpaga/views/navbar/navbar.dart';
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

    var size = MediaQuery.of(context).size;

    return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Navbar("Menu", false),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
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
                                  color: statusButton.contains(index)? colorGreen : Colors.black,
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
                                color: statusButton.contains(index)? colorGreen : Colors.black,
                                fontWeight: listMenu[index]['title'] == "Cerrar sesión"? FontWeight.bold : statusButton.contains(index)? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
  }

 

  nextPage(title, page, index)async{
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    setState(() =>statusButton.add(index));
    await Future.delayed(Duration(milliseconds: 150));
    setState(() =>statusButton.remove(index));

    if(title == "Perfil"){
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
          myProvider.logout();
          Navigator.pop(context);
          Navigator.pushReplacement(context, SlideLeftRoute(page: page));
        }
      } on SocketException catch (_) {
        print("error");
      } 
    }else if(verifyDataCommerce()){
      showMessage("Debe ingresar los datos de la empresa", false);
    }else if(title == "Recomentar a un comercio"){
      launchWhatsApp(false);
    }else if(title == "Pedir ayuda"){
      launchWhatsApp(true);
    }else{
      if(title == "Productos"){
        myProvider.selectProductsServices = 0;
        myProvider.getListCategories();
      }else if(title == "Servicios"){
        myProvider.selectProductsServices = 1;
        myProvider.getListCategories();
      }
      Navigator.push(context, SlideLeftRoute(page: page));
    }
  }

  verifyDataCommerce(){
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    if(myProvider.dataCommercesUser.length != 0){
      if(myProvider.dataCommercesUser[myProvider.selectCommerce] != null)
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