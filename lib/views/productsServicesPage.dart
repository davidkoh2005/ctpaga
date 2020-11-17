import 'dart:convert';

import 'package:ctpaga/animation/slideRoute.dart';
import 'package:ctpaga/views/navbar/navbarTrolley.dart';
import 'package:ctpaga/views/navbar/navbar.dart';
import 'package:ctpaga/views/newProductServicePage.dart';
import 'package:ctpaga/views/newSalesPage.dart';
import 'package:ctpaga/providers/provider.dart';
import 'package:ctpaga/env.dart';

import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class ProductsServicesPage extends StatefulWidget {
  ProductsServicesPage(this._statusCharge);
  final bool _statusCharge;
  
  @override
  _ProductsServicesPageState createState() => _ProductsServicesPageState(this._statusCharge);
}

class _ProductsServicesPageState extends State<ProductsServicesPage> {
  _ProductsServicesPageState(this._statusCharge);
  final _scrollControllerProductsServices = ScrollController();
  final _scrollControllerCategories = ScrollController();
  final bool _statusCharge;
  String _statusDropdown = "";
  int _selectCategories = 0, _idSelectCategories=0;
  double _total=0.0;
  bool _statusButton = false, _statusButtonCharge = false,
      _statusPurchase = false;
  List  _indexProduct = new List(), _indexService = new List();

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
    myProvider.selectDateRate = 0;
  }

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
              myProvider.selectProductsServices == 0? _statusCharge? NavbarTrolley("Productos") : Navbar("Productos", true) : _statusCharge? NavbarTrolley("Servicios") : Navbar("Servicios", true),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    myProvider.selectProductsServices == 0? dropdownList("Productos") : dropdownList("Servicios"),
                    Visibility(
                      visible: _statusProductsServices(myProvider),
                      child: 

                      myProvider.selectProductsServices == 0? Container(
                          height: myProvider.dataProducts.length <3? size.height / ((4-myProvider.dataProducts.length)*3) : size.height / 5,
                          child: listProductsServices(),
                        )
                      : Container(
                        height: myProvider.dataServices.length <3? size.height / ((4-myProvider.dataServices.length)*3) : size.height / 5,
                        child: listProductsServices(),
                      ),

                    ),
                    dropdownList("Categoría"),
                    Visibility(
                      visible: _statusDropdown == "Categoría"? myProvider.dataCategories.length  > 0? true : false : false,
                      child: Container(
                        height: myProvider.dataCategories.length >3 ? size.height / 6 : size.height / 4,
                        child: listCategory()
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top:15),
                      child: buttonCreateProductService()
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

  bool _statusProductsServices(myProvider){
    if(_statusDropdown == "Productos" && myProvider.dataProducts.length >0){
      return true;
    }else if(_statusDropdown == "Servicios" && myProvider.dataServices.length >0){
      return true;
    }  

    return false;
  }

  Widget dropdownList(_title){
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(top:5, bottom: 5),
      child: GestureDetector(
        onTap: () => setState(() {
          _selectCategories = 0;
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

  Widget listProductsServices(){
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    var size = MediaQuery.of(context).size;
    
    if(myProvider.selectProductsServices == 0){
      return Scrollbar(
        controller: _scrollControllerProductsServices, 
        isAlwaysShown: true,
        child: ListView.separated(
          controller: _scrollControllerProductsServices,
          separatorBuilder: (BuildContext context, int index) => const Divider(color: Colors.grey,),
          padding: EdgeInsets.fromLTRB(60, 20, 60, 10),
          itemCount: myProvider.dataProducts.length,
          itemBuilder:  (BuildContext ctxt, int index) {
            return GestureDetector(
              onTap: () async {
                if(_statusCharge){
                  addProductsServices(myProvider.dataProducts[index]);
                  setState(() =>_indexProduct.add(index));
                  await Future.delayed(Duration(milliseconds: 150));
                  setState(() =>_indexProduct.remove(index));
                }else{
                  setState(() => _statusDropdown = "");
                  if(myProvider.dataProducts[index].categories != null)
                    myProvider.dataCategoriesSelect = myProvider.dataProducts[index].categories.split(",");
                  
                  myProvider.dataSelectProduct = myProvider.dataProducts[index];
                  myProvider.dataSelectService = null;

                  nextPage(NewProductServicePage());
                }
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
                          color: _indexProduct.contains(index)? colorGreen :  colorText,
                          fontSize: size.width / 22,
                          fontWeight: _indexProduct.contains(index)? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      Text(
                        "${myProvider.dataProducts[index].stock} disponibles",
                        style: TextStyle(
                          color: _indexProduct.contains(index)? colorGreen :  colorText,
                          fontSize: size.width / 22,
                          fontWeight: _indexProduct.contains(index)? FontWeight.bold : FontWeight.normal,
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
                            color: _indexProduct.contains(index)? colorGreen :  colorText,
                            fontSize: size.width / 22,
                            fontWeight: _indexProduct.contains(index)? FontWeight.bold : FontWeight.normal,
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
    }else{
      return Scrollbar(
        controller: _scrollControllerProductsServices, 
        isAlwaysShown: true,
        child: ListView.separated(
          controller: _scrollControllerProductsServices,
          separatorBuilder: (BuildContext context, int index) => const Divider(color: Colors.black,),
          padding: EdgeInsets.fromLTRB(60, 20, 60, 10),
          itemCount: myProvider.dataServices.length,
          itemBuilder:  (BuildContext ctxt, int index) {
            return GestureDetector(
              onTap: () async {
                if(_statusCharge){
                  addProductsServices(myProvider.dataServices[index]);
                  setState(() =>_indexService.add(index));
                  await Future.delayed(Duration(milliseconds: 150));
                  setState(() =>_indexService.remove(index));
                }else{
                  setState(() => _statusDropdown = "");
                  if(myProvider.dataServices[index].categories != null)
                    myProvider.dataCategoriesSelect = myProvider.dataServices[index].categories.split(",");
                  
                  myProvider.dataSelectService = myProvider.dataServices[index];
                  myProvider.dataSelectProduct = null;
                  nextPage(NewProductServicePage());
                }
              }, 
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children : <Widget>[
                      Text(
                        myProvider.dataServices[index].name,
                        style: TextStyle(
                          color: _indexService.contains(index)? colorGreen : colorText,
                          fontSize: size.width / 22,
                          fontWeight: _indexService.contains(index)? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ]
                  ),
                  Column(
                    children: <Widget>[
                      Container(
                        child: Text(
                          showPrice(myProvider.dataServices[index].price, myProvider.dataServices[index].coin),
                          style: TextStyle(
                            color: _indexService.contains(index)? colorGreen : colorText,
                            fontSize: size.width / 22,
                            fontWeight: _indexService.contains(index)? FontWeight.bold : FontWeight.normal,
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

  }

  addProductsServices(data){
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    List _listSales = new List();
    bool _status = false;
    if(myProvider.dataPurchase.length == 0){
      myProvider.dataPurchase.add({
        "data" :data,
        "count" : 1
      });
    }else{
      for (var item in myProvider.dataPurchase) {
        if(item['data'].name == data.name && item['data'].id == data.id){
          item['count'] +=1;
          _status = true;
        }
        
        _listSales.add(item);
      }

      if(!_status)
        _listSales.add({
          "data" :data,
          "count" : 1
        });

      myProvider.dataPurchase = _listSales;
    }
  }


  Widget listCategory(){
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    var size = MediaQuery.of(context).size;
    return  ListView.separated(
      separatorBuilder: (BuildContext context, int index) => const Divider(color: Colors.transparent,),
      padding: EdgeInsets.fromLTRB(45, 20, 30, 10),
      itemCount: myProvider.dataCategories.length,
      itemBuilder:  (BuildContext ctxt, int index) {
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
    );
  }

  Widget buttonCreateProductService(){
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    var size = MediaQuery.of(context).size;
    return  GestureDetector(
      onTap: () {
        setState(() => _statusButton = true);
        nextPage(NewProductServicePage());
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
            myProvider.selectProductsServices == 0? "CREAR PRODUCTO" : "CREAR SERVICIO",
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
    return Consumer<MyProvider>(
      builder: (context, myProvider, child) {
        return Visibility(
          visible: _statusCharge,
          child: GestureDetector(
            onTap: () {
              if(myProvider.dataPurchase.length != 0){
                setState(() => _statusButtonCharge = true);
                nextPage(NewSalesPage());
              }
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
                    myProvider.dataPurchase.length != 0? _statusButtonCharge? colorGrey : colorGreen : colorGrey,
                    myProvider.dataPurchase.length != 0? _statusButtonCharge? colorGrey : colorGreen : colorGrey,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(30),
                ),
              child: Center(
                child: Text(
                  myProvider.dataPurchase.length == 0? "COBRAR" : "COBRAR ${showTotal()}",
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
    );
  }

  showTotal(){
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    var lowPurchase = new MoneyMaskedTextController(initialValue: 0, decimalSeparator: ',', thousandSeparator: '.',  leftSymbol: ' \$', );
    double priceDouble;
    double varRate = double.parse(myProvider.dataRates[0].rate);
    _total = 0.0;

    if(myProvider.coinUsers  == 1)
      lowPurchase = new MoneyMaskedTextController(initialValue: 0, decimalSeparator: ',', thousandSeparator: '.',  leftSymbol: 'Bs ', );

    for (var item in myProvider.dataPurchase) {
      priceDouble = double.parse(item['data'].price);
      priceDouble *= item['count'];
      if(item['data'].coin == 0 && myProvider.coinUsers == 1)
        _total+=(priceDouble * varRate);
      else if(item['data'].coin == 1 && myProvider.coinUsers == 0)
        _total+=(priceDouble / varRate);
      else
        _total+=(priceDouble);

    }

    lowPurchase.updateValue(_total);

    return "${lowPurchase.text}";
  }

  showProductCategories(idCategories){
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    myProvider.getListProductsServicesCategories(idCategories);
    var size = MediaQuery.of(context).size;
    return Consumer<MyProvider>(
      builder: (context, myProvider, child) {
        if(myProvider.dataProductsServicesCategories.length>0)
          return Container(
            height: myProvider.dataProductsServicesCategories.length <3? size.height / ((4-myProvider.dataProductsServicesCategories.length)*3) : size.height / 5,
            child: Scrollbar(
              controller: _scrollControllerCategories, 
              isAlwaysShown: true,
              child: ListView.separated(
                controller: _scrollControllerCategories,
                separatorBuilder: (BuildContext context, int index) => const Divider(color: Colors.black,),
                padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                itemCount: myProvider.dataProductsServicesCategories.length,
                itemBuilder:  (BuildContext ctxt, int index) {
                  return GestureDetector(
                    onTap: () async {
                      if(_statusCharge && myProvider.selectProductsServices == 0){
                        addProductsServices(myProvider.dataProductsServicesCategories[index]);
                        setState(() =>_indexProduct.add(index));
                        await Future.delayed(Duration(milliseconds: 150));
                        setState(() =>_indexProduct.remove(index));
                      }else if(_statusCharge && myProvider.selectProductsServices == 1){
                        addProductsServices(myProvider.dataProductsServicesCategories[index]);
                        setState(() =>_indexService.add(index));
                        await Future.delayed(Duration(milliseconds: 150));
                        setState(() =>_indexService.remove(index));
                      }else{
                        setState(() => _statusDropdown = "");
                        myProvider.dataCategoriesSelect = myProvider.dataProductsServicesCategories[index].categories.split(",");
                        if(myProvider.selectProductsServices == 0){
                          myProvider.dataSelectProduct = myProvider.dataProductsServicesCategories[index];
                          myProvider.dataSelectService = null;
                        }else{
                          myProvider.dataSelectService = myProvider.dataProductsServicesCategories[index];
                          myProvider.dataSelectProduct = null;
                        }
                        nextPage(NewProductServicePage());
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children : <Widget>[
                            Text(
                              myProvider.dataProductsServicesCategories[index].name,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: size.width / 22,
                              ),
                            ),
                            myProvider.selectProductsServices == 0? 
                              Text(
                                "${myProvider.dataProductsServicesCategories[index].stock} disponibles",
                                style: TextStyle(
                                  color: colorText,
                                  fontSize: size.width / 22,
                                ),
                              )
                            :
                              Container(),
                          ]
                        ),
                        Column(
                          children: <Widget>[
                            Container(
                              child: Text(
                                showPrice(myProvider.dataProductsServicesCategories[index].price, myProvider.dataProductsServicesCategories[index].coin),
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
        else
          return Container();
      }
    );
  }

  showPrice(price, coin){
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    var lowPrice = new MoneyMaskedTextController(initialValue: 0, decimalSeparator: ',', thousandSeparator: '.',  leftSymbol: ' \$', );
    double priceDouble = double.parse(price);
    double varRate = double.parse(myProvider.dataRates[0].rate);

    if(myProvider.coinUsers  == 1)
      lowPrice = new MoneyMaskedTextController(initialValue: 0, decimalSeparator: ',', thousandSeparator: '.',  leftSymbol: 'Bs ', );

    if(coin == 0 && myProvider.coinUsers == 1)
      lowPrice.updateValue(priceDouble * varRate);
    else if(coin == 1 && myProvider.coinUsers == 0)
      lowPrice.updateValue(priceDouble / varRate);
    else
      lowPrice.updateValue(priceDouble);

    return "${lowPrice.text}";
  }

  nextPage(page)async{
    if(_statusButtonCharge){
      await Future.delayed(Duration(milliseconds: 150));
      setState(() {_statusButtonCharge = false; _statusDropdown = "";});
    }else if(_statusButton){
      var myProvider = Provider.of<MyProvider>(context, listen: false);
      myProvider.dataSelectProduct = null;
      myProvider.dataSelectService = null;
      myProvider.dataCategoriesSelect = [];
      await Future.delayed(Duration(milliseconds: 150));
      setState(() {_statusButton = false; _statusDropdown = "";});
    }

    Navigator.push(context, SlideLeftRoute(page: page));
  }
}