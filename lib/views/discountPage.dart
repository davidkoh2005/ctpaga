import 'package:ctpaga/animation/slideRoute.dart';
import 'package:ctpaga/views/navbar/navbar.dart';
import 'package:ctpaga/views/newDiscountPage.dart';
import 'package:ctpaga/providers/provider.dart';
import 'package:ctpaga/env.dart';


import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class DiscountPage extends StatefulWidget {
  
  @override
  _DiscountPageState createState() => _DiscountPageState();
}

class _DiscountPageState extends State<DiscountPage> {
  final _scrollControllerList = ScrollController();
  bool _statusButton = false, _statusNewDiscount = false;

  @override
  void initState() {
    super.initState();
    initialVariable();
  }

  @override
  void dispose() {
    super.dispose();
  }

  initialVariable(){
    var myProvider = Provider.of<MyProvider>(context, listen: false);

  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyProvider>(
      builder: (context, myProvider, child) {
        return Scaffold(
          body: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                !_statusNewDiscount? Navbar("Descuentos", false) : Navbar("Nuevo Descuento", false),
                
                myProvider.dataDiscount.length == 0? 
                  showMsg()
                :
                  showList(myProvider),
                
                Padding(
                  padding: EdgeInsets.only(top: 30, bottom: 30),
                  child: buttonNew()
                ),
              ],
            )
          ),
        );
      }
    );
  }

  Widget showMsg(){
    var size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(height:20),
        Image.asset(
          "assets/icons/descuento.png",
          width: size.width / 3,
          height: size.width / 3,
          color: colorGreen,
        ),
        Container(
          padding: EdgeInsets.all(40),
          child: Text(
            "¡Agrega códigos de descuento para tu tienda en línea!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: size.width / 20,
              color: colorText,
            )
          )
        ),
        SizedBox(height:20),
      ],
    );
  }

  Widget showList(myProvider){
    var size = MediaQuery.of(context).size;
    return Container(
      child:Scrollbar(
        controller: _scrollControllerList, 
        isAlwaysShown: true,
        child: ListView.separated(
          shrinkWrap: true,
          controller: _scrollControllerList,
          separatorBuilder: (BuildContext context, int index) => const Divider(color: Colors.black,),
          padding: EdgeInsets.fromLTRB(30, 0.0, 30, 30),
          itemCount: myProvider.dataDiscount.length,
          itemBuilder:  (BuildContext ctxt, int index) {
            return GestureDetector(
              onTap: () =>Navigator.push(context, SlideLeftRoute(page: NewDiscountPage(index))),
              child: Padding(
                padding: EdgeInsets.only(top: 10, bottom:10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      child: Text(
                        myProvider.dataDiscount[index].code,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: size.width / 20,
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        "${myProvider.dataDiscount[index].percentage} %",
                        style: TextStyle(
                          color: colorText,
                          fontSize: size.width / 20,
                        ),
                      )
                    ),
                  ],
                )
              )
            );
          }
        ),
      )    
    );
  }

  Widget buttonNew(){
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => nextPage(NewDiscountPage(null)),
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
              _statusButton? colorGreen : Colors.white,
              _statusButton? colorGreen : Colors.white,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
          ),
        child: Center(
          child: Text(
            "CREAR DESCUENTO",
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

  nextPage(Widget page)async{
    setState(() => _statusButton = true); //add selected button color
    await Future.delayed(Duration(milliseconds: 150)); //wait time
    setState(() => _statusButton = false); //delete selected button color
    Navigator.push(context, SlideLeftRoute(page: page));
  }
}