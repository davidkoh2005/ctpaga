import 'package:ctpaga/animation/slideRoute.dart';
import 'package:ctpaga/views/navbar/navbar.dart';
import 'package:ctpaga/env.dart';

import 'package:flutter/material.dart';

class DepositsPage extends StatefulWidget {
  @override
  _DepositsPageState createState() => _DepositsPageState();
}

class _DepositsPageState extends State<DepositsPage> {
  List statusButton = [];
  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;

    return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Navbar("Depósitos", false),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget> [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.all(25),
                      child: Text(
                        "PROXIMO DEPÓSITO",
                        style:  TextStyle(
                          fontSize: size.width / 20,
                          color: colorGrey
                        ),
                      ),
                    ),
                  ),

                  Text(
                    "0 \$",
                    style:  TextStyle(
                      fontSize: size.width / 5,
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        width:size.width - 100,
                        height: size.height / 20,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.red,
                              Colors.red,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Text(
                            'No podemos enviarte tu dinero',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: size.width / 20,
                            ),
                          ),
                        ),
                      ),
                    )
                  ),

                  Text(
                    "Necesitamos que completes la información marcada en rojo debajo",
                    textAlign: TextAlign.center,
                    style:  TextStyle(
                      fontSize: size.width / 20,
                      color: colorGrey
                    ),
                  ),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.all(25),
                      child: Text(
                        "INFORMACIÓN DEL DEPÓSITO",
                        style:  TextStyle(
                          fontSize: size.width / 20,
                          color: colorGrey
                        ),
                      ),
                    ),
                  ),

                ]
              )
            ),
          ],
        ),
      );
  }

 

  nextPage(page, index)async{
    setState(() =>statusButton.add(index));
    await Future.delayed(Duration(milliseconds: 150));
    setState(() =>statusButton.remove(index));
    Navigator.push(context, SlideLeftRoute(page: page));
  }
}