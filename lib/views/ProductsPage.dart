import 'package:ctpaga/animation/slideRoute.dart';
import 'package:ctpaga/views/navbar/navbar.dart';
import 'package:ctpaga/views/navbar/navbarTrolley.dart';
import 'package:ctpaga/views/createProductPage.dart';
import 'package:ctpaga/env.dart';

import 'package:flutter/material.dart';

class ProductsPage extends StatefulWidget {
  ProductsPage(this._statusCharge);
  final bool _statusCharge;
  
  @override
  _ProductsPageState createState() => _ProductsPageState(this._statusCharge);
}

class _ProductsPageState extends State<ProductsPage> {
  _ProductsPageState(this._statusCharge);
  final bool _statusCharge;
  String _statusDropdown = "";
  bool _statusButton = false,
      _statusButtonCharge = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _statusCharge? NavbarTrolley("Productos") : Navbar("Productos", true),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height:20),
                  dropdownList("Productos"),
                  //SizedBox(height:10),
                  listProducts(),
                  //SizedBox(height:10),
                  dropdownList("Categoría"),
                  //SizedBox(height:10),
                  listCategory(),

                  SizedBox(height:15),
                  buttonCreateProduct(),

                ]
              ),
            ),
            buttonCharge(),
            SizedBox(height:30),
          ],
        ),
      );
  }

  Widget dropdownList(_title){
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(top:5, bottom: 5),
      child: GestureDetector(
        onTap: () => setState(() {
          if(_statusDropdown == _title){
            _statusDropdown = "";
          }else{
            _statusDropdown = _title;
          }
        }),
        child: Container(
          padding: EdgeInsets.only(left: 30, right: 30),
          width: size.width,
          height: 50,
          color: colorGrey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                _title,
                style: TextStyle(
                  fontSize: size.width / 20,
                ),
              ),
              SizedBox(width:50),
              Icon(
                _statusDropdown == _title? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                color: colorGreen,
              ),
            ]
          ),
        )
      )
    );
  }

  Widget listProducts(){
    return Container();
  }

  Widget listCategory(){
    return Container();
  }

  Widget buttonCreateProduct(){
    var size = MediaQuery.of(context).size;
    return  GestureDetector(
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
              _statusButton? colorGreen : Colors.transparent,
              _statusButton? colorGreen : Colors.transparent,
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

  Widget buttonCharge(){
    var size = MediaQuery.of(context).size;
    return Visibility(
      visible: _statusCharge,
      child: GestureDetector(
        onTap: () {
          setState(() => _statusButtonCharge = true);
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
      )
    );
  }

  nextPage()async{
    await Future.delayed(Duration(milliseconds: 150));
    setState(() => _statusButton = false);
    Navigator.push(context, SlideLeftRoute(page: CreateProductPage()));
  }
}