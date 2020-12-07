import 'package:ctpaga/animation/slideRoute.dart';
import 'package:ctpaga/views/newCategoryPage.dart';
import 'package:ctpaga/views/navbar/navbar.dart';
import 'package:ctpaga/providers/provider.dart';
import 'package:ctpaga/env.dart';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class ListCategoryPage extends StatefulWidget {
  
  @override
  _ListCategoryPageState createState() => _ListCategoryPageState();
}

class _ListCategoryPageState extends State<ListCategoryPage> {
  final _scrollController = ScrollController();
  bool _statusButton = false;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Navbar("Seleccionar Categorías", false),
          Expanded(
            child: Container(
              child: showList(),
            )
          ),
          Padding(
            padding: EdgeInsets.only(top: 20, bottom: 50),
            child: buttonNew()
          ),
        ],
      ),
    );
  }

  Widget showList(){
    var scaleFactor = MediaQuery.of(context).textScaleFactor;
    var size = MediaQuery.of(context).size;
    return Consumer<MyProvider>(
      builder: (context, myProvider, child) {
        return Scrollbar(
          controller: _scrollController, 
          isAlwaysShown: true,
          child: ListView.builder(
            controller: _scrollController,
            padding: EdgeInsets.all(10),
            itemCount: myProvider.dataCategories.length,
            itemBuilder: (BuildContext ctxt, int index) {
              return GestureDetector(
                onTap: () {
                  if(myProvider.dataCategoriesSelect.contains(myProvider.dataCategories[index].id.toString())){
                      var selectCategory = myProvider.dataCategoriesSelect;
                      selectCategory.remove(myProvider.dataCategories[index].id.toString());
                      myProvider.dataCategoriesSelect = selectCategory;
                    }else{
                      var selectCategory = myProvider.dataCategoriesSelect;
                      selectCategory.add(myProvider.dataCategories[index].id.toString());
                      myProvider.dataCategoriesSelect = selectCategory;
                    }
                  setState(() {});
                },
                child: Container(
                  child: Card(
                    color: colorGreyOpacity,
                    shape: StadiumBorder(
                      side: BorderSide(
                        color: colorGreen,
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                          height: size.width / 5,
                          width: size.width / 5,
                          child: Visibility(
                            visible: myProvider.dataCategoriesSelect.contains(myProvider.dataCategories[index].id.toString())? true : false,
                            child: Icon(Icons.check_circle, color: colorGreen, size: size.width / 6,)
                          )
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(left: 20),
                            child: Text(
                              myProvider.dataCategories[index].name,
                              style: TextStyle(
                                fontSize: 15 * scaleFactor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ),
              );
            }
          )
        );
      }
    );
  }

  Widget buttonNew(){
    var scaleFactor = MediaQuery.of(context).textScaleFactor;
    var size = MediaQuery.of(context).size;
    return  GestureDetector(
      onTap: () => nextPage(),
      child: Container(
        width:size.width - 100,
        height: size.height / 20,
        decoration: BoxDecoration(
          border: Border.all(
            color: colorGrey, 
            width: 1.0,
          ),
          gradient: LinearGradient(
            colors: [
              _statusButton? colorGreen : Colors.transparent,
              _statusButton? colorGreen : Colors.transparent,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),

        ),
        child: Center(
          child: Text(
            "CREAR CATEGORÍA",
            style: TextStyle(
              color: _statusButton? Colors.white : colorGreen,
              fontSize: 15 * scaleFactor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  nextPage()async{
    setState(() => _statusButton = true);
    await Future.delayed(Duration(milliseconds: 150));
    setState(() => _statusButton = false);
    Navigator.push(context, SlideLeftRoute(page: NewCategoryPage()));
  }
}