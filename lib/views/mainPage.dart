import 'package:ctpaga/animation/slideRoute.dart';
import 'package:ctpaga/views/navbar/navbarMain.dart';
import 'package:ctpaga/views/productsServicesPage.dart';
import 'package:ctpaga/views/amountPage.dart';
import 'package:ctpaga/providers/provider.dart';
import 'package:ctpaga/views/menu/menu.dart';
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
  void initState() {
    super.initState();
    initialVariable();
  }

  @override
  void dispose() {
    super.dispose();
  }

  initialVariable(){
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    _statusCoin = myProvider.coinUsers;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async =>false,
      child: Scaffold(
        body: Stack(
          children: <Widget> [
            Column(
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
                          "< >",
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
                      buttonMain("Productos",1, ProductsServicesPage(true)), //send variable the same design
                      buttonMain("Servicios",2, ProductsServicesPage(true)), //send variable the same design
                      buttonMain("Monto",3, AmountPage()), //send variable the same design
                      SizedBox(height:100),
                    ]
                  )
                ),
              ],
            ),

            Consumer<MyProvider>(
              builder: (context, myProvider, child) {
                return Visibility(
                  visible: myProvider.statusButtonMenu,
                  child: MenuPage(),
                );
              }
            ),
          ]
        )
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
          nextPage(_page, _title); //next page
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
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(right:0),
      child: GestureDetector(
        onTap: () {
          myProvider.coinUsers = 0;
          setState(() => _statusCoin = 0);
        }, 
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
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(left:30),
      child: GestureDetector(
        onTap: () {
          myProvider.coinUsers = 1;
          setState(() => _statusCoin = 1);
        }, 
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

  nextPage(Widget page, _title)async{
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    await Future.delayed(Duration(milliseconds: 150)); //wait time
    setState(() => clickBotton = 0); //delete selected button color
    
    if(verifyDataCommerce(myProvider)){
      showMessage("Debe ingresar los datos de la empresa", false);
    }else if((myProvider.dataRates.length == 0 )){
      showMessage("Debe ingresar la tasa de cambio", false);
    }else{
      if(_title == "Productos"){
        myProvider.selectProductsServices = 0;
        myProvider.getListCategories();
      }else if(_title == "Servicios"){
        myProvider.selectProductsServices = 1;
        myProvider.getListCategories();
      }
      Navigator.push(context, SlideLeftRoute(page: page));
    }
  }

  verifyDataCommerce(myProvider){
    if(myProvider.dataCommercesUser.length != 0){
      if(myProvider.dataCommercesUser[myProvider.selectCommerce].rif != '' || myProvider.dataCommercesUser[myProvider.selectCommerce].name != '')
        return false;
    }

    return true;
  }

}