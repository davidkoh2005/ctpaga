import 'package:ctpaga/animation/slideRoute.dart';

import 'package:ctpaga/views/navbar/navbarDefault.dart';
import 'package:ctpaga/views/registerPage.dart';
import 'package:ctpaga/views/ProductsPage.dart';

import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int clickBotton = 0;

  @override
  Widget build(BuildContext context) {
    
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          NavbarDefault(false,'Princial',RegisterPage()),
          Container(
            height: size.height-190,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                buttonProducts(),
                buttonService(),
                buttonQuantity(),
              ]
            ),
          ),
        ],
      ),
    );
  }

  Widget buttonProducts(){
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: GestureDetector(
        onTap: () {
          setState((){
            clickBotton = 1;
          });
          nextPage(ProductsPage());
        },
        child: Container(
          width:size.width - 100,
          height: size.height / 18,
          decoration: BoxDecoration(
            border: Border.all(
              color: clickBotton == 1? Colors.green : Colors.grey, 
              width: 1.0,
            ),
            gradient: LinearGradient(
              colors: [
                clickBotton == 1? Colors.green : Colors.grey,
                clickBotton == 1? Colors.green : Colors.grey,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(5, 5),
                blurRadius: 10,
              )
            ],
          ),
          child: Center(
            child: Text(
              'Productos',
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

  Widget buttonService(){
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: GestureDetector(
        onTap: () {
          setState(() {
            clickBotton = 2;
          });
        },
        child: Container(
          padding: EdgeInsets.only(top: 10, bottom: 10),
          width:size.width - 100,
          height: size.height / 18,
          decoration: BoxDecoration(
            border: Border.all(
              color: clickBotton == 2? Colors.green : Colors.grey, 
              width: 1.0,
            ),
            gradient: LinearGradient(
              colors: [
                clickBotton == 2? Colors.green : Colors.grey,
                clickBotton == 2? Colors.green : Colors.grey,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(5, 5),
                blurRadius: 10,
              )
            ],
          ),
          child: Center(
            child: Text(
              'Servicio',
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

  Widget buttonQuantity(){
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: GestureDetector(
        onTap: () {
          setState(() {
            clickBotton = 3;
          });
        },
        child: Container(
          padding: EdgeInsets.only(top: 10, bottom: 10),
          width:size.width - 100,
          height: size.height / 18,
          decoration: BoxDecoration(
            border: Border.all(
              color: clickBotton == 3? Colors.green : Colors.grey, 
              width: 1.0,
            ),
            gradient: LinearGradient(
              colors: [
                clickBotton == 3? Colors.green : Colors.grey,
                clickBotton == 3? Colors.green : Colors.grey,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(5, 5),
                blurRadius: 10,
              )
            ],
          ),
          child: Center(
            child: Text(
              'Cantidad',
              style: TextStyle(
                color: Colors.white,
                fontSize: size.width / 20,
              ),
            ),
          ),
        ),
      ),
    );
  }

  nextPage(Widget page)async{
    await Future.delayed(Duration(milliseconds: 250));
    setState(() {
      clickBotton = 0;
    });
    Navigator.push(context, SlideLeftRoute(page: page));
  }
}