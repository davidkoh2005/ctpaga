import 'package:ctpaga/animation/slideRoute.dart';
import 'package:ctpaga/views/listSalesPage.dart';
import 'package:ctpaga/views/menuPage.dart';
import 'package:ctpaga/providers/provider.dart';
import 'package:ctpaga/env.dart';

import 'package:provider/provider.dart';
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
          height: size.height/7,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top:10),
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

              Consumer<MyProvider>(
                builder: (context, myProvider, child) {
                  return GestureDetector(
                    onTap: () => myProvider.dataPurchase.length > 0? Navigator.push(context, SlideLeftRoute(page: ListSalesPage())) : null,
                    child: Container(
                      alignment: Alignment.center,
                      child: Stack(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(top:10),
                            child: Image.asset(
                              "assets/icons/logoCarrito.png",
                              width: size.width/7,
                              height: size.width/7,
                              fit: BoxFit.cover
                            )
                          ),
                          
                          Padding(
                            padding: EdgeInsets.only(left: 34),
                            child: Container(
                              width: size.width / 15,
                              height: size.width / 15,
                              decoration: BoxDecoration(
                                color: colorGreen,
                                shape: BoxShape.circle,
                                ),
                              child: Center(
                                child: Text(
                                  showCount(myProvider),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: size.width / 30,
                                    fontWeight: FontWeight.bold,
                                  )
                                ),
                              )
                            )
                          ),
                        ],
                      ),
                    ),
                  );
                }
              ),

              Padding(
                padding: EdgeInsets.only(top:10, right:20),
                child: IconButton(
                  iconSize: size.width / 10,
                  icon: Icon(
                    Icons.menu,
                    color: Colors.black,
                    ),
                  onPressed: () => Navigator.push(context, SlideLeftRoute(page: MenuPage())),
                )
              )
            ]
          ),
        ),
      ],
    );

  }

  showCount(myProvider){
    int count = 0;
    for (var item in myProvider.dataPurchase) {
      count += item['count'];
    }

    return count.toString();
  }
}