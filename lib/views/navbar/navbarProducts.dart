import 'package:ctpaga/env.dart';
import 'package:flutter/material.dart';

class NavbarProducts extends StatefulWidget {
  NavbarProducts();

  @override
  _NavbarProductsState createState() => _NavbarProductsState();
}

class _NavbarProductsState extends State<NavbarProducts> {
  _NavbarProductsState();

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;

    return Stack(
      children: <Widget>[
        Container(
          width: size.width,
          height: size.height/5.5,
          color: colorGrey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top:40),
                child: Row(
                  children: <Widget>[
                    IconButton(
                      iconSize: 65,
                      icon: Icon(
                        Icons.keyboard_arrow_left,
                        color: colorGreen,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      "Productos",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: size.width / 14,
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top:40, right:20),
                child: IconButton(
                  iconSize: size.width / 10,
                  icon: Icon(
                    Icons.menu,
                    color: Colors.white,
                    ),
                  onPressed: null,
                )
              )
            ]
          ),
        ),

        Container(
          alignment: Alignment.topCenter,
          padding: EdgeInsets.only(top: 100, left: 120),
          child: ClipOval(
            child: Image.asset(
              "assets/icons/carrito.png",
              width: size.width/5,
              height: size.width/5,
              fit: BoxFit.cover
            ),
          ),
        ),

      ],
    );

  }
}