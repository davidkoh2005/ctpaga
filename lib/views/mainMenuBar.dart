import 'package:ctpaga/views/exchangeRatePage.dart';
import 'package:ctpaga/views/salesReportPage.dart';
import 'package:ctpaga/views/shippingPage.dart';
import 'package:ctpaga/views/depositsPage.dart';
import 'package:ctpaga/views/menu/menu.dart';
import 'package:ctpaga/views/mainPage.dart';
import 'package:ctpaga/providers/provider.dart';
import 'package:ctpaga/env.dart';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';


class MainMenuBar extends StatefulWidget {
  @override
  _MainMenuBarState createState() => _MainMenuBarState();
}

class _MainMenuBarState extends State<MainMenuBar> {
  int _statusButton = 2;

  final _pageOptions = [
    ExchangeRatePage(true),
    MainPage(),
    MainPage(),
    DepositsPage(true),
    SalesReportPage(true),
  ];
  
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer<MyProvider>(
      builder: (context, myProvider, child) {
        return WillPopScope(
          onWillPop: () async =>false,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                Column(
                  children: <Widget> [
                    Expanded(child:_pageOptions[_statusButton]),
                    _showMenu(),
                  ]
                ),
                
                AnimatedPositioned(
                  duration: Duration(milliseconds:250),
                  top: 0,
                  bottom: 0,
                  left: myProvider.statusButtonMenu? 0 : -size.width,
                  right: myProvider.statusButtonMenu? 0 : size.width,
                  child: MenuPage(),
                ),
              ]
            )
          )
        );
      }
    );
  }

  Widget _showMenu(){
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            width: 0.5,
            color: Colors.black
          )
        )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize :MainAxisSize.max,
        children: <Widget>[
          _buildNavItem("Tasa", "assets/icons/tasa.png", _statusButton,0),
          _buildNavItem("Divisa" ,"assets/icons/divisa.png",_statusButton, 1),
          _buildNavItem("Inicio" ,"assets/icons/home.png",_statusButton, 2),
          _buildNavItem("Banco", "assets/icons/depositos.png", _statusButton, 3),
          _buildNavItem("Transacción", "assets/icons/reporte.png", _statusButton, 4),
        ]
      ),
    );
  }

  Widget _buildNavItem(String _title, String _icon, int _status, int code){
    var size = MediaQuery.of(context).size;
    var scaleFactor = MediaQuery.of(context).textScaleFactor;
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    return GestureDetector(
      onTap: () {
        if(code == 3 || code == 4){
          myProvider.getDataUser(false, false, context);
        }

        if(code == 1)
          showDivisa();
        
        setState(()=> _statusButton = code);
      },
      child: Container(
        padding: EdgeInsets.only(top:10),
        width: size.width / 5.1,
        child: Column(
          children: <Widget> [
            Container(
              child: Center(
                child: Image.asset(
                  _icon,
                  width: size.width / 15,
                  height: size.width / 15,
                  color: _status == code? colorGreen : Colors.black,
                )
              )
            ),
            Container(
              padding: EdgeInsets.only(top:5, bottom: 5),
              child: Text(
                _title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 10 * scaleFactor,
                  fontWeight: _status == code? FontWeight.bold: FontWeight.normal
                ),
              ),
            )
          ]
        )
      )
    );
  }

  Future<void> showDivisa(){
    var scaleFactor = MediaQuery.of(context).textScaleFactor;
    var size = MediaQuery.of(context).size;
    return showDialog(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return Consumer<MyProvider>(
          builder: (context, myProvider, child) {
            return WillPopScope(
              onWillPop: () async => true,
              child: AlertDialog(
                backgroundColor: Colors.white,
                content: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        "Seleccionar Divisa:",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15 * scaleFactor,
                        )
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        myProvider.coinUsers = 1;
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: size.width/2,
                        height: size.width/7,
                        decoration: new BoxDecoration(
                          color: myProvider.coinUsers == 1 ? colorGreen : colorGrey,
                          borderRadius: new BorderRadius.circular(5.0),
                        ),
                        child: Row(
                          children: <Widget>[
                            Container(
                              height: size.width/8,
                              child: CircleAvatar(
                                radius: 30.0,
                                backgroundColor: Colors.white,
                                child: Image(
                                  image: AssetImage("assets/icons/venezuela.png"),
                                  width: size.width/10,
                                ),
                              )
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Container(
                                child: Text(
                                  "Bs",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20 * scaleFactor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ),
                    SizedBox(height:10),
                    GestureDetector(
                      onTap: () {
                        myProvider.coinUsers = 0;
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: size.width/2,
                        height: size.width/7,
                        decoration: new BoxDecoration(
                          color: myProvider.coinUsers == 0 ? colorGreen : colorGrey,
                          borderRadius: new BorderRadius.circular(5.0),
                        ),
                        child: Row(
                          children: <Widget>[
                            Container(
                              height: size.width/8,
                              child: CircleAvatar(
                                radius: 30.0,
                                backgroundColor: Colors.white,
                                child: Image(
                                  image: AssetImage("assets/icons/eeuu.png"),
                                  width: size.width/10,
                                ),
                              )
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Container(
                                child: Text(
                                  "\$",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20 * scaleFactor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  ],
                ),
              )
            );
          }
        );
      }
    ).then((val){
        setState(()=> _statusButton = 2);
    });
  }
}
