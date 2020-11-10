
import 'package:ctpaga/animation/slideRoute.dart';
import 'package:ctpaga/views/navbar/navbar.dart';
import 'package:ctpaga/views/newShippingPage.dart';
import 'package:ctpaga/providers/provider.dart';
import 'package:ctpaga/env.dart';

import 'package:flutter/material.dart';


class ShippingPage extends StatefulWidget {
  
  @override
  _ShippingPageState createState() => _ShippingPageState();
}

class _ShippingPageState extends State<ShippingPage> {
  final _scrollControllerSend = ScrollController();
  bool _statusButtonNew = false, _statusButtonShipping = false;
  String _name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Navbar("Envíos", false),
            statusSend(),
            _statusButtonShipping? 
              Expanded(
                child: formShipping(),
              )
            : Expanded(
              child: formMsg(),
            ),

            Padding(
              padding: EdgeInsets.only(bottom: 30, top: 30),
              child: newShipping()
            ),
          ],
        ),
      );
  }

  Widget statusSend(){
    var size = MediaQuery.of(context).size;
    return Container(
      child: Column(
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
                "Activa pedir información y cobrar por envios a tus clientes",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: size.width / 20,
                  color: colorText,
                )
              ),
            ),
          ],
        )
    );
  }

  Widget formShipping(){
    final List<String> entries = <String>['A', 'B', 'C','A', 'B', 'C'];
    var size = MediaQuery.of(context).size;
    return Container(
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
                maxLines: 1,
                textCapitalization:TextCapitalization.words,
                autofocus: false,
                onSaved: (value) => _name = value.trim(),
                textInputAction: TextInputAction.next,
                cursorColor: colorGreen,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
            ),

            Padding(
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
            ),
            Expanded(
              child: Container(
                  child:Scrollbar(
                    controller: _scrollControllerSend, 
                    isAlwaysShown: true,
                    child: ListView.separated(
                      controller: _scrollControllerSend,
                      separatorBuilder: (BuildContext context, int index) => const Divider(color: Colors.black,),
                      padding: EdgeInsets.fromLTRB(30, 10, 30, 30),
                      itemCount: entries.length,
                      itemBuilder:  (BuildContext ctxt, int index) {
                        return Container(
                          height: 50,
                          color: Colors.blue,
                          child: Center(child: Text('Entry ${entries[index]}')),
                        );
                      }
                    ),
                  )    
                ),
            ),
          ],
        )
    );
  }

  Widget formMsg(){
    var size = MediaQuery.of(context).size;
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.local_shipping, color: colorGreen,size: size.width / 5),
          Container(
            padding: EdgeInsets.all(40),
            child: Text(
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
      ),
    );
  }

  Widget newShipping(){
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => nextPage(NewShippingPage()),
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
      onTap: () => setState(()=> _statusButtonShipping = !_statusButtonShipping),
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

  nextPage(Widget page)async{
    setState(() => _statusButtonNew = true); //add selected button color
    await Future.delayed(Duration(milliseconds: 150)); //wait time
    setState(() => _statusButtonNew = false); //delete selected button color
    Navigator.push(context, SlideLeftRoute(page: page));
  }

}