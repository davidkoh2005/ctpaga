import 'package:ctpaga/animation/slideRoute.dart';
import 'package:ctpaga/views/mainMenuBar.dart';
import 'package:ctpaga/providers/provider.dart';
import 'package:ctpaga/env.dart';
import 'package:flutter/services.dart';

import 'package:flutter_masked_text/flutter_masked_text.dart';
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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: showUrls(),
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

  showUrls(){
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    var size = MediaQuery.of(context).size;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(30.0, 100.0, 30.0, 0.0),
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
          padding: EdgeInsets.only(top:20),
          child: Text(
            showTotal(),
            textAlign: TextAlign.center,
            style:  TextStyle(
              fontSize: size.width / 10,
            ),
          ),
        ),

        Container(
          padding: EdgeInsets.only(top:40, bottom: 5),
          child: Text(
            "${myProvider.nameClient} puede pagar en:",
            style: TextStyle(
              fontSize: size.width / 17,
              color: colorText,
            ),
          ),
        ),

        Padding(
          padding: EdgeInsets.only(top: 5),
          child: GestureDetector(
            onTap: () => launch("ctpaga.compralotodo.com"),
            child: Text(
              "ctpaga.compralotodo.com",
              style: TextStyle(
                color: colorGreen,
                fontSize: size.width / 18,
                fontWeight: FontWeight.w500,
              ),
          ),
          )
        ),

        Container(
          padding: EdgeInsets.only(top:40, bottom: 5),
          child: Text(
            "Escoge como enviar",
            style: TextStyle(
              fontSize: size.width / 17,
              color: colorText,
            ),
          ),
        ),
        Container(
          child: Text(
            "tu cobro:",
            style: TextStyle(
              fontSize: size.width / 17,
              color: colorText,
            ),
          ),
        ),

        Padding(
          padding: EdgeInsets.only(top: 60),
          child: buttonNetworks("WhatsApp", 1)
        ),      
        
        Padding(
          padding: EdgeInsets.only(top: 30),
          child: buttonNetworks("Compartir", 2)
        ),
        Padding(
          padding: EdgeInsets.only(top: 30, bottom: 60),
          child: buttonNetworks("Copiar Link", 3)
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
          gradient: LinearGradient(
            colors: [
              _statusButtonNetworks == index? colorGreen : Colors.white,
              _statusButtonNetworks == index? colorGreen : Colors.white,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
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
            Text(
              _title,
              style: TextStyle(
                color: _statusButtonNetworks == index? Colors.white : colorGreen,
                fontSize: size.width / 18,
                fontWeight: FontWeight.w500,
              ),
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
          gradient: LinearGradient(
            colors: [
              _statusButtonReady? colorGrey : colorGreen,
              _statusButtonReady? colorGrey : colorGreen,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
          ),
        child: Center(
          child: Text(
            "LISTO",
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

      sharedText(index);

    }

  }

  void sharedText(index) async{
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    var nameCompany = myProvider.dataCommercesUser[myProvider.selectCommerce].name;
    var userCompany = myProvider.dataCommercesUser[myProvider.selectCommerce].userUrl;
    var codeUrl = myProvider.codeUrl;

    var link = "http://$url/$userCompany/$codeUrl";
    var msg = "💰 Total:${lowPurchase.text} mas entrega \nCompleta tu pedido a $nameCompany aquí: $link";

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