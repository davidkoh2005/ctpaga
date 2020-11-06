import 'package:ctpaga/animation/slideRoute.dart';
import 'package:ctpaga/views/menuPage.dart';
import 'package:ctpaga/env.dart';

import 'package:flutter/material.dart';

class NavbarTrolley extends StatefulWidget {
  NavbarTrolley(this._title);
  final String _title;

  @override
  _NavbarTrolleyState createState() => _NavbarTrolleyState(this._title);
}

class _NavbarTrolleyState extends State<NavbarTrolley> {
  _NavbarTrolleyState(this._title);
  final String _title;

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;

    return Stack(
      children: <Widget>[
        Container(
          width: size.width,
          height: size.height/5.5,
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
                      _title,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: size.width / 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                alignment: Alignment.center,
                child: Stack(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top:20),
                      child: Image.asset(
                        "assets/icons/logoCarrito.png",
                        width: size.width/7,
                        height: size.width/7,
                        fit: BoxFit.cover
                      )
                    ),

                    Padding(
                      padding: EdgeInsets.only(top: 8, left: 34),
                      child: Container(
                        width: size.width / 15,
                        height: size.width / 15,
                        decoration: BoxDecoration(
                          color: colorGreen,
                          shape: BoxShape.circle,
                          ),
                        child: Center(
                          child: Text(
                            "0",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: size.width / 30,
                              fontWeight: FontWeight.bold,
                            )
                          ),
                        )
                      )
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
                    color: Colors.black,
                    ),
                  onPressed: () => Navigator.push(context, SlideLeftRoute(page: MenuPage())),
                )
              )
            ]
          ),
        ),
      ],
    );

  }
}