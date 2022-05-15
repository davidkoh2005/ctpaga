import 'package:ctpaga/animation/slideRoute.dart';
import 'package:ctpaga/views/listSalesPage.dart';
import 'package:ctpaga/providers/provider.dart';
import 'package:ctpaga/env.dart';

import 'package:auto_size_text/auto_size_text.dart';
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
                padding: EdgeInsets.only(top:10),
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
                        color: colorTitleMain,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'MontserratBold',
                      ),
                      minFontSize: 17,
                      maxFontSize: 17,
                    ),
                  ],
                ),
              ),

              Consumer<MyProvider>(
                builder: (context, myProvider, child) {
                  return Transform.scale(
                    scale: myProvider.statusTrolleyAnimation,
                    child: GestureDetector(
                      onTap: () => myProvider.dataPurchase.length > 0? Navigator.push(context, SlideLeftRoute(page: ListSalesPage())) : null,
                      child: Container(
                        alignment: Alignment.center,
                        child: Stack(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(top:15),
                              child: Image.asset(
                                "assets/icons/logoCarrito.png",
                                width: size.width/9,
                                height: size.width/9,
                                fit: BoxFit.cover
                              )
                            ),
                            
                            Padding(
                              padding: EdgeInsets.only(left: 27, top: 4),
                              child: Container(
                                width: size.width / 17,
                                height: size.width / 17,
                                decoration: BoxDecoration(
                                  color: colorLogo,
                                  shape: BoxShape.circle,
                                  ),
                                child: Center(
                                  child: AutoSizeText(
                                    showCount(myProvider),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'MontserratSemiBold',
                                    ),
                                    minFontSize: 14,
                                    maxFontSize: 14,
                                  ),
                                )
                              )
                            ),
                          ],
                        ),
                      ),
                    )
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
                  onPressed: () {
                    myProvider.statusButtonMenu = true;
                  }
                )
              )
            ]
          ),
        ),
      ],
    );

  }

  showCount(myProvider){
    int? count = 0;
    for (var item in myProvider.dataPurchase) {
      count = (count! + item!['quantity']) as int?;
    }

    return count.toString();
  }
}