import 'package:ctpaga/animation/slideRoute.dart';
import 'package:ctpaga/views/navbar/navbar.dart';
import 'package:ctpaga/env.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NewCommerce extends StatefulWidget {
  
  @override
  _NewCommerceState createState() => _NewCommerceState();
}

class _NewCommerceState extends State<NewCommerce> {
  final _formKeyCommerce = new GlobalKey<FormState>();
  bool _statusButtonCharge = false, _statusButton = false;
  String _name;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
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
                  SizedBox(height:20),
                  formCommerce(),
                ]
              ),
            ),
            buttonNext(),
            SizedBox(height:30),
          ],
        ),
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
                  fontSize: size.width / 15,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 0.0),
            child: new TextFormField(
              maxLines: 1,
              textCapitalization:TextCapitalization.words,
              inputFormatters: [
                WhitelistingTextInputFormatter(RegExp("[a-zA-Z\ áéíóúÁÉÍÓÚñÑ\s]")),
                BlacklistingTextInputFormatter(RegExp("[/\\\\]")),
              ], 
              autofocus: false,
              validator: _validateName,
              onSaved: (value) => _name = value.trim(),
              textInputAction: TextInputAction.next,
              cursorColor: colorGrey,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: colorGrey),
                ),
              ),
            ),
          ),
        ],
      )
    );
  }

  Widget buttonNext(){
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => null,
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
              _statusButtonCharge? colorGreen : colorGrey,
              _statusButtonCharge? colorGreen : colorGrey,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
          ),
        child: Center(
          child: Text(
            "SIGUIENTE",
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

  /* nextPage()async{
    await Future.delayed(Duration(milliseconds: 150));
    setState(() => _statusButton = false);
    Navigator.push(context, SlideLeftRoute(page: CreateProductPage()));
  } */

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