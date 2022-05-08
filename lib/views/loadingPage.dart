import 'package:ctpaga/animation/slideRoute.dart';
import 'package:ctpaga/views/shareUrlPage.dart';
import 'package:ctpaga/providers/provider.dart';
import 'package:ctpaga/env.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {

  @override
  void initState() {
    super.initState();
    sendDataSales();
  }

  @override
  void dispose() {
    super.dispose();
  }

  sendDataSales()async{
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    var response, result;
    try
    {
      result = await InternetAddress.lookup('google.com'); //verify network
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        response = await http.post(
          Uri.parse(urlApi+"newSales"),
          headers:{
            'Content-Type': 'application/json',
            'X-Requested-With': 'XMLHttpRequest',
            'authorization': 'Bearer ${myProvider.accessTokenUser}',
          },
          body: jsonEncode({
            "commerce_id": myProvider.dataCommercesUser[myProvider.selectCommerce].id.toString(),
            "sales": myProvider.dataPurchase,
            "coin": myProvider.coinUsers,
            "rate": myProvider.dataRates[0].rate,
            "nameClient": myProvider.nameClient,
            "statusShipping": myProvider.statusShipping,
            "descriptionShipping": myProvider.descriptionShipping
          }),
        ); 
        var jsonResponse = jsonDecode(response.body); 
        print(jsonResponse);
        if (jsonResponse['statusCode'] == 201) {
          myProvider.codeUrl = jsonResponse['codeUrl'];
          Navigator.push(context, SlideLeftRoute(page: ShareUrlPage()));
        }  
      }
    } on SocketException catch (_) {
      Navigator.pop(context);
      showMessage("Sin conexión a internet", false);
    }
  }


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image(
                image: AssetImage("assets/logo/logo2.png"),
                width: size.width/1.5,
              ),
              Container(
                padding: EdgeInsets.only(top:10),
                child: AutoSizeText(
                  "Cobrando...",
                  style: TextStyle(
                    color: colorText,
                    fontFamily: 'MontserratSemiBold',
                  ),
                  maxFontSize: 14,
                  minFontSize: 14,
                ),
              ),
            ],
          )
        ),
      )
    );
  }


  nextPage(status)async{
    
  }

  Future<void> showMessage(_titleMessage, _statusCorrectly) async {
    var size = MediaQuery.of(context).size;

    return showDialog(
      context: context,
      barrierDismissible: true,
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
                  color: colorLogo,
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
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'MontserratSemiBold',
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

}