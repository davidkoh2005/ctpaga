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
    var size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async =>false,
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            NavbarMain(),
            Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(top: 10, right:30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  buttonBs(),
                  Padding(
                    padding: EdgeInsets.only(left: 15, right: 15),
                    child: Text(
                      "<>",
                      style: TextStyle(
                        color: colorGreen,
                        fontSize: size.width / 20,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ),
                  buttonUSD(),
                ],
              )
            ),
            Expanded(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  buttonMain("Productos",1, ProductsPage(true)), //send variable the same design
                  buttonMain("Servicio",2, null), //send variable the same design
                  buttonMain("Monto",3, QuantityPage()), //send variable the same design
                  SizedBox(height:100),
                ]
              )
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
    return Padding(
      padding: EdgeInsets.only(right:0),
      child: GestureDetector(
        onTap: () => setState(() => _statusCoin = 0), 
        child: Container(
          child: Center(
            child: Text(
              "\$",
              style: TextStyle(
                color: _statusCoin == 0? colorGreen : Colors.grey,
                fontSize: size.width / 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      )
    );
  }

  Widget buttonBs(){
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(left:30),
      child: GestureDetector(
        onTap: () => setState(() => _statusCoin = 1), 
        child: Container(
          child: Center(
            child: Text(
              "Bs",
              style: TextStyle(
                color: _statusCoin == 1? colorGreen : Colors.grey,
                fontSize: size.width / 15,
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

  nextPage(Widget page)async{
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    await Future.delayed(Duration(milliseconds: 150)); //wait time
    setState(() => clickBotton = 0); //delete selected button color
    
    if(myProvider.dataCommercesUser.length == 0){
      showMessage("Debe ingresar los datos de la empresa", false);
    }else{
      Navigator.push(context, SlideLeftRoute(page: page));
    }
  }

}