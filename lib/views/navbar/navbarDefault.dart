import 'package:flutter/material.dart';

class NavbarDefault extends StatefulWidget {
  NavbarDefault(this._statusBack, this._title, this.urlNavigator);
  final bool _statusBack;
  final String _title;
  final Widget urlNavigator;

  @override
  _NavbarDefaultState createState() => _NavbarDefaultState(this._statusBack, this._title, this.urlNavigator);
}

class _NavbarDefaultState extends State<NavbarDefault> {
  _NavbarDefaultState(this._statusBack, this._title, this.urlNavigator);
  final bool _statusBack;
  final String _title;
  final Widget urlNavigator;

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;

    return Stack(
      children: <Widget>[
        Container(
          width: size.width,
          height: size.height/5.5,
          color: Colors.grey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Visibility(
                visible: _statusBack,
                child: Padding(
                  padding: EdgeInsets.only(top:40),
                  child: Row(
                    children: <Widget>[
                       IconButton(
                        iconSize: 80,
                        icon: Icon(
                          Icons.keyboard_arrow_left,
                          color: Colors.green,
                        ),
                        onPressed: null
                      ),
                      Text(
                        _title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: size.width / 14,
                        ),
                      ),
                    ],
                  ),
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
          alignment: Alignment.topLeft,
          padding: EdgeInsets.only(top: 70, left: 50),
          child: ClipOval(
            child: Image.asset(
              "assets/icons/perfil.png",
              width: 120,
              height: 120,
              fit: BoxFit.cover
            ),
          ),
        ),

      ],
    );

  }
}