import 'package:ctpaga/animation/slideRoute.dart';
import 'package:ctpaga/views/processSalesPage.dart';
import 'package:ctpaga/views/navbar/navbar.dart';
import 'package:ctpaga/providers/provider.dart';
import 'package:ctpaga/env.dart';

import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class VerifyDataClientPage extends StatefulWidget {
  @override
  _VerifyDataClientPageState createState() => _VerifyDataClientPageState();
}

class _VerifyDataClientPageState extends State<VerifyDataClientPage> {
  double _total;
  int _totalProducts=0;
  bool _statusButton = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Navbar("Nuevo Cobro", true),
          Expanded(
            child: formDataSales(),
          ),
        ],
      ),
    );
  }

  formDataSales(){
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    var size = MediaQuery.of(context).size;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 0.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "COBRAR",
              style: TextStyle(
                color: colorText,
                fontSize: size.width / 20,
              ),
            ),
          ),
        ),

        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top:30),
              child: Text(
                showTotal(),
                textAlign: TextAlign.center,
                style:  TextStyle(
                  fontSize: size.width / 10,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top:5),
              child: Text(
                "por $_totalProducts ${_totalProducts >1?'artículos':'artículo'}",
                style: TextStyle(
                  fontSize: size.width / 20,
                  color: colorText,
                ),
              ),
            ),
          ],
        ),

        Center(
          child: Container(
            child: Text(
              "A",
              style: TextStyle(
                fontSize: size.width / 15,
                color: colorText,
              ),
            ),
          ),
        ),

        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top:30),
              child: myProvider.avatarClient.length ==0? 
                CircleAvatar(
                  minRadius: size.width / 8,
                  maxRadius: size.width / 8,
                  child: Text(
                    myProvider.initialsClient,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size.width / 15,
                    ),
                  ),
                  backgroundColor: colorGreen,
                )
              : CircleAvatar(
                  minRadius: size.width / 8,
                  maxRadius: size.width / 8,
                  backgroundImage: MemoryImage(myProvider.avatarClient),
                )
            ),
            Container(
              padding: EdgeInsets.only(top:10),
              child: Text(
                myProvider.nameClient,
                style: TextStyle(
                  fontSize: size.width / 17,
                  color: colorText,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top:10),
              child: Text(
                "Nuevo cliente",
                style: TextStyle(
                  fontSize: size.width / 22,
                  color: colorText,
                ),
              ),
            ),
          ],
        ),
        
        
        Padding(
          padding: EdgeInsets.only(top: 60, bottom: 60),
          child: buttonContinue()
        ),
      ],
    );
  }

  Widget buttonContinue(){
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => nextPage(),
      child: Container(
        width:size.width - 100,
        height: size.height / 20,
        decoration: BoxDecoration(
          border: Border.all(
            color: colorGrey, 
            width: 1.0,
          ),
          gradient: LinearGradient(
            colors: [
              _statusButton? colorGrey : colorGreen,
              _statusButton? colorGrey : colorGreen,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
          ),
        child: Center(
          child: Text(
            "CONTINUAR",
            style: TextStyle(
              color: Colors.white,
              fontSize: size.width / 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  showTotal(){
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    var lowPurchase = new MoneyMaskedTextController(initialValue: 0, decimalSeparator: ',', thousandSeparator: '.',  leftSymbol: '\$ ', );
    double priceDouble, varRate = double.parse(myProvider.dataRates[0].rate);
    _total = 0.0;
    _totalProducts = 0;

    if(myProvider.coinUsers  == 1)
      lowPurchase = new MoneyMaskedTextController(initialValue: 0, decimalSeparator: ',', thousandSeparator: '.',  leftSymbol: 'Bs ', );

    for (var item in myProvider.dataPurchase) {
      priceDouble = double.parse(item['data'].price);
      priceDouble *= item['quantity'];
      if(item['data'].coin == 0 && myProvider.coinUsers == 1)
        _total+=(priceDouble * varRate);
      else if(item['data'].coin == 1 && myProvider.coinUsers == 0)
        _total+=(priceDouble / varRate);
      else
        _total+=(priceDouble);

      _totalProducts += item['quantity'];

    }

    lowPurchase.updateValue(_total);

    return "${lowPurchase.text}";
  }  

  nextPage()async{
    setState(() =>_statusButton = true);
    await Future.delayed(Duration(milliseconds: 150));
    setState(() =>_statusButton = false);

    Navigator.push(context, SlideLeftRoute(page: ProcessSalesPage()));
  }

}