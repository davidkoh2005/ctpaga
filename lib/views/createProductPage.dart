import 'package:ctpaga/animation/slideRoute.dart';
import 'package:ctpaga/views/navbar/navbar.dart';
import 'package:ctpaga/env.dart';

import 'package:flutter/material.dart';

class CreateProductPage extends StatefulWidget {
  @override
  _CreateProductPageState createState() => _CreateProductPageState();
}

class _CreateProductPageState extends State<CreateProductPage> {

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
        height: size.height - 100,
        child: SafeArea(
          child: Scrollbar(
            child: SingleChildScrollView(
              child:Column(
                children: <Widget>[
                  showImage(),
                  

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
              statusButton? colorGreen : colorGrey,
              statusButton? colorGreen : colorGrey,
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
    Navigator.push(context, SlideLeftRoute(page: CreateProductPage()));
  }
}