import 'package:ctpaga/env.dart';
import 'package:flutter/material.dart';

class Navbar extends StatefulWidget {
  Navbar(this._title);
  final String _title;

  @override
  _NavbarState createState() => _NavbarState(this._title);
}

class _NavbarState extends State<Navbar> {
  _NavbarState(this._title);
  final String _title;

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
                      _title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: size.width / 14,
                        fontWeight: FontWeight.w900,
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
      ],
    );

  }
}