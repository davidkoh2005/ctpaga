import 'package:ctpaga/animation/slideRoute.dart';
import 'package:ctpaga/views/navbar/navbar.dart';
import 'package:ctpaga/views/newCategory.dart';
import 'package:ctpaga/providers/provider.dart';
import 'package:ctpaga/env.dart';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class ListCategory extends StatefulWidget {
  
  @override
  _ListCategoryState createState() => _ListCategoryState();
}

class _ListCategoryState extends State<ListCategory> {
  bool _statusButtonSave = false, _statusButton = false;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Navbar("Seleccionar Categorías", false),
          Expanded(
            flex: 2,
            child: Container(
              child: showList(),
            )
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: buttonNew()
          ),
          Expanded(flex:2, child: Container()),
          Padding(
            padding: EdgeInsets.only(bottom: 50),
            child: buttonSave()
          ),
        ],
      ),
    );
  }

  Widget showList(){
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    var size = MediaQuery.of(context).size;
    return ListView.builder(
      padding: EdgeInsets.all(10),
      itemCount: myProvider.dataCategories.length,
      itemBuilder: (BuildContext ctxt, int index) {
        return GestureDetector(
          onTap: () => null,
          child: Container(
            child: Card(
              color: colorGrey,
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
                      visible: true,
                      child: Icon(Icons.check_circle, color: colorGreen, size: size.width / 6,)
                    )
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: 20),
                      child: Text(myProvider.dataCategories[index].name),
                    ),
                  ),
                ],
              ),
            )
          ),
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
              fontSize: size.width / 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget buttonSave(){
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => null,
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
              _statusButtonSave? colorGreen : colorGrey,
              _statusButtonSave? colorGreen : colorGrey,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
          ),
        child: Center(
          child: Text(
            "GUARDAR CATEGORIAS",
            style: TextStyle(
              color: Colors.white,
              fontSize: size.width / 20,
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
    Navigator.push(context, SlideLeftRoute(page: NewCategory()));
  }


  String _validateName(String value) {
    // This is just a regular expression for name
    String p = '[a-zA-Z]';
    RegExp regExp = new RegExp(p);

    if (value.isNotEmpty && regExp.hasMatch(value) && value.length >=3) {
      // So, the name is valid
      return null;
    }

    // The pattern of the name didn't match the regex above.
    return 'Ingrese nombre del negocio válido';
  }
}