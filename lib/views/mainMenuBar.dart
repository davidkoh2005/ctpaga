import 'package:ctpaga/views/exchangeRatePage.dart';
import 'package:ctpaga/views/salesReportPage.dart';
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
  bool _statusBadge = false;

  final _pageOptions = [
    ExchangeRatePage(true),
    MainPage(),
    MainPage(),
    DepositsPage(true),
    SalesReportPage(true),
  ];
  
  @override
  Widget build(BuildContext context) {
    var scaleFactor = MediaQuery.of(context).textScaleFactor;
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
                  children: <Widget>[
                    Expanded(child:_pageOptions[_statusButton]),
                    SizedBox(height: 60),
                  ],
                ),

                AnimatedPositioned(
                  duration: Duration(milliseconds:250),
                  bottom: _statusBadge? 55 : -200,
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 80),
                      child: Container(
                        width: 80,
                        height: size.height/4.82,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 0.5,
                          ),
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10.0),
                              topLeft: Radius.circular(10.0)),
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.only(top:10, bottom: 10),
                              width: size.width,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                  width: 0,
                                ),
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10.0),
                                    topLeft: Radius.circular(10.0)),
                                color: myProvider.coinUsers == 0? colorGreen : Colors.white,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  myProvider.coinUsers = 0;
                                  setState(() => _statusBadge = false);
                                },
                                child: Column(
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
                                    Container(
                                      child: Text(
                                        "\$",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20 * scaleFactor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ),
                            
                            Container(
                              color: myProvider.coinUsers == 1? colorGreen : Colors.white,
                              width: size.width,
                              padding: EdgeInsets.only(top:10, bottom: 10),
                              child: GestureDetector(
                                onTap: () {
                                  myProvider.coinUsers = 1;
                                  setState(() => _statusBadge = false);
                                },
                                child: Column(
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
                                    Container(
                                      child: Text(
                                        "Bs",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20 * scaleFactor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              )
                            ),
                          ]
                        ),
                      )
                    )
                  )
                ),

                Positioned(
                  bottom: 0,
                  child: _showMenu()
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
        ),
        color: Colors.white,
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
        if(code == 1)
          setState(() => _statusBadge = !_statusBadge);
        else{
          setState((){
            _statusBadge = false;
            _statusButton = code;
          });

          if(code == 3 || code == 4){
            myProvider.getDataUser(false, false, context);
          }

        }
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

}
