import 'package:ctpaga/animation/slideRoute.dart';
import 'package:ctpaga/views/navbar/navbarSales.dart';
import 'package:ctpaga/views/modifySalesPage.dart';
import 'package:ctpaga/views/newSalesPage.dart';
import 'package:ctpaga/providers/provider.dart';
import 'package:ctpaga/env.dart';

import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class ListSalesPage extends StatefulWidget {
  
  @override
  _ListSalesPageState createState() => _ListSalesPageState();
}

class _ListSalesPageState extends State<ListSalesPage> {
  final _scrollController = ScrollController();
  double _total = 0.0;
  bool _statusButtonCharge = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<MyProvider>(
        builder: (context, myProvider, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              NavbarSales("Nueva Venta"),
              Container(
                child: showList(myProvider),
              ),
              Padding(
                padding: EdgeInsets.only(top: 30, bottom:30),
                child: buttonCharge(myProvider)
              ),
            ],
          );
        }
      ),
    );
  }

  Widget showList(myProvider){
    var size = MediaQuery.of(context).size;
    return Container(
      height: myProvider.dataPurchase.length < 8? (myProvider.dataPurchase.length*(size.height-120)/7) : size.height-230,
      child: Scrollbar(
        controller: _scrollController, 
        trackVisibility: true,
        child: ListView.builder(
          shrinkWrap: true,
          controller: _scrollController,
            padding: EdgeInsets.all(10),
            itemCount: myProvider.dataPurchase.length,
            itemBuilder: (BuildContext ctxt, int index) {
              return GestureDetector(
                onTap: () {
                  myProvider.positionModify = index;
                  myProvider.typePositionModify = myProvider.dataPurchase[index]['type'];
                  nextPage(ModifySalesPage());
                },
                child: Container(
                  height: size.width / 5,
                  width: size.width / 5,
                  child: Card(
                    color: colorGreyOpacity,
                    shape: StadiumBorder(
                      side: BorderSide(
                        color: colorLogo,
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 30),
                          child: Container(
                            width: size.width / 10,
                            height: size.width / 10,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: AutoSizeText(
                                myProvider.dataPurchase[index]['quantity'].toString(),
                                style: TextStyle(
                                  fontFamily: 'MontserratSemiBold',
                                ),
                                maxFontSize: 14,
                                minFontSize: 14,
                              )
                            ),
                          )
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(left: 20),
                            child: AutoSizeText(
                              myProvider.dataPurchase[index]['data'].name.length != 0? myProvider.dataPurchase[index]['data'].name :  "Sin descripción",
                              style: TextStyle(
                                fontFamily: 'MontserratSemiBold',
                              ),
                              maxFontSize: 14,
                              minFontSize: 14,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(right: 20),
                            child: AutoSizeText(
                              showPrice(myProvider.dataPurchase[index]['data'].price, myProvider.dataPurchase[index]['data'].coin),
                              style: TextStyle(
                                fontFamily: 'MontserratSemiBold',
                              ),
                              maxFontSize: 14,
                              minFontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    )
                  )
                ),
              );
            }
        ),
      )
    );
  }

  showPrice(price, coin){
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    var lowPrice = new MoneyMaskedTextController(initialValue: 0, decimalSeparator: ',', thousandSeparator: '.',  leftSymbol: '\$ ', );
    double priceDouble = double.parse(price);
    double varRate = double.parse(myProvider.dataRates[0].rate);

    if(myProvider.coinUsers  == 1)
      lowPrice = new MoneyMaskedTextController(initialValue: 0, decimalSeparator: ',', thousandSeparator: '.',  leftSymbol: 'Bs ', );

    if(coin == 0 && myProvider.coinUsers == 1)
      lowPrice.updateValue(priceDouble * varRate);
    else if(coin == 1 && myProvider.coinUsers == 0)
      lowPrice.updateValue(priceDouble / varRate);
    else
      lowPrice.updateValue(priceDouble);

    return "${lowPrice.text}";
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

  Widget buttonCharge(myProvider){
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        if(myProvider.dataPurchase.length != 0){
          setState(() => _statusButtonCharge = true);
          nextPage(NewSalesPage());
        }
      },
      child: Container(
        width:size.width - 100,
        height: size.height / 20,
        decoration: BoxDecoration(
          border: Border.all(
            color: colorGrey, 
            width: 1.0,
          ),
          color: myProvider.dataPurchase.length != 0? _statusButtonCharge? colorGrey : colorLogo : colorGrey,
          borderRadius: BorderRadius.circular(30),
          ),
        child: Center(
          child: Container(
            child: AutoSizeText(
              myProvider.dataPurchase.length == 0? "COBRAR" : "COBRAR ${showTotal()}",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              maxFontSize: 14,
              minFontSize: 14,
            ),
          ),
        ),
      ),
    );

  }

  nextPage(page)async{
    await Future.delayed(Duration(milliseconds: 150));
    setState(() =>_statusButtonCharge = false);

    Navigator.push(context, SlideLeftRoute(page: page));
  }

}