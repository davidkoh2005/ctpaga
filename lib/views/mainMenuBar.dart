import 'package:ctpaga/views/exchangeRatePage.dart';
import 'package:ctpaga/views/menu/menu.dart';
import 'package:ctpaga/views/navbar/navbarMain.dart';
import 'package:ctpaga/views/salesReportPage.dart';
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
  int _statusButton = 1;

  final _pageOptions = [
    ExchangeRatePage(false),
    MainPage(),
    SalesReportPage(false),
  ];
  
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer<MyProvider>(
      builder: (context, myProvider, child) {
        return WillPopScope(
          onWillPop: () async =>false,
          child: Scaffold(
            body: Stack(
              children: [
                Column(
                  children: <Widget> [
                    Expanded(child:_pageOptions[_statusButton]),
                    _showMenu(),
                  ]
                ),
                AnimatedContainer(
                  duration: Duration(seconds:1),
                  width: !myProvider.statusButtonMenu? 0 : size.width,
                  child: AnimatedOpacity(
                    opacity: myProvider.statusButtonMenu? 1.0 : 0.0,
                    duration: Duration(seconds:1),
                    child:MenuPage(),
                  )
                ),
              ]
            )
          )
        );
      }
    );
  }

  Widget _showMenu(){
    var size = MediaQuery.of(context).size;
    return Container(
      height: size.height / 10,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            width: 0.5,
            color: Colors.black
          )
        )
      ),
      child: Padding(
        padding: EdgeInsets.only(top:15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _buildNavItem("Tasa", "assets/icons/tasa.png", _statusButton,0),
            SizedBox(width: 1),
            _buildNavItem("Home" ,"assets/icons/home.png",_statusButton, 1),
            SizedBox(width: 1),
            _buildNavItem("Transacción", "assets/icons/reporte.png", _statusButton, 2),
          ]
        ),
      ),
    );
  }

  Widget _buildNavItem(String _title, String _icon, int _status, int code){
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => setState(()=> _statusButton = code),
      child: Container(
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
              padding: EdgeInsets.only(top:5),
              child: Text(
                _title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: size.width / 25,
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
