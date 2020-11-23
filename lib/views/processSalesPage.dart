import 'package:ctpaga/animation/slideRoute.dart';
import 'package:ctpaga/views/navbar/navbar.dart';
import 'package:ctpaga/views/loadingPage.dart';
import 'package:ctpaga/providers/provider.dart';
import 'package:ctpaga/env.dart';

import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class ProcessSalesPage extends StatefulWidget {
  @override
  _ProcessSalesPageState createState() => _ProcessSalesPageState();
}

class _ProcessSalesPageState extends State<ProcessSalesPage> {
  double _total;
  bool _statusButton = false, _statusButtonRegister = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Navbar("Nuevo Cobro", true),
          Expanded(
            child: formProcessSales(),
          ),
        ],
      ),
    );
  }

  formProcessSales(){
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    var size = MediaQuery.of(context).size;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 0.0),
          child: Container(
            child: Text(
              "COBRO DE",
              style: TextStyle(
                color: colorText,
                fontSize: size.width / 20,
              ),
            ),
          ),
        ),

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
          padding: EdgeInsets.only(top:30, bottom: 30),
          child: Text(
            "Escoge como desea cobrar:",
            style: TextStyle(
              fontSize: size.width / 20,
              color: colorText,
            ),
          ),
        ),

        Padding(
          padding: EdgeInsets.only(top: 60),
          child: buttonLink()
        ),      
        
        Padding(
          padding: EdgeInsets.only(top: 30, bottom: 60),
          child: buttonRegister()
        ),
      ],
    );
  }

  Widget buttonLink(){
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => nextPage(0),
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
              _statusButton? colorGreen : colorGrey,
              _statusButton? colorGreen : colorGrey,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
          ),
        child: Center(
          child: Text(
            "Enviar enlance de pago",
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

  Widget buttonRegister(){
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => nextPage(1),
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
              _statusButtonRegister? colorGreen : colorGrey,
              _statusButtonRegister? colorGreen : colorGrey,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
          ),
        child: Center(
          child: Text(
            "Registrar pago",
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

    }

    lowPurchase.updateValue(_total);

    return "${lowPurchase.text}";
  }  

  nextPage(status)async{
    if (status==0){
      setState(() =>_statusButton = true);
      await Future.delayed(Duration(milliseconds: 150));
      setState(() =>_statusButton = false);
      Navigator.push(context, SlideLeftRoute(page: LoadingPage()));
    }else{
      setState(() =>_statusButtonRegister = true);
      await Future.delayed(Duration(milliseconds: 150));
      setState(() =>_statusButtonRegister = false);
    }

  }

}