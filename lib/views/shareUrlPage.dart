import 'package:ctpaga/animation/slideRoute.dart';
import 'package:ctpaga/views/mainMenuBar.dart';
import 'package:ctpaga/providers/provider.dart';
import 'package:ctpaga/env.dart';
import 'package:flutter/services.dart';

import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:share/share.dart';
import 'dart:io';

class ShareUrlPage extends StatefulWidget {
  @override
  _ShareUrlPageState createState() => _ShareUrlPageState();
}

class _ShareUrlPageState extends State<ShareUrlPage> {
  var lowPurchase = new MoneyMaskedTextController(initialValue: 0, decimalSeparator: ',', thousandSeparator: '.',  leftSymbol: '\$ ', );
  double _total;
  int _statusButtonNetworks = 0;
  bool _statusButtonReady = false;

  @override
  Widget build(BuildContext context) {
    
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: showData(),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children : [
                    Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: buttonNetworks("WhatsApp", 1)
                    ),      
                    
                    Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: buttonNetworks("Compartir", 2)
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 30, bottom: 30),
                      child: buttonNetworks("Copiar Link", 3)
                    ),
                  ]
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 30, bottom: 60),
                child: buttonReady()
              ),
            ],
          )
        ),
      )
    );
  }

  showData(){
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
          child: Container(
            child: AutoSizeText(
              "COBRO DE",
              style: TextStyle(
                color: colorText,
                fontFamily: 'MontserratSemiBold',
              ),
              maxFontSize: 14,
              minFontSize: 14,
            ),
          ),
        ),

        Container(
          padding: EdgeInsets.only(top:20),
          child: AutoSizeText(
            showTotal(),
            textAlign: TextAlign.center,
            style:  TextStyle(
              fontFamily: 'MontserratSemiBold',
            ),
            maxFontSize: 25,
            minFontSize: 25,
          ),
        ),

        Container(
          padding: EdgeInsets.only(top:40, bottom: 5),
          child: AutoSizeText(
            "${myProvider.nameClient} puede pagar en:",
            style: TextStyle(
              color: colorText,
              fontFamily: 'MontserratSemiBold',
            ),
            maxFontSize: 17,
            minFontSize: 17,
          ),
        ),

        Padding(
          padding: EdgeInsets.only(top: 5),
          child: GestureDetector(
            onTap: () => launch("https://$url/${myProvider.dataCommercesUser[myProvider.selectCommerce].userUrl}/${myProvider.codeUrl}"),
            child: AutoSizeText(
              "https://$url/${myProvider.dataCommercesUser[myProvider.selectCommerce].userUrl}/${myProvider.codeUrl}",
              style: TextStyle(
                color: colorGreen,
                fontWeight: FontWeight.w500,
                fontFamily: 'MontserratSemiBold',
              ),
              maxFontSize: 17,
              minFontSize: 17,
            ),
          )
        ),

        Container(
          padding: EdgeInsets.only(top:40, bottom: 5),
          child: AutoSizeText(
            "Escoge como enviar",
            style: TextStyle(
              color: colorText,
              fontFamily: 'MontserratSemiBold',
            ),
            maxFontSize: 17,
            minFontSize: 17,
          ),
        ),
        Container(
          child: AutoSizeText(
            "tu cobro:",
            style: TextStyle(
              color: colorText,
              fontFamily: 'MontserratSemiBold',
            ),
            maxFontSize: 17,
            minFontSize: 17,
          ),
        ),
      ],
    );
  }

  Widget buttonNetworks(_title, index){
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => nextPage(index),
      child: Container(
        width:size.width - 100,
        height: size.height / 20,
        decoration: BoxDecoration(
          border: Border.all(
            color: colorGreen, 
            width: 1.0,
          ),
          color: _statusButtonNetworks == index? colorGreen : Colors.white,
          borderRadius: BorderRadius.circular(30),
          ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              "assets/icons/${_title.replaceAll(' ','-')}.png",
              width: size.width / 15,
              height: size.width / 15,
              color: _statusButtonNetworks == index? Colors.white : colorGreen,
            ),
            SizedBox(width: 15,),
            AutoSizeText(
              _title,
              style: TextStyle(
                color: _statusButtonNetworks == index? Colors.white : colorGreen,
                fontWeight: FontWeight.w500,
                fontFamily: 'MontserratSemiBold',
              ),
              maxFontSize: 14,
              minFontSize: 14,
            ),
          ],
        ),
      ),
    );
  }

  Widget buttonReady(){
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
          color: _statusButtonReady? colorGrey : colorGreen,
          borderRadius: BorderRadius.circular(30),
          ),
        child: Center(
          child: AutoSizeText(
            "LISTO",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontFamily: 'MontserratSemiBold',
            ),
            maxFontSize: 14,
            minFontSize: 14,
          ),
        ),
      ),
    );
  }

  showTotal(){
    var myProvider = Provider.of<MyProvider>(context, listen: false);
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

  nextPage(index)async{
    if(index == 0){
      setState(() =>_statusButtonReady = true);
      await Future.delayed(Duration(milliseconds: 150));
      setState(() =>_statusButtonReady = false);
      Navigator.pushReplacement(context, SlideLeftRoute(page: MainMenuBar()));
    }else{
      setState(() =>_statusButtonNetworks = index);
      await Future.delayed(Duration(milliseconds: 150));
      setState(() =>_statusButtonNetworks = 0);

      sharedAutoSizeText(index);

    }

  }

  void sharedAutoSizeText(index) async{
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    var nameCompany = myProvider.dataCommercesUser[myProvider.selectCommerce].name;
    var userCompany = myProvider.dataCommercesUser[myProvider.selectCommerce].userUrl;
    var codeUrl = myProvider.codeUrl;

    var link = "https://$url/$userCompany/$codeUrl";
    var msg = "💰 Total: ${lowPurchase.text} mas entrega \nCompleta tu pedido a $nameCompany aquí: $link";

    if (index ==1){
      String urlWeb() {
        if (Platform.isIOS) {
            return "whatsapp://wa.me/?text=$msg";
          } else {
            return "whatsapp://send?text=$msg";
          }
      }

      if (await canLaunch(urlWeb())) {
        await launch(urlWeb());
      } else {
        throw 'Could not launch ${urlWeb()}';
      }
    }else if(index == 2)
      Share.share(msg);
    else
      Clipboard.setData(ClipboardData(text: link)).then((result) {
        Toast.show(
          "Link Copiado!",
          context,
          duration: Toast.LENGTH_LONG,
          gravity:  Toast.BOTTOM,
          textColor: Colors.white,
          backgroundColor: Colors.black,
        );
      });
  }

}