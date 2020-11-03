import 'dart:convert';

import 'package:ctpaga/animation/slideRoute.dart';
import 'package:ctpaga/views/navbar/navbar.dart';
import 'package:ctpaga/providers/provider.dart';
import 'package:ctpaga/env.dart';

import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';

class NewCategory extends StatefulWidget {
  
  @override
  _NewCategoryState createState() => _NewCategoryState();
}

class _NewCategoryState extends State<NewCategory> {
  final _formKeyCategory = new GlobalKey<FormState>();
  bool _statusButtonSave = false, _statusButton = false;
  String _name;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Navbar("Nuevo Categoría", false),
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
            buttonSave(),
            SizedBox(height:30),
          ],
        ),
      );
  }

  Widget formCommerce(){
    var size = MediaQuery.of(context).size;
    return new Form(
      key: _formKeyCategory,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 0.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "NOMBRE DEL LA CATEGORÍA",
                style: TextStyle(
                  color: colorGrey,
                  fontSize: size.width / 15,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 0.0),
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
              onChanged: (value) => value.length >=3? setState(() => _statusButton = true): setState(() => _statusButton = false) ,
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

  Widget buttonSave(){
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => saveCategory(),
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
              !_statusButton? colorGrey: _statusButtonSave? colorGrey : colorGreen,
              !_statusButton? colorGrey: _statusButtonSave? colorGrey : colorGreen,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
          ),
        child: Center(
          child: Text(
            "GUARDAR CATEGORÍA",
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

  saveCategory()async{
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    var response;
    setState(() => _statusButtonSave = true);
    await Future.delayed(Duration(milliseconds: 150));
    setState(() => _statusButtonSave = false);
    if (_formKeyCategory.currentState.validate()) {
      _formKeyCategory.currentState.save();
      try
      {
        _onLoading();
        response = await http.post(
          urlApi+"updateOrCreateCategories/",
          headers:{
            'Content-Type': 'application/json',
            'X-Requested-With': 'XMLHttpRequest',
            'authorization': 'Bearer ${myProvider.accessTokenUser}',
          },
          body: {
            "name": _name,
            "commerce_id": myProvider.dataCommercesUser[myProvider.selectCommerce].id.toString(),
          }
        ); 
        var jsonResponse = jsonDecode(response.body); 
        print(jsonResponse); 
        if (jsonResponse['statusCode'] == 201) {
          myProvider.getListCategories();
          Navigator.pop(context);
          Navigator.pop(context);
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
    return 'Ingrese nombre del la categoría correctamente';
  }
}