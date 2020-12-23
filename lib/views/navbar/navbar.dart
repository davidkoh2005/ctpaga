import 'package:ctpaga/providers/provider.dart';
import 'package:ctpaga/env.dart';

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
    var scaleFactor = MediaQuery.of(context).textScaleFactor;
    var size = MediaQuery.of(context).size;

    return Stack(
      children: <Widget>[
        Container(
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
                    GestureDetector(
                      onTap: (){
                        myProvider.clickButtonMenu = 0;
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: EdgeInsets.only(left:15, right: 15),
                        child: Container(
                          width: size.width / 10,
                          height: size.width / 10,
                          decoration: BoxDecoration(
                            color: colorGreen,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                            )
                          ),
                        )
                      ),
                    ),
                    
                    Text(
                      _title,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20 * scaleFactor,
                        fontWeight: FontWeight.bold,
                      ),
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