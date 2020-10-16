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