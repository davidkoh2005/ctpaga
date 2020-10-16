import 'package:ctpaga/env.dart';
import 'package:flutter/material.dart';

class NavbarMain extends StatefulWidget {
  NavbarMain();

  @override
  _NavbarMainState createState() => _NavbarMainState();
}

class _NavbarMainState extends State<NavbarMain> {
  _NavbarMainState();

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
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              
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
          alignment: Alignment.topLeft,
          padding: EdgeInsets.only(top: 60, left: 50),
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