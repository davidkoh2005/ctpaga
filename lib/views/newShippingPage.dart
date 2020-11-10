
import 'package:ctpaga/views/navbar/navbar.dart';
import 'package:ctpaga/providers/provider.dart';
import 'package:ctpaga/env.dart';

import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:io';

class NewShippingPage extends StatefulWidget {
  
  @override
  _NewShippingPageState createState() => _NewShippingPageState();
}

class _NewShippingPageState extends State<NewShippingPage> {
  final _formKeyShipping = new GlobalKey<FormState>();
  final FocusNode _priceFocus = FocusNode();
  var lowPrice = MoneyMaskedTextController(initialValue: 0, decimalSeparator: ',', thousandSeparator: '.',  rightSymbol: ' \$', );
  bool _statusButtonSave = false, _switchFree = false;
  int _statusCoin;
  String _description, _price;
  List _dataSend = new List();

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
    myProvider.getListCategories();
    _statusCoin = myProvider.coinUsers;

    if(_statusCoin == 0)
      lowPrice = MoneyMaskedTextController(initialValue:0, decimalSeparator: ',', thousandSeparator: '.',  leftSymbol: '\$ ', );
    else
      lowPrice = MoneyMaskedTextController(initialValue:0, decimalSeparator: ',', thousandSeparator: '.',  leftSymbol: 'Bs ', );
  
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Navbar("Nueva tarifa", false),
            Expanded(
              child: formShipping(),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 30),
              child: buttonSave()
            ),
          ],
        ),
      );
  }

  Widget formShipping(){
    var size = MediaQuery.of(context).size;
    return new Form(
      key: _formKeyShipping,
      child: ListView (
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "DESCRIPCÍON",
                style: TextStyle(
                  color: colorText,
                  fontSize: size.width / 20,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 0.0),
            child: new TextFormField(
              maxLines: 1,
              textCapitalization:TextCapitalization.words,
              autofocus: false,
              validator: _validateName,
              onSaved: (value) => _description = value.trim(),
              onChanged: (value)=> value.trim().length >3? setState(() => _dataSend.add("Description")) : setState(() =>  _dataSend.remove("Description")),
              onEditingComplete: () => FocusScope.of(context).requestFocus(_priceFocus),
              textInputAction: TextInputAction.next,
              cursorColor: colorGreen,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color:  Colors.black),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 0.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "PRECIO",
                style: TextStyle(
                  color: colorText,
                  fontSize: size.width / 20,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 0.0),
            child: new TextFormField(
              controller: lowPrice,
              readOnly: _switchFree,
              maxLines: 1,
              inputFormatters: [  
                WhitelistingTextInputFormatter.digitsOnly,
              ],
              keyboardType: TextInputType.number,
              autofocus: false,
              focusNode: _priceFocus,
              onSaved: (value) => _price = value,
              onChanged: (value) {
                setState(() {
                  if (!value.contains("0,0") && !_dataSend.contains("Price")){
                    _dataSend.add("Price");
                  }else if(value.contains("0,0") || (value.contains("00") && value.length == 2) && _dataSend.contains("Price")){
                    _dataSend.remove("Price");
                  }
                });
              },
              validator: (value) => !_dataSend.contains("Price")? 'Debe ingresar un precio Válido' : null,
              textInputAction: TextInputAction.next,
              cursorColor: colorGreen,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: size.width / 10,
                color: colorGrey,
              ),
              decoration: InputDecoration(
                enabledBorder: InputBorder.none,
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
              ),                  
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 30, right: 30),
            child: Divider(color:Colors.black,)
          ),

          Center(
            child: Padding(
              padding: EdgeInsets.only(top:30),
              child: Column(
                children: <Widget>[
                  Switch(
                    value: _switchFree ,
                    onChanged: (value) {
                      setState(() {
                        if(value && !_dataSend.contains("Price"))
                          _dataSend.add("Price");
                        
                        _switchFree = value;
                      });
                    },
                    activeTrackColor: colorGrey,
                    activeColor: colorGreen
                  ),
                  Text(
                    "Envíos gratis",
                    style: TextStyle(
                      color: colorText,
                      fontSize: size.width / 15,
                    ),
                  ),
                ],
              )
            ),
          ),
        ],
      )
    );
  }

  Widget buttonSave(){
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => saveName(),
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
              _dataSend.length ==2?  _statusButtonSave? colorGrey : colorGreen : colorGrey,
              _dataSend.length ==2? _statusButtonSave? colorGrey : colorGreen : colorGrey,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
          ),
        child: Center(
          child: Text(
            "CREAR TARIFA",
            style: TextStyle(
              color: Colors.white,
              fontSize: size.width / 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  saveName()async{
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    var response, result;
    setState(() => _statusButtonSave = true);
    await Future.delayed(Duration(milliseconds: 150));
    setState(() => _statusButtonSave = false);
    if (_formKeyShipping.currentState.validate()) {
      _formKeyShipping.currentState.save();
      try
      {
        _onLoading();
        result = await InternetAddress.lookup('google.com'); //verify network
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          response = await http.post(
            urlApi+"createCommerce",
            headers:{
              'Content-Type': 'application/json',
              'X-Requested-With': 'XMLHttpRequest',
              'authorization': 'Bearer ${myProvider.accessTokenUser}',
            },
            body: jsonEncode({
              "name": _description,
            }),
          ); 
          var jsonResponse = jsonDecode(response.body); 
          print(jsonResponse); 
          if (jsonResponse['statusCode'] == 201) {
            myProvider.getDataUser(false, context);
            Navigator.pop(context);
            Navigator.pop(context);
          }
        }
      } on SocketException catch (_) {
        Navigator.pop(context);
        showMessage("Sin conexión a internet");
      }
      
    }
  }

  Future<void> showMessage(_titleMessage) async {
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
              Padding(
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


  Future<void> _onLoading() async {
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
                          fontSize: size.width / 20,
                        )
                      ),
                      TextSpan(
                        text: "...",
                        style: TextStyle(
                          color: colorGreen,
                          fontSize: size.width / 20,
                        )
                      ),
                    ]
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _validateName(String value) {
    // This is just a regular expression for name
    String p = '[a-zA-Z]';
    RegExp regExp = new RegExp(p);

    if (value.isNotEmpty && regExp.hasMatch(value) && value.length >=3) {
      // So, the name is valid
      return null;
    }

    // The pattern of the name didn't match the regex above.
    return 'Ingrese nombre del negocio válido';
  }
}