import 'package:ctpaga/providers/provider.dart';
import 'package:ctpaga/env.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:provider/provider.dart';
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
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    var size = MediaQuery.of(context).size;

    return Stack(
      children: <Widget>[
        Container(
          color: Colors.white,
          width: size.width,
          height: size.height/7,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top:20),
                child: Row(
                  children: <Widget>[
                    IconButton(
                      iconSize: size.width/7,
                      icon: Icon(
                        Icons.keyboard_arrow_left,
                        color: colorLogo,
                      ),
                      onPressed: (){
                        myProvider.clickButtonMenu = 0;
                        Navigator.pop(context);
                      },
                    ),
                    
                    AutoSizeText(
                      _title,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'MontserratSemiBold',
                      ),
                      minFontSize: 17,
                      maxFontSize: 17,
                    ),
                  ],
                ),
              ),

              Visibility(
                visible: _statusMenu,
                child: Padding(
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
              )
            ]
          ),
        ),
      ],
    );

  }
}