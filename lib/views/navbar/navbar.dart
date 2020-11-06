import 'package:ctpaga/animation/slideRoute.dart';
import 'package:ctpaga/views/menuPage.dart';
import 'package:ctpaga/env.dart';

import 'package:flutter/material.dart';

class Navbar extends StatefulWidget {
  Navbar(this._title, this._statusMenu);
  final String _title;
  final bool _statusMenu;

  @override
  _NavbarState createState() => _NavbarState(this._title, this._statusMenu);
}

class _NavbarState extends State<Navbar> {
  _NavbarState(this._title, this._statusMenu);
  final String _title;
  final bool _statusMenu;

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

              Visibility(
                visible: _statusMenu,
                child: Padding(
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
              )
            ]
          ),
        ),
      ],
    );

  }
}