import 'package:ctpaga/animation/slideRoute.dart';
import 'package:ctpaga/views/perfilPage.dart';
import 'package:ctpaga/providers/provider.dart';
import 'package:ctpaga/env.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
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
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    var size = MediaQuery.of(context).size;

    return Stack(
      children: <Widget>[
        Container(
          width: size.width,
          height: size.height/7,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top:20, right:20),
                child: IconButton(
                  iconSize: size.width / 10,
                  icon: Icon(
                    Icons.menu,
                    color: Colors.black,
                    ),
                  onPressed: () {
                    myProvider.statusButtonMenu = true;
                  }
                )
              )
            ]
          ),
        ),

        Padding(
          padding: EdgeInsets.only(top: 50, left: 30),
          child: Container(
            child: Image(
              image: AssetImage("assets/logo/logo.png"),
              width: size.width/3.5,
            ),
          )
        ),

      ],
    );

  }

}