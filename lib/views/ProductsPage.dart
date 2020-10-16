import 'package:ctpaga/animation/slideRoute.dart';
import 'package:ctpaga/views/createProductPage.dart';
import 'package:ctpaga/views/navbar/navbarProducts.dart';
import 'package:ctpaga/env.dart';

import 'package:flutter/material.dart';

class ProductsPage extends StatefulWidget {
  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {

  bool statusProducts = false, 
      statusCategory = false,
      statusButton = false;

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;

    return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            NavbarProducts(),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height:20),
                  dropdownProducts(),

                  statusProducts? listProducts()
                  : Padding(padding: EdgeInsets.all(5)),

                  dropdownCategory(),

                  statusCategory? listCategory()
                  : Padding(padding: EdgeInsets.all(15)),

                  buttonCreateProduct(),

                ]
              ),
            ),
          ],
        ),
      );
  }

  Widget dropdownProducts(){
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: 50,
      color: colorGrey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            "Productos",
            style: TextStyle(
              fontSize: size.width / 20,
            ),
          ),
          SizedBox(width:50),
          Icon(
            Icons.keyboard_arrow_down,
            color: colorGreen,
          ),
        ]
      ),
    );
  }

  Widget dropdownCategory(){
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: 50,
      color: colorGrey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            "Categoría",
            style: TextStyle(
              fontSize: size.width / 20,
            ),
          ),
          SizedBox(width:50),
          Icon(
            Icons.keyboard_arrow_down,
            color: colorGreen,
          ),
        ]
      ),
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
        setState(() => statusButton = true);
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
              statusButton? colorGreen : Colors.transparent,
              statusButton? colorGreen : Colors.transparent,
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
              color: statusButton? Colors.white : colorGreen,
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
    setState(() => statusButton = false);
    Navigator.push(context, SlideLeftRoute(page: CreateProductPage()));
  }
}