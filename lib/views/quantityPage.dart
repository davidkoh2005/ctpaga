import 'package:ctpaga/animation/slideRoute.dart';
import 'package:ctpaga/views/navbar/navbarTrolley.dart';
import 'package:ctpaga/views/newProductPage.dart';
import 'package:ctpaga/providers/provider.dart';
import 'package:ctpaga/env.dart';

import 'package:numeric_keyboard/numeric_keyboard.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QuantityPage extends StatefulWidget {
  @override
  _QuantityPageState createState() => _QuantityPageState();
}

class _QuantityPageState extends State<QuantityPage> {
  final FocusNode _priceFocus = FocusNode();
  String _description, _price='';
  bool _statusButton = false,
      _statusButtonCharge = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            NavbarTrolley("Monto"),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  formQuantity(),
                ]
              ),
            ),
          ],
        ),
      );
  }

  Widget formQuantity(){
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    var size = MediaQuery.of(context).size;

    return Expanded(
      child: Container(
        width: size.width,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(15.0, 30.0, 15.0, 0.0),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: myProvider.coinUsers == 0? "\$ ": "Bs ", 
                        style: TextStyle(
                        color: colorGrey,
                        fontSize: size.width / 6.5,
                        fontWeight: FontWeight.w800,
                        ),
                      ),
                      TextSpan(
                        text: _price.isEmpty? "0": _price,
                        style: TextStyle(
                        color: colorGrey,
                        fontSize: size.width / 6.5,
                        fontWeight: FontWeight.w800,
                        ),
                      ),
                    ]
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 10.0),
                child: new TextFormField(
                  maxLines: 1,
                  textCapitalization:TextCapitalization.words,
                  inputFormatters: [
                    WhitelistingTextInputFormatter(RegExp("[a-zA-Z\ áéíóúÁÉÍÓÚñÑ\s]")),
                    BlacklistingTextInputFormatter(RegExp("[/\\\\]")),
                  ], 
                  autofocus: false,
                  onEditingComplete: () => FocusScope.of(context).requestFocus(_priceFocus),
                  onSaved: (value) => _description = value.trim(),
                  textInputAction: TextInputAction.next,
                  cursorColor: colorGreen,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    fillColor: Colors.blue,
                    enabledBorder: InputBorder.none,
                    hintText: "AGREGAR DESCRIPCIÓN",
                    hintStyle: TextStyle(
                      color: colorGrey,
                      fontSize: size.width / 20,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                  ),
                  style: TextStyle(
                    color: colorGrey,
                    fontSize: size.width / 20,
                  ),
                ),
              ),

              GestureDetector(
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
                      "AGREGAR VENTAS",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: size.width / 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),

              numPad(),
              buttonCharge(),
              SizedBox(height:80),

            ]
          ),
        ),
      ),
    );
  }

  Widget numPad(){
    var size = MediaQuery.of(context).size;

    return NumericKeyboard(
      onKeyboardTap: _onKeyboardTap,
      textColor: Colors.black54,
      rightButtonFn: () {
        if(_price.length >0){
          setState(() {
          _price = _price.substring(0, _price.length - 1);
        });
        }
      },
      rightIcon: Icon(
        Icons.backspace,
        color: Colors.black54,
      ),
      
      leftButtonFn: () {
        if(!_price.contains('.')){
          setState(() {
            _price = _price+".";
          });
        }
      },
      
      leftIcon: Icon(
        Icons.brightness_1,
        size: size.width / 40,
        color: Colors.black54,
      ),
    );
  }

  _onKeyboardTap(String value) {
    setState(() {
      _price = _price + value;
    });
  }


  Widget buttonCharge(){
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        setState(() => _statusButtonCharge = true);
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
            "COBRAR",
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

  nextPage()async{
    await Future.delayed(Duration(milliseconds: 150));
    setState(() => _statusButtonCharge = false);
    //Navigator.push(context, SlideLeftRoute(page: CreateProductPage()));
  }
}