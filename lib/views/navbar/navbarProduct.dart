import 'package:flutter/material.dart';

class NavbarProduct extends StatefulWidget {
  NavbarProduct();

  @override
  _NavbarProductState createState() => _NavbarProductState();
}

class _NavbarProductState extends State<NavbarProduct> {
  _NavbarProductState();

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
              Padding(
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
                      "Productos",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: size.width / 14,
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