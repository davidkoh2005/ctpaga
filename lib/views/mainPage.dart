import 'package:ctpaga/animation/slideRoute.dart';
import 'package:ctpaga/views/navbar/navbarMain.dart';
import 'package:ctpaga/views/productsPage.dart';
import 'package:ctpaga/views/quantityPage.dart';
import 'package:ctpaga/providers/provider.dart';
import 'package:ctpaga/models/user.dart';
import 'package:ctpaga/models/bank.dart';
import 'package:ctpaga/env.dart';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';


class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  User user = User();
  List bankUser = new List(2);
  Bank bankUserUSD = Bank();
  Bank bankUserBs = Bank();
  int clickBotton = 0, _statusCoin = 0;

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
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(bottom: 100, top: 100),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          buttonUSD(),
                          buttonBs(),
                        ],
                      )
                    ),
                    buttonMain("Productos",1, ProductsPage(true)), //send variable the same design
                    buttonMain("Servicio",2, null), //send variable the same design
                    buttonMain("Cantidad",3, QuantityPage()), //send variable the same design
                  ]
                )
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

  Widget buttonUSD(){
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => changeButtonCoin(0), 
      child: Container(
        width:size.width / 5,
        height: size.height / 25,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              _statusCoin == 0? colorGreen : colorGrey,
              _statusCoin == 0? colorGreen : colorGrey
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
          ),
        child: Center(
          child: Text(
            "\$",
            style: TextStyle(
              color: Colors.white,
              fontSize: size.width / 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget buttonBs(){
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(left:20),
      child: GestureDetector(
        onTap: () => changeButtonCoin(1), 
        child: Container(
          width:size.width / 5,
          height: size.height / 25,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                _statusCoin == 1? colorGreen : colorGrey,
                _statusCoin == 1? colorGreen : colorGrey
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30),
            ),
          child: Center(
            child: Text(
              "Bs",
              style: TextStyle(
                color: Colors.white,
                fontSize: size.width / 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      )
    );
  }

  changeButtonCoin(coin){
    var myProvider = Provider.of<MyProvider>(context, listen: false);

    setState(() => _statusCoin = coin);
    myProvider.coinUsers = coin;
  }

  nextPage(Widget page)async{
    await Future.delayed(Duration(milliseconds: 150)); //wait time
    setState(() => clickBotton = 0); //delete selected button color
    Navigator.push(context, SlideLeftRoute(page: page));
  }

}