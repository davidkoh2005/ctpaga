import 'package:ctpaga/providers/provider.dart';
import 'package:ctpaga/env.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class NavbarSales extends StatefulWidget {
  NavbarSales(this._title);
  final String _title;

  @override
  _NavbarSalesState createState() => _NavbarSalesState(this._title);
}

class _NavbarSalesState extends State<NavbarSales> {
  _NavbarSalesState(this._title);
  final String _title;

  @override
  Widget build(BuildContext context) {
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    var size = MediaQuery.of(context).size;
    return Stack(
      children: <Widget>[
        Container(
          color: Colors.white,
          width: size.width,
          height: size.height/7,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top:20),
                child: Row(
                  children: <Widget>[
                    IconButton(
                      iconSize: size.width/7,
                      icon: Icon(
                        Icons.keyboard_arrow_left,
                        color: colorLogo,
                      ),
                      onPressed: (){
                        myProvider.clickButtonMenu = 0;
                        Navigator.pop(context);
                      },
                    ),
                
                    AutoSizeText(
                      _title,
                      style: TextStyle(
                        color: colorTitleMain,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'MontserratBold',
                      ),
                      minFontSize: 17,
                      maxFontSize: 17,
                    ),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top:20, right:20),
                child: IconButton(
                  iconSize: size.width / 15,
                  icon: Icon(
                    Icons.remove_shopping_cart,
                    color: Colors.red
                  ),
                  onPressed: () => showAlert(),
                ),
              ),
            ]
          ),
        ),
      ],
    );
  }

  void showAlert(){
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Eliminar venta"),
          content: Text("¿Estas seguro que deseas eliminar todos los productos y/o servicios de esta venta?"),
          actions: <Widget>[
            TextButton(
              child: Text('SÍ'),
              onPressed: () {
                myProvider.dataPurchase = [];
                myProvider.statusRemoveShopping = true;
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('NO'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }
}