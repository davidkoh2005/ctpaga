import 'package:ctpaga/animation/slideRoute.dart';
import 'package:ctpaga/views/processSalesPage.dart';
import 'package:ctpaga/views/navbar/navbar.dart';
import 'package:ctpaga/views/menu/menu.dart';
import 'package:ctpaga/providers/provider.dart';
import 'package:ctpaga/env.dart';

import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:auto_size_text/auto_size_text.dart';
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
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Consumer<MyProvider>(
      builder: (context, myProvider, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Navbar("Nuevo Cobro", true),
                  Expanded(
                    child: formDataSales(),
                  ),
                ],
              ),
              
              AnimatedPositioned(
                duration: Duration(milliseconds:250),
                top: 0,
                bottom: 0,
                left: myProvider.statusButtonMenu? 0 : -size.width,
                right: myProvider.statusButtonMenu? 0 : size.width,
                child: MenuPage(),
              ),
            ],
          ),
        );
      }
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
            child: AutoSizeText(
              "COBRAR",
              style: TextStyle(
                color: colorText,
                fontFamily: 'MontserratSemiBold',
              ),
              minFontSize: 14,
              maxFontSize: 14,
            ),
          ),
        ),

        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top:20),
              child: AutoSizeText(
                showTotal(),
                textAlign: TextAlign.center,
                style:  TextStyle(
                  fontFamily: 'MontserratSemiBold',
                ),
                minFontSize: 25,
                maxFontSize: 25,
              ),
            ),
            Container(
              padding: EdgeInsets.only(top:10, bottom: 10),
              child: AutoSizeText(
                "por $_totalProducts ${_totalProducts >1?'artículos':'artículo'}",
                style: TextStyle(
                  color: colorText,
                  fontFamily: 'MontserratSemiBold',
                ),
                minFontSize: 14,
                maxFontSize: 14,
              ),
            ),
          ],
        ),

        Center(
          child: Container(
            child: AutoSizeText(
              "A",
              style: TextStyle(
                color: colorText,
                fontFamily: 'MontserratSemiBold',
              ),
              minFontSize: 20,
              maxFontSize: 20,
            ),
          ),
        ),

        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top:20),
              child: myProvider.avatarClient.length ==0? 
                CircleAvatar(
                  minRadius: size.width / 10,
                  maxRadius: size.width / 10,
                  child: AutoSizeText(
                    myProvider.initialsClient,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'MontserratSemiBold',
                    ),
                    minFontSize: 20,
                    maxFontSize: 20,
                  ),
                  backgroundColor: colorGreen,
                )
              : CircleAvatar(
                  minRadius: size.width / 10,
                  maxRadius: size.width / 10,
                  backgroundImage: MemoryImage(myProvider.avatarClient),
                )
            ),
            Container(
              padding: EdgeInsets.only(top:10),
              child: AutoSizeText(
                myProvider.nameClient,
                style: TextStyle(
                  fontSize: size.width / 17,
                  color: colorText,
                  fontFamily: 'MontserratSemiBold',
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top:10),
              child: AutoSizeText(
                "Nuevo cliente",
                style: TextStyle(
                  color: colorText,
                  fontFamily: 'MontserratSemiBold',
                ),
                minFontSize: 14,
                maxFontSize: 14,
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top:80, bottom: 40),
              child: Column(
                children: [
                  AutoSizeText(
                    "Mostrar Envio",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'MontserratSemiBold',
                    ),
                    minFontSize: 14,
                    maxFontSize: 14,
                  ),
                  Switch(
                    value: myProvider.statusShipping,
                    onChanged: (value) {
                      myProvider.statusShipping = value;
                    },
                    activeTrackColor: colorGrey,
                    activeColor: colorGreen
                  ),
                ],
              ),
            ),
          ],
        ),
        
        
        Padding(
          padding: EdgeInsets.only(top: 0, bottom: 50),
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
          color: _statusButton? colorGrey : colorGreen,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: AutoSizeText(
            "CONTINUAR",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontFamily: 'MontserratSemiBold',
            ),
            minFontSize: 14,
            maxFontSize: 14,
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