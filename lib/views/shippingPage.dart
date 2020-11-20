
import 'package:ctpaga/animation/slideRoute.dart';
import 'package:ctpaga/views/navbar/navbar.dart';
import 'package:ctpaga/views/newShippingPage.dart';
import 'package:ctpaga/providers/provider.dart';
import 'package:ctpaga/env.dart';

import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class ShippingPage extends StatefulWidget {
  
  @override
  _ShippingPageState createState() => _ShippingPageState();
}

class _ShippingPageState extends State<ShippingPage> {
  final _scrollControllerShipping = ScrollController();
  final _controllerDescription= TextEditingController();
  bool _statusButtonNew = false, _statusButtonShipping = false, _statusMsg = true;
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
      myProvider.dataShipping.length == 0? _statusMsg = true :  _statusMsg = false;
                  
      _statusButtonShipping = myProvider.statusShipping;
      _description = myProvider.descriptionShipping;
      _controllerDescription.text = myProvider.descriptionShipping;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Navbar("Envíos", false),
              statusSend(),
              _statusButtonShipping? 
                formShipping() 
              :  
              Expanded(
                child: formMsg()
              ),
            ],
          )
        ),
      );
  }

  Widget statusSend(){
    var size = MediaQuery.of(context).size;
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 30, right: 30),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Envío de Productos",
              style: TextStyle(
                fontSize: size.width / 20,
                color: colorText,
              )
            )
          )
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.fromLTRB(70, 30, 70, 30),
            child: buttonStatus()
          )
        ),
        Container(
          padding: EdgeInsets.only(left: 40, right: 40),
          child: Text(
            "Activa pedir información y cobrar por envíos a tus clientes",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: size.width / 20,
              color: colorText,
            )
          ),
        ),
      ],
    );
  }

  Widget formShipping(){
    var size = MediaQuery.of(context).size;
    return Consumer<MyProvider>(
      builder: (context, myProvider, child) {
        return Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 0.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "DETALLES DE ENVIOS (OPTIONAL)",
                        style: TextStyle(
                          color: colorText,
                          fontSize: size.width / 22,
                        ),
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
                        fontSize: size.width / 20,
                      ),
                    ),
                  ),

                  Visibility(
                    visible: _statusMsg,
                    child: Container(
                      height: size.height - 540,
                      child: SingleChildScrollView(
                        child: formMsg()
                      )
                    ),
                  ),

                  Visibility(
                    visible: !_statusMsg,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 60.0, left: 30, right: 30, bottom: 10),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "TARIFAS DE ENVÍO",
                          style: TextStyle(
                            color: colorText,
                            fontSize: size.width / 22,
                          ),
                        )
                      ),
                    )
                  ),

                  Visibility(
                    visible: !_statusMsg,
                    child: Container(
                      height: size.height - 620,
                      child:Scrollbar(
                        controller: _scrollControllerShipping, 
                        isAlwaysShown: true,
                        child: ListView.separated(
                          shrinkWrap: true,
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
                                      child: Text(
                                        myProvider.dataShipping[index].description,
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: size.width / 20,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        showPrice(myProvider.dataShipping[index].price, myProvider.dataShipping[index].coin),
                                        style: TextStyle(
                                          color: colorText,
                                          fontSize: size.width / 20,
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
          )
        );
      }
    );
  }

  showPrice(price, coin){
    if(price == "FREE")
      return "Gratis";

    var lowPrice = new MoneyMaskedTextController(initialValue: 0, decimalSeparator: ',', thousandSeparator: '.',  leftSymbol: '\$ ', );

    if(coin == 1)
      lowPrice = new MoneyMaskedTextController(initialValue: 0, decimalSeparator: ',', thousandSeparator: '.',  leftSymbol: 'Bs ', );


    lowPrice.updateValue(double.parse(price));

    return "${lowPrice.text}";
  }

  Widget formMsg(){
    var size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.local_shipping, color: colorGreen,size: size.width / 5),
        Container(
          padding: EdgeInsets.all(40),
          child: 
          _statusButtonShipping?
            Text(
              "¡Agrega tus tarifas y cóbrale a tus clientes por el envío!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: size.width / 20,
                color: colorText,
              )
            )
          :
            Text(
              "¡Activa envíos para pedirle a tu cliente su dirección y cobrarle el envío!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: size.width / 20,
                color: colorText,
              )
            ),
        ),
        Image.asset("assets/icons/delivery.png", width: size.width / 2, height: size.width / 2)
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
          gradient: LinearGradient(
            colors: [
              _statusButtonNew? colorGreen : colorGrey,
              _statusButtonNew? colorGreen : colorGrey,
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

  Widget buttonStatus(){
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        setState(()=> _statusButtonShipping = !_statusButtonShipping);
        saveDescriptionStatus();
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
              !_statusButtonShipping? colorGreen : colorGrey,
              !_statusButtonShipping? colorGreen : colorGrey,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
          ),
        child: Center(
          child: Text(
            !_statusButtonShipping? "ACTIVAR" : "DESACTIVAR",
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

  saveDescriptionStatus()async{
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('statusShipping', _statusButtonShipping);
    prefs.setString('descriptionShipping', _description);
    myProvider.statusShipping = _statusButtonShipping;
    myProvider.descriptionShipping = _description;
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

  nextPage(Widget page)async{
    setState(() => _statusButtonNew = true); //add selected button color
    await Future.delayed(Duration(milliseconds: 150)); //wait time
    setState(() => _statusButtonNew = false); //delete selected button color
    Navigator.push(context, SlideLeftRoute(page: page));
  }

}