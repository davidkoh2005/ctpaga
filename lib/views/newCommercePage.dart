
import 'package:ctpaga/views/navbar/navbar.dart';
import 'package:ctpaga/providers/provider.dart';
import 'package:ctpaga/env.dart';

import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:io';

class NewCommercePage extends StatefulWidget {
  
  @override
  _NewCommercePageState createState() => _NewCommercePageState();
}

class _NewCommercePageState extends State<NewCommercePage> {
  final _formKeyCommerce = new GlobalKey<FormState>();
  final _controllerUser = TextEditingController();
  bool _statusButtonSave = false, _statusName = false, _statusUser = false;
  String _name, _userUrl;

  void initState() {
    super.initState();
    initialVariable();
  }

  void dispose(){
    super.dispose();
  }

  initialVariable(){
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    myProvider.statusUrlCommerce = false;
  }

  @override
  Widget build(BuildContext context) {
    var myProvider = Provider.of<MyProvider>(context, listen: false);
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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Navbar("Nuevo comercio", false),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: formCommerce()
                  ),
                ]
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 30),
              child: buttonSave()
            ),
          ],
        ),
      )
    );
  }

  Widget formCommerce(){
    var size = MediaQuery.of(context).size;
    return new Form(
      key: _formKeyCommerce,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 0.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "NOMBRE DEL NEGOCIO",
                style: TextStyle(
                  color: colorText,
                  fontSize: size.width / 20,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 20.0),
            child: new TextFormField(
              maxLines: 1,
              textCapitalization:TextCapitalization.words,
              autofocus: false,
              validator: _validateName,
              onSaved: (value) => _name = value.trim(),
              onChanged: (value)=> value.trim().length >3? setState(() => _statusName = true ) : setState(() => _statusName = false ),
              cursorColor: colorGreen,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color:  Colors.black),
                ),
              ),
              style: TextStyle(
                color: colorText,
                fontSize: size.width / 20,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 0.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "USUARIO",
                style: TextStyle(
                  color: colorText,
                  fontSize: size.width / 20,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 0.0),
            child: TextFormField(
              controller: _controllerUser,
              maxLength: 20,
              inputFormatters: [
                WhitelistingTextInputFormatter(RegExp("[a-z 0-9]")),
                BlacklistingTextInputFormatter(RegExp("[/\\\\ \s\b|\b\s]")),
              ],
              cursorColor: colorGreen,
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color:  Colors.black),
                ),
                prefixText: url+"/",
                prefixStyle: TextStyle(
                  color: colorText,
                  fontSize: size.width / 20,
                ),
              ),
              style: TextStyle(
                color: colorText,
                fontSize: size.width / 20,
              ),
              onChanged: (value)=> value.trim().length >3? setState(() => _statusUser = true ) : setState(() => _statusUser = false ),
              onSaved: (value) => _userUrl = value.trim(),
              validator: (value) => value.trim().length <=3? "Ingrese un usuario correctamente": null,
            ),
          ),

          Consumer<MyProvider>(
            builder: (context, myProvider, child) {
              return Visibility(
                visible: _controllerUser.text.length!=0? !myProvider.statusUrlCommerce : false,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.00, bottom: 30.0),
                  child: new Text(
                    "Usuario ingresado ya existe",
                    style: TextStyle(
                      color:Colors.red,
                    ),
                  ),
                ),
              );
            }
          ),
        ],
      )
    );
  }

  Widget buttonSave(){
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => _statusName && _statusUser? saveName(): null,
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
              _statusName && _statusUser?  _statusButtonSave? colorGrey : colorGreen : colorGrey,
              _statusName && _statusUser? _statusButtonSave? colorGrey : colorGreen : colorGrey,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
          ),
        child: Center(
          child: Text(
            "GUARDAR",
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

  verifyUrl(value)async{
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    var response, result;
    try {
      result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        response = await http.post(
          urlApi+"verifyUrl",
          headers:{
            'Content-Type': 'application/json',
            'X-Requested-With': 'XMLHttpRequest',
          },
          body: jsonEncode({
            "userUrl": value,
          }),

        ); 

        var jsonResponse = jsonDecode(response.body); 
        print(jsonResponse);
        if (jsonResponse['statusCode'] == 201) {
          myProvider.statusUrlCommerce = true;
          return true;
        }else{
          myProvider.statusUrlCommerce = false;
          return false;
        }
      }
    } on SocketException catch (_) {
      showMessage("Sin conexión a internet", false);
    }
  }

  saveName()async{
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    var response, result;
    verifyUrl(_controllerUser.text);
    setState(() => _statusButtonSave = true);
    await Future.delayed(Duration(milliseconds: 150));
    setState(() => _statusButtonSave = false);
    if (_formKeyCommerce.currentState.validate() && myProvider.statusUrlCommerce) {
      _formKeyCommerce.currentState.save();
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
              "name": _name,
              "userUrl": _userUrl,
            }),
          ); 
          var jsonResponse = jsonDecode(response.body); 
          print(jsonResponse);
          if (jsonResponse['statusCode'] == 201) {
            myProvider.getDataUser(false, false, context);
            Navigator.pop(context);
            showMessage("Guardado Correctamente", true);
            await Future.delayed(Duration(seconds: 1));
            Navigator.pop(context);
            Navigator.pop(context);
          } 
        }
      } on SocketException catch (_) {
        Navigator.pop(context);
        showMessage("Sin conexión a internet", false);
      }
      
    }
  }
  
  Future<void> showMessage(_titleMessage, _statusCorrectly) async {
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
          )
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