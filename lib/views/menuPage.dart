import 'package:ctpaga/animation/slideRoute.dart';
import 'package:ctpaga/views/navbar/navbar.dart';
import 'package:ctpaga/providers/provider.dart';
import 'package:ctpaga/env.dart';

import 'package:shared_preferences/shared_preferences.dart';
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

  void initState() {
    super.initState();
    initVariable(context);
  }

  void dispose(){
    super.dispose();
  }

  initVariable(BuildContext context){
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    myProvider.getDataUser(false, context);
  } 

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
                itemCount: listMenu.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () => nextPage(listMenu[index]['title'], listMenu[index]['page'], index),
                    child: Stack(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top:5),
                          child: Container(
                            width: size.width,
                            color: statusButton.contains(index)? colorGreen : colorGrey,
                            height: 45,
                            child: Container(
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left:25),
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: listMenu[index]['icon'] == ''? Colors.transparent : Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
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
                        Padding(
                          padding: EdgeInsets.only(left:100, top: 20),
                          child: Text(
                            listMenu[index]['title'],
                            style: TextStyle(
                              fontSize: size.width / 20,
                              color: statusButton.contains(index)? Colors.white : Colors.black,
                            ),
                          ),
                        )
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
    //myProvider.getDataUser(false, context); //TODO: urgente
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
          myProvider.accessTokenUser = null;
          myProvider.dataUser = null;
          myProvider.dataBanksUser = null;
          myProvider.dataPicturesUser = null;
          Navigator.pop(context);
          Navigator.pushReplacement(context, SlideLeftRoute(page: page));
        }
      } on SocketException catch (_) {
        print("error");
      } 
    }else{
      Navigator.push(context, SlideLeftRoute(page: page));
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