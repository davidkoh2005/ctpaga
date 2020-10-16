import 'package:ctpaga/animation/slideRoute.dart';
import 'package:ctpaga/views/navbar/navbar.dart';
import 'package:ctpaga/env.dart';

import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:async';

class CreateProductPage extends StatefulWidget {
  @override
  _CreateProductPageState createState() => _CreateProductPageState();
}

class _CreateProductPageState extends State<CreateProductPage> {
  final lowPrice = MoneyMaskedTextController(initialValue: 0, decimalSeparator: ',', thousandSeparator: '.',  rightSymbol: ' \$', );
  final _scrollController = ScrollController();
  final FocusNode _nameFocus = FocusNode();  
  final FocusNode _priceFocus = FocusNode();
  final FocusNode _descriptionFocus = FocusNode();

  String _name, _description;
  double _price;
  bool _statusButton = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Navbar('Nuevo Producto'),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  formProduct(),
                  buttonCreateProduct(),
                  SizedBox(height:20),
                ]
              ),
            ),
          ],
        ),
      );
  }

  Widget formProduct(){
    var size = MediaQuery.of(context).size;

    return Expanded(
      child: Container(
        width: size.width-50,
        child: SafeArea(
          child: Scrollbar(
            controller: _scrollController, 
            isAlwaysShown: true,
            child: SingleChildScrollView(
              controller: _scrollController, 
              child:Column(
                children: <Widget>[
                  showImage(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 0.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Nombre",
                        style: TextStyle(
                          color: colorGrey,
                          fontSize: size.width / 15,
                          fontWeight: FontWeight.w900,
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
                      focusNode: _nameFocus,
                      onEditingComplete: () => FocusScope.of(context).requestFocus(_priceFocus),
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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 40.0, 15.0, 0.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Precio",
                        style: TextStyle(
                          color: colorGrey,
                          fontSize: size.width / 15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 0.0),
                    child: new TextFormField(
                      controller: lowPrice,
                      maxLines: 1,
                      inputFormatters: [  
                        WhitelistingTextInputFormatter.digitsOnly,
                      ],
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      autofocus: false,
                      focusNode: _priceFocus,
                      onEditingComplete: () => FocusScope.of(context).requestFocus(_descriptionFocus),
                      onSaved: (value) => _price = double.parse(value),
                      textInputAction: TextInputAction.next,
                      cursorColor: colorGrey,
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
                    padding: const EdgeInsets.fromLTRB(15.0, 40.0, 15.0, 0.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Descrición (optional)",
                        style: TextStyle(
                          color: colorGrey,
                          fontSize: size.width / 15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 50.0),
                    child: new TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      textCapitalization:TextCapitalization.sentences,
                      autofocus: false,
                      focusNode: _descriptionFocus,
                      onEditingComplete: () => FocusScope.of(context).requestFocus(),
                      onSaved: (value) => _description = value.trim(),
                      cursorColor: colorGrey,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: colorGrey),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 40.0, 15.0, 50.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Catálogo de productos",
                        style: TextStyle(
                          color: colorGrey,
                          fontSize: size.width / 15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ]
              ),
            ),
          ),
        ),
      ),
    );
  }

  showImage(){

    var size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => print("entro"),
      child: ClipOval(
        child: Image(
          image: AssetImage("assets/icons/addPhoto.png"),
          width: size.width/4,
          height: size.width/4,
        ),
      ),
    );
  }

  Widget buttonCreateProduct(){
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        setState(() => _statusButton = true);
        nextPage();
      },
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
              _statusButton? colorGreen : colorGrey,
              _statusButton? colorGreen : colorGrey,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),

        ),
        child: Center(
          child: Text(
            "CREAR PRODUCTO",
            style: TextStyle(
              color: _statusButton? Colors.white : colorGreen,
              fontSize: size.width / 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  nextPage()async{
    await Future.delayed(Duration(milliseconds: 250));
    Navigator.push(context, SlideLeftRoute(page: CreateProductPage()));
  }

  String _validateName(String value) {
    // This is just a regular expression for name
    String p = '[a-zA-Z]';
    RegExp regExp = new RegExp(p);

    if (value.isNotEmpty && regExp.hasMatch(value) && value.length >=3) {
      // So, the name is valid
      _name = value;
      return null;
    }

    // The pattern of the name and surname didn't match the regex above.
    return 'Ingrese nombre y apellido válido';
  }
}