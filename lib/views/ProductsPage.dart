import 'package:ctpaga/animation/slideRoute.dart';
import 'package:ctpaga/views/navbar/navbarTrolley.dart';
import 'package:ctpaga/views/newProductPage.dart';
import 'package:ctpaga/views/navbar/navbar.dart';
import 'package:ctpaga/providers/provider.dart';
import 'package:ctpaga/env.dart';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class ProductsPage extends StatefulWidget {
  ProductsPage(this._statusCharge);
  final bool _statusCharge;
  
  @override
  _ProductsPageState createState() => _ProductsPageState(this._statusCharge);
}

class _ProductsPageState extends State<ProductsPage> {
  _ProductsPageState(this._statusCharge);
  final _scrollControllerProducts = ScrollController();
  final _scrollControllerCategories = ScrollController();
  final bool _statusCharge;
  String _statusDropdown = "";
  int _selectCategories = 0, _idSelectCategories=0;
  bool _statusButton = false,
      _statusButtonCharge = false;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer<MyProvider>(
      builder: (context, myProvider, child) {
        return Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _statusCharge? NavbarTrolley("Productos") : Navbar("Productos", true),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height:20),
                    dropdownList("Productos"),
                    Visibility(
                      visible: _statusDropdown == "Productos"? myProvider.dataProducts.length >0? true : false : false,
                      child: Container(
                        height: myProvider.dataProducts.length <3? size.height / ((4-myProvider.dataProducts.length)*3) : size.height / 5,
                        child: listProducts(),
                      )
                    ),
                    dropdownList("Categoría"),
                    Visibility(
                      visible: _statusDropdown == "Categoría"? myProvider.dataCategories.length >0? true : false : false,
                      child: Container(
                        height: myProvider.dataCategories.length >3? size.height / 6 : size.height / 4,
                        child: listCategory()
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top:15),
                      child: buttonCreateProduct()
                    ),
                    ]
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom:30),
                child: buttonCharge()
              ),
            ],
          ),
        );
      }
    );
  }

  Widget dropdownList(_title){
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(top:5, bottom: 5),
      child: GestureDetector(
        onTap: () => setState(() {
          if(_statusDropdown == _title){
            _statusDropdown = "";
          }else{
            _statusDropdown = _title;
          }
        }),
        child: Container(
          padding: EdgeInsets.only(left: 30, right: 30),
          width: size.width,
          height: 50,
          color: colorGrey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                _title,
                style: TextStyle(
                  fontSize: size.width / 20,
                ),
              ),
              SizedBox(width:50),
              Icon(
                _statusDropdown == _title? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                color: colorGreen,
              ),
            ]
          ),
        )
      )
    );
  }

  Widget listProducts(){
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    var size = MediaQuery.of(context).size;
    return Scrollbar(
      controller: _scrollControllerProducts, 
      isAlwaysShown: true,
      child: ListView.separated(
        controller: _scrollControllerProducts,
        separatorBuilder: (BuildContext context, int index) => const Divider(color: Colors.grey,),
        padding: EdgeInsets.fromLTRB(60, 20, 60, 10),
        itemCount: myProvider.dataProducts.length,
        itemBuilder:  (BuildContext ctxt, int index) {
          return GestureDetector(
            onTap: () {
              if(myProvider.dataProducts[index].categories != null)
                myProvider.dataCategoriesSelect = myProvider.dataProducts[index].categories.split(",");
              
              myProvider.dataSelectProduct = myProvider.dataProducts[index];
              Navigator.push(context, SlideLeftRoute(page: NewProductPage()));
            }, 
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children : <Widget>[
                    Text(
                      myProvider.dataProducts[index].name,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: size.width / 22,
                      ),
                    ),
                    Text(
                      "${myProvider.dataProducts[index].stock} disponibles",
                      style: TextStyle(
                        color: colorText,
                        fontSize: size.width / 22,
                      ),
                    ),
                  ]
                ),
                Column(
                  children: <Widget>[
                    Container(
                      child: Text(
                        showPrice(myProvider.dataProducts[index].price, myProvider.dataProducts[index].coin),
                        style: TextStyle(
                          color: colorText,
                          fontSize: size.width / 22,
                        ),
                      )
                    ),
                  ]
                )
              ],
            ),
            
          );
        }
      )
    );
  }


  Widget listCategory(){
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    var size = MediaQuery.of(context).size;
    return  ListView.separated(
      separatorBuilder: (BuildContext context, int index) => const Divider(color: Colors.transparent,),
      padding: EdgeInsets.fromLTRB(60, 20, 30, 10),
      itemCount: myProvider.dataCategories.length,
      itemBuilder:  (BuildContext ctxt, int index) {
        if( myProvider.dataCategories[index].type == "Products"){
          return GestureDetector(
            onTap: () {
              setState(() => _idSelectCategories = myProvider.dataCategories[index].id);
              if(_selectCategories == index+1)
                setState(() => _selectCategories = 0);
              else
                setState(() => _selectCategories = index+1);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget> [
                Text(
                  myProvider.dataCategories[index].name,
                  style: TextStyle(
                    color: _selectCategories== index+1? colorGreen : Colors.grey,
                    fontSize: size.width / 22,
                  ),
                ),
                Visibility(
                  visible: _selectCategories-1 == index? true : false,
                  child: showProductCategories(_idSelectCategories),
                ),
              ]
            )
          );
        }

        return Container();
      }
    );
  }

  Widget buttonCreateProduct(){
    var size = MediaQuery.of(context).size;
    return  GestureDetector(
      onTap: () {
        setState(() => _statusButton = true);
        nextPage();
      },
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
            "CREAR PRODUCTO",
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

  Widget buttonCharge(){
    var size = MediaQuery.of(context).size;
    return Visibility(
      visible: _statusCharge,
      child: GestureDetector(
        onTap: () {
          setState(() => _statusButtonCharge = true);
        },
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
                _statusButtonCharge? colorGreen : colorGrey,
                _statusButtonCharge? colorGreen : colorGrey,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30),
            ),
          child: Center(
            child: Text(
              "COBRAR",
              style: TextStyle(
                color: Colors.white,
                fontSize: size.width / 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      )
    );
  }

  showProductCategories(idCategories){
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    myProvider.getListProductsCategories(idCategories);
    var size = MediaQuery.of(context).size;
    return Consumer<MyProvider>(
      builder: (context, myProvider, child) {
        return Container(
          height: myProvider.dataProductsCategories.length <3? size.height / ((4-myProvider.dataProductsCategories.length)*3) : size.height / 5,
          child: Scrollbar(
            controller: _scrollControllerCategories, 
            isAlwaysShown: true,
            child: ListView.separated(
              controller: _scrollControllerCategories,
              separatorBuilder: (BuildContext context, int index) => const Divider(color: Colors.grey,),
              padding: EdgeInsets.fromLTRB(30, 20, 20, 10),
              itemCount: myProvider.dataProductsCategories.length,
              itemBuilder:  (BuildContext ctxt, int index) {
                return GestureDetector(
                  onTap: () {
                    myProvider.dataCategoriesSelect = myProvider.dataProductsCategories[index].categories.split(",");
                    
                    myProvider.dataSelectProduct = myProvider.dataProductsCategories[index];
                    Navigator.push(context, SlideLeftRoute(page: NewProductPage()));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children : <Widget>[
                          Text(
                            myProvider.dataProductsCategories[index].name,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: size.width / 22,
                            ),
                          ),
                          Text(
                            "${myProvider.dataProductsCategories[index].stock} disponibles",
                            style: TextStyle(
                              color: colorText,
                              fontSize: size.width / 22,
                            ),
                          ),
                        ]
                      ),
                      Column(
                        children: <Widget>[
                          Container(
                            child: Text(
                              showPrice(myProvider.dataProductsCategories[index].price, myProvider.dataProductsCategories[index].coin),
                              style: TextStyle(
                                color: colorText,
                                fontSize: size.width / 22,
                              ),
                            )
                          ),
                        ]
                      )
                    ],
                  ),
                  
                ); 
              }
            )
          )
        );
      }
    );
  }

  showPrice(price, coin){
    price = price.replaceAll(",00", "");
    if (coin == 0)
      return "\$ "+price;
    else
      return "Bs "+price;
  }

  nextPage()async{
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    myProvider.dataSelectProduct = null;
    myProvider.dataCategoriesSelect = [];
    await Future.delayed(Duration(milliseconds: 150));
    setState(() => _statusButton = false);
    Navigator.push(context, SlideLeftRoute(page: NewProductPage()));
  }
}