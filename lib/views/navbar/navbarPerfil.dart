import 'package:ctpaga/animation/slideRoute.dart';
import 'package:ctpaga/views/menuPage.dart';
import 'package:ctpaga/env.dart';

import 'package:flutter/material.dart';

class NavbarPerfil extends StatefulWidget {
  NavbarPerfil();

  @override
  _NavbarPerfilState createState() => _NavbarPerfilState();
}

class _NavbarPerfilState extends State<NavbarPerfil> {
  _NavbarPerfilState();

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
                      "Perfil",
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
                  onPressed: () => Navigator.push(context, SlideLeftRoute(page: MenuPage())),
                )
              )
            ]
          ),
        ),

        Container(
          alignment: Alignment.topCenter,
          padding: EdgeInsets.only(top: 60, left: 60),
          child: ClipOval(
            child: Image.asset(
              "assets/icons/perfil.png",
              width: size.width/3,
              height: size.width/3,
              fit: BoxFit.cover
            ),
          ),
        ),

      ],
    );

  }
}