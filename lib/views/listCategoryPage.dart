import 'package:ctpaga/animation/slideRoute.dart';
import 'package:ctpaga/views/newCategoryPage.dart';
import 'package:ctpaga/views/navbar/navbar.dart';
import 'package:ctpaga/providers/provider.dart';
import 'package:ctpaga/env.dart';

import 'package:auto_size_text/auto_size_text.dart';
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
    var size = MediaQuery.of(context).size;
    return Consumer<MyProvider>(
      builder: (context, myProvider, child) {
        return Scrollbar(
          controller: _scrollController, 
          trackVisibility: true,
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

                    _showCategories();
                },
                child: Container(
                  child: Card(
                    color: colorGreyOpacity,
                    shape: StadiumBorder(
                      side: BorderSide(
                        color: colorLogo,
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
                            child: Icon(Icons.check_circle, color: colorLogo, size: size.width / 8,)
                          )
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(left: 10),
                            child: AutoSizeText(
                              myProvider.dataCategories[index].name,
                              style: TextStyle(
                                fontFamily: 'MontserratSemiBold',
                              ),
                              maxFontSize: 14,
                              minFontSize: 14,
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
          color: _statusButton? colorLogo : Colors.transparent,
          borderRadius: BorderRadius.circular(30),

        ),
        child: Center(
          child: AutoSizeText(
            "CREAR CATEGORÍA",
            style: TextStyle(
              color: _statusButton? Colors.white : colorLogo,
              fontWeight: FontWeight.w500,
              fontFamily: 'MontserratSemiBold',
            ),
            maxFontSize: 14,
            minFontSize: 14,
          ),
        ),
      ),
    );
  }

  _showCategories(){
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    myProvider.getCategoryProduct = '';
    myProvider.getSelectCategoryProduct = '';
    if(myProvider.dataCategoriesSelect.length >0){
      for (var item in myProvider.dataCategories) {
        if(myProvider.dataCategoriesSelect.contains(item.id.toString())){
            myProvider.getSelectCategoryProduct += item.id.toString()+', ';
            myProvider.getCategoryProduct += item.name+', ';
          }
      }
    }

    if(myProvider.getCategoryProduct.length >0){
      myProvider.getCategoryProduct = myProvider.getCategoryProduct.substring(0, myProvider.getCategoryProduct.length - 2);
      myProvider.getSelectCategoryProduct = myProvider.getSelectCategoryProduct.substring(0, myProvider.getSelectCategoryProduct.length - 2);
    }else{
      myProvider.getSelectCategoryProduct = "";
    }
  }

  nextPage()async{
    setState(() => _statusButton = true);
    await Future.delayed(Duration(milliseconds: 150));
    setState(() => _statusButton = false);
    Navigator.push(context, SlideLeftRoute(page: NewCategoryPage()));
  }
}