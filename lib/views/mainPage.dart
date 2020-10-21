import 'package:ctpaga/animation/slideRoute.dart';
import 'package:ctpaga/views/navbar/navbarMain.dart';
import 'package:ctpaga/views/productsPage.dart';
import 'package:ctpaga/views/quantityPage.dart';
import 'package:ctpaga/providers/provider.dart';
import 'package:ctpaga/models/user.dart';
import 'package:ctpaga/env.dart';

import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';


class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  User user = User();
  int clickBotton = 0;

  void initState() {
    super.initState();
    getDataUser();
  }

  getDataUser()async{
    var result, response, jsonResponse;
    var myProvider = Provider.of<MyProvider>(context, listen: false);
      try {
      result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        response = await http.post(
          urlApi+"user/",
          headers:{
            'Content-Type': 'application/json',
            'X-Requested-With': 'XMLHttpRequest',
            'authorization': 'Bearer ${myProvider.accessTokenUser}',
          },
        ); 

        jsonResponse = jsonDecode(response.body);
        if (jsonResponse['statusCode'] == 201) {
          user = User(
            rif: jsonResponse['data']['rif'] == null? '' : jsonResponse['data']['rif'],
            nameCompany: jsonResponse['data']['nameCompany'] == null? '' : jsonResponse['data']['nameCompany'],
            addressCompany: jsonResponse['data']['addressCompany'] == null? '' : jsonResponse['data']['addressCompany'],
            phoneCompany: jsonResponse['data']['phoneCompany'] == null? '' : jsonResponse['data']['phoneCompany'],
            email: jsonResponse['data']['email'],
            name: jsonResponse['data']['name'],
            address: jsonResponse['data']['address'],
            phone: jsonResponse['data']['phone'],
          );
          myProvider.dataUser = user;
        }  
      }
    } on SocketException catch (_) {
      print("error network");
    } 
  }

  @override
  Widget build(BuildContext context) {
    
    return WillPopScope(
      onWillPop: () async =>false,
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            NavbarMain(),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  buttonMain("Productos",1, ProductsPage(true)), //send variable the same design
                  buttonMain("Servicio",2, null), //send variable the same design
                  buttonMain("Cantidad",3, QuantityPage()), //send variable the same design
                ]
              ),
            ),
          ],
        ),
      )
    );
  }

  Widget buttonMain(_title, _index, _page){
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: GestureDetector(
        onTap: () {
          setState(() => clickBotton = _index); //I add color selected button
          nextPage(_page); //next page
        },
        child: Container(
          width:size.width - 100,
          height: size.height / 20,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                clickBotton == _index? colorGreen : colorGrey,
                clickBotton == _index? colorGreen : colorGrey,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Text(
              _title,
              style: TextStyle(
                color: Colors.white,
                fontSize: size.width / 20,
              ),
            ),
          ),
        ),
      )
    );
  }

  nextPage(Widget page)async{
    await Future.delayed(Duration(milliseconds: 150)); //wait time
    setState(() => clickBotton = 0); //delete selected button color
    Navigator.push(context, SlideLeftRoute(page: page));
  }
}