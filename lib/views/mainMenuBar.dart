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
    ShippingPage(true),
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
          _buildNavItem("Envios" ,"assets/icons/envios.png",_statusButton, 1),
          _buildNavItem("Home" ,"assets/icons/home.png",_statusButton, 2),
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
          myProvider.verifyStatusDeposits();
          myProvider.getListPaids();
        }
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
                  fontSize: 12 * scaleFactor,
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
