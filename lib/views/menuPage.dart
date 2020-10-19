import 'package:ctpaga/animation/slideRoute.dart';
import 'package:ctpaga/views/navbar/navbar.dart';
import 'package:ctpaga/env.dart';

import 'package:flutter/material.dart';

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  List statusButton = [];
  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;

    return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Navbar("Menu", false),
            Expanded(
              child: ListView.builder(
                itemCount: listMenu.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () => nextPage(listMenu[index]['page'], index),
                    child: Stack(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top:5),
                          child: Container(
                            width: size.width,
                            color: statusButton.contains(index)? colorGreen : colorGrey,
                            height: 45,
                            child: Container(
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left:25),
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: listMenu[index]['icon'] == ''? Colors.transparent : Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(top:15, bottom: 15, left: 10, right: 10),
                              child: Visibility(
                                visible: listMenu[index]['icon'] == ''? false : true,
                                child: Image.asset(
                                  listMenu[index]['icon'],
                                  color: statusButton.contains(index)? colorGreen : Colors.black,
                                )
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left:100, top: 20),
                          child: Text(
                            listMenu[index]['title'],
                            style: TextStyle(
                              fontSize: size.width / 20,
                              color: statusButton.contains(index)? Colors.white : Colors.black,
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
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