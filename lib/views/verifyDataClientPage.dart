import 'package:ctpaga/animation/slideRoute.dart';
import 'package:ctpaga/views/processSalesPage.dart';
import 'package:ctpaga/views/navbar/navbar.dart';
import 'package:ctpaga/views/menu/menu.dart';
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
    myProvider.statusShipping = myProvider.user.statusShipping;
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
    var scaleFactor = MediaQuery.of(context).textScaleFactor;
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
                fontSize: 15 * scaleFactor,
                fontFamily: 'MontserratSemiBold',
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
                  fontSize: 30 * scaleFactor,
                  fontFamily: 'MontserratSemiBold',
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top:5),
              child: Text(
                "por $_totalProducts ${_totalProducts >1?'artículos':'artículo'}",
                style: TextStyle(
                  fontSize: 15 * scaleFactor,
                  color: colorText,
                  fontFamily: 'MontserratSemiBold',
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
                fontSize: 25 * scaleFactor,
                color: colorText,
                fontFamily: 'MontserratSemiBold',
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
                  minRadius: size.width / 10,
                  maxRadius: size.width / 10,
                  child: Text(
                    myProvider.initialsClient,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15 * scaleFactor,
                      fontFamily: 'MontserratSemiBold',
                    ),
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
              child: Text(
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
              child: Text(
                "Nuevo cliente",
                style: TextStyle(
                  fontSize: 15 * scaleFactor,
                  color: colorText,
                  fontFamily: 'MontserratSemiBold',
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top:80),
              child: Column(
                children: [
                  Text(
                    "Mostrar Envio",
                    style: TextStyle(
                      fontSize: 15 * scaleFactor,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'MontserratSemiBold',
                    ),
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
          padding: EdgeInsets.only(top: 60, bottom: 60),
          child: buttonContinue()
        ),
      ],
    );
  }

  Widget buttonContinue(){
    var scaleFactor = MediaQuery.of(context).textScaleFactor;
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
          child: Text(
            "CONTINUAR",
            style: TextStyle(
              color: Colors.white,
              fontSize: 15 * scaleFactor,
              fontWeight: FontWeight.w500,
              fontFamily: 'MontserratSemiBold',
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