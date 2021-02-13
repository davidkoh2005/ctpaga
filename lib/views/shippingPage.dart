
import 'package:ctpaga/animation/slideRoute.dart';
import 'package:ctpaga/views/navbar/navbar.dart';
import 'package:ctpaga/views/newShippingPage.dart';
import 'package:ctpaga/providers/provider.dart';
import 'package:ctpaga/env.dart';

import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:io';


class ShippingPage extends StatefulWidget {
  ShippingPage(this._statusMenuBar);
  final bool _statusMenuBar;
  @override
  _ShippingPageState createState() => _ShippingPageState(this._statusMenuBar);
}

class _ShippingPageState extends State<ShippingPage> {
  _ShippingPageState(this._statusMenuBar);
  final bool _statusMenuBar;
  final _scrollControllerShipping = ScrollController();
  final _controllerDescription= TextEditingController();
  bool _statusButtonNew = false;
  String _description;

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
    setState(() {
      _description = myProvider.descriptionShipping;
      _controllerDescription.text = myProvider.descriptionShipping;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyProvider>(
      builder: (context, myProvider, child) {
        return WillPopScope(
          onWillPop: () async {
            if(myProvider.statusButtonMenu){
              myProvider.statusButtonMenu = false;
              return false;
            }else{
              myProvider.clickButtonMenu = 0;
              return true;
            }
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Visibility(
                    visible: !_statusMenuBar,
                    child: Navbar("Envíos", false)
                  ),
                  statusSend(myProvider),
                  myProvider.dataUser.statusShipping? 
                    formShipping(myProvider) 
                  :  
                  Expanded(
                    child: formMsg(myProvider)
                  ),
                ],
              )
            ),
          )
        );
      }
    );
  }

  Widget statusSend(myProvider){
    return Column(
      children: <Widget>[
        Padding(
          padding: _statusMenuBar? EdgeInsets.only(left: 30, right: 30, top:50) : EdgeInsets.only(left: 30, right: 30),
          child: Align(
            alignment: Alignment.centerLeft,
            child: AutoSizeText(
              "Envío de Productos",
              style: TextStyle(
                color: colorText,
                fontFamily: 'MontserratSemiBold',
              ),
              maxFontSize: 14,
              minFontSize: 14,
            )
          )
        ),
        Visibility(
          visible: myProvider.dataUser.statusShipping,
          child: Center(
            child: Padding(
              padding: EdgeInsets.fromLTRB(70, 30, 70, 30),
              child: buttonStatus(myProvider),
            )
          ),
        ),
        Visibility(
          visible: myProvider.dataUser.statusShipping,
          child: Container(
            padding: EdgeInsets.only(left: 40, right: 40),
            child: AutoSizeText(
              "Desactiva pedir información y cobro por envíos a tus clientes",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colorText,
              ),
              maxFontSize: 14,
              minFontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget formShipping(myProvider){
    var size = MediaQuery.of(context).size;
    return Expanded(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 0.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: AutoSizeText(
                "DESCRIPCIÓN DE ENVIOS (OPTIONAL)",
                style: TextStyle(
                  color: colorText,
                  fontFamily: 'MontserratSemiBold',
                ),
                maxFontSize: 14,
                minFontSize: 14,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
            child: new TextFormField(
              controller: _controllerDescription,
              maxLines: 1,
              textCapitalization:TextCapitalization.words,
              autofocus: false,
              onChanged: (value) {
                _description = value.trim();
                saveDescriptionStatus();
              },
              textInputAction: TextInputAction.next,
              cursorColor: colorGreen,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
              style: TextStyle(
                fontSize: 15,
                fontFamily: 'MontserratSemiBold',
              ),
            ),
          ),

          Visibility(
            visible: myProvider.dataShipping.length == 0? true : false,
            child: Container(
              height: size.height - 480,
              child: SingleChildScrollView(
                child: formMsg(myProvider)
              )
            ),
          ),

          Visibility(
            visible: myProvider.dataShipping.length == 0? false : true,
            child: Padding(
              padding: const EdgeInsets.only(top: 60.0, left: 30, right: 30, bottom: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: AutoSizeText(
                  "TARIFAS DE ENVÍO",
                  style: TextStyle(
                    color: colorText,
                    fontFamily: 'MontserratSemiBold',
                  ),
                  maxFontSize: 14,
                  minFontSize: 14,
                )
              ),
            )
          ),

          Visibility(
            visible: myProvider.dataUser.statusShipping,
            child: Expanded(
              child:Scrollbar(
                controller: _scrollControllerShipping, 
                isAlwaysShown: true,
                child: ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical, 
                  controller: _scrollControllerShipping,
                  separatorBuilder: (BuildContext context, int index) => const Divider(color: Colors.black,),
                  padding: EdgeInsets.fromLTRB(30, 0.0, 30, 30),
                  itemCount: myProvider.dataShipping.length,
                  itemBuilder:  (BuildContext ctxt, int index) {
                    return GestureDetector(
                      onTap: () =>Navigator.push(context, SlideLeftRoute(page: NewShippingPage(index))),
                      child: Padding(
                        padding: EdgeInsets.only(top: 10, bottom:10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              child: AutoSizeText(
                                myProvider.dataShipping[index].description,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'MontserratSemiBold',
                                ),
                                
                              ),
                            ),
                            Container(
                              child: AutoSizeText(
                                showPrice(myProvider.dataShipping[index].price, myProvider.dataShipping[index].coin),
                                style: TextStyle(
                                  color: colorText,
                                  fontFamily: 'MontserratSemiBold',
                                ),
                              )
                            ),
                          ],
                        )
                      )
                    );
                  }
                ),
              )    
            )
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 30, top: 30),
            child: newShipping()
          ),
        ],
      )
    );
  }

  showPrice(price, coin){
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    
    if(price == "FREE")
      return "Gratis";

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

  Widget formMsg(myProvider){
    var size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset("assets/icons/delivery.png", width: size.width / 1.5, height: size.width / 1.5),
        Visibility(
          visible: !myProvider.dataUser.statusShipping,
          child: Center(
            child: Padding(
              padding: EdgeInsets.fromLTRB(70, 30, 70, 30),
              child: buttonStatus(myProvider),
            )
          ),
        ),
        Container(
          padding: EdgeInsets.all(40),
          child: 
          myProvider.dataUser.statusShipping?
            AutoSizeText(
              "¡Agrega tus tarifas y cóbrale a tus clientes por el envío!",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colorText,
                fontFamily: 'MontserratSemiBold',
              ),
              maxFontSize: 14,
              minFontSize: 14,
            )
          :
            AutoSizeText(
              "Activa pedir información y cobrar por envios a tus clientes",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colorText,
                fontFamily: 'MontserratSemiBold',
              ),
              maxFontSize: 14,
              minFontSize: 14,
            ),
        ),
      ],
    );
  }

  Widget newShipping(){
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => nextPage(NewShippingPage(null)),
      child: Container(
        width:size.width - 100,
        height: size.height / 20,
        decoration: BoxDecoration(
          border: Border.all(
            color: colorGrey, 
            width: 1.0,
          ),
          color: _statusButtonNew? colorGreen : colorGrey,
          borderRadius: BorderRadius.circular(30),
          ),
        child: Center(
          child: AutoSizeText(
            "CREAR TARIFA",
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

  Widget buttonStatus(myProvider){
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        saveStatus();
      },
      child: Container(
        width:size.width - 100,
        height: size.height / 20,
        decoration: BoxDecoration(
          border: Border.all(
            color: colorGrey, 
            width: 1.0,
          ),
          color: !myProvider.dataUser.statusShipping? colorGreen : colorGrey,
          borderRadius: BorderRadius.circular(30),
          ),
        child: Center(
          child: AutoSizeText(
            !myProvider.dataUser.statusShipping? "ACTIVAR" : "DESACTIVAR",
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

  saveDescriptionStatus()async{
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('descriptionShipping', _description);
    myProvider.descriptionShipping = _description;
  }

  saveStatus()async{
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    var result, response, jsonResponse;
    _onLoading();
    try {
      result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        response = await http.post(
          urlApi+"updateUser",
          headers:{
            'Content-Type': 'application/json',
            'X-Requested-With': 'XMLHttpRequest',
            'authorization': 'Bearer ${myProvider.accessTokenUser}',
          },
          body: jsonEncode({
            'statusShipping': !myProvider.dataUser.statusShipping,
          }),
        ); 

        jsonResponse = jsonDecode(response.body); 
        if (jsonResponse['statusCode'] == 201) {
          myProvider.getDataUser(false, false, context);
          await Future.delayed(Duration(seconds: 2));
          Navigator.pop(context);
        } 
      }
    } on SocketException catch (_) {
      Navigator.pop(context);
      showMessage("Sin conexión a internet", false);
    } 
  }

  Future<void> _onLoading() async {
    
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            backgroundColor: Colors.white,
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(5),
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(colorGreen),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Cargando ",
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'MontserratSemiBold',
                          )
                        ),
                        TextSpan(
                          text: "...",
                          style: TextStyle(
                            color: colorGreen,
                            fontFamily: 'MontserratSemiBold',
                          )
                        ),
                      ]
                    ),
                  ),
                ),
              ],
            ),
          )
        );
      },
    );
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

  nextPage(Widget page)async{
    setState(() => _statusButtonNew = true); //add selected button color
    await Future.delayed(Duration(milliseconds: 150)); //wait time
    setState(() => _statusButtonNew = false); //delete selected button color
    Navigator.push(context, SlideLeftRoute(page: page));
  }

  

}