import 'package:ctpaga/animation/slideRoute.dart';
import 'package:ctpaga/views/menu/menu.dart';
import 'package:ctpaga/views/navbar/navbar.dart';
import 'package:ctpaga/views/listCategoryPage.dart';
import 'package:ctpaga/providers/provider.dart';
import 'package:ctpaga/database.dart';
import 'package:ctpaga/env.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';

class NewProductServicePage extends StatefulWidget {
  @override
  _NewProductServicePageState createState() => _NewProductServicePageState();
}

class _NewProductServicePageState extends State<NewProductServicePage> {
  final _formKeyProductService = new GlobalKey<FormState>();
  final _scrollController = ScrollController();
  final FocusNode _nameFocus = FocusNode();  
  final FocusNode _priceFocus = FocusNode();
  final FocusNode _descriptionFocus = FocusNode();
  final _controllerCategories = TextEditingController();
  final _controllerName = TextEditingController();
  final _controllerDescription = TextEditingController();
  final _controllerStock = TextEditingController();
  final _controllerPostPurchase = TextEditingController();
  var lowPrice = MoneyMaskedTextController(initialValue: 0, decimalSeparator: ',', thousandSeparator: '.',  leftSymbol: '\$ ', );
  
  // ignore: unused_field
  String _name, _description, _categories, _price, _selectCategories, _postPurchase;
  int _stock, _statusCoin = 0;
  bool _statusButton = false, _switchPublish = false, _switchPostPurchase = false,
      _statusButtonDelete = false;
  List _dataProductsService = [];
  File _image;
  double _positionTopFirst = 0,
        _positionTopSecond = 35;

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
    myProvider.getListCategories();
    _statusCoin = myProvider.coinUsers;

    if(_statusCoin == 0)
      lowPrice = MoneyMaskedTextController(initialValue:0, decimalSeparator: ',', thousandSeparator: '.',  leftSymbol: '\$ ', );
    else
      lowPrice = MoneyMaskedTextController(initialValue:0, decimalSeparator: ',', thousandSeparator: '.',  leftSymbol: 'Bs ', );
  
    if(myProvider.dataSelectProduct != null){
      updatePrice(myProvider.dataSelectProduct.price, myProvider.dataSelectProduct.coin);
      _controllerName.text = myProvider.dataSelectProduct.name;
      _controllerDescription.text = myProvider.dataSelectProduct.description == 'null'? '' : myProvider.dataSelectProduct.description;
      _switchPublish = myProvider.dataSelectProduct.publish;
      _controllerStock.text = myProvider.dataSelectProduct.stock == null? "" : myProvider.dataSelectProduct.stock.toString();
      _switchPostPurchase = myProvider.dataSelectProduct.postPurchase == null ? false :  myProvider.dataSelectProduct.postPurchase.length >0 ? true : false;
      _controllerPostPurchase.text = myProvider.dataSelectProduct.postPurchase == null ? "": myProvider.dataSelectProduct.postPurchase;

      setState(() {
        _dataProductsService.add("Picture");
        _dataProductsService.add("Name");
        _dataProductsService.add("Price");
      });
    }else if(myProvider.dataSelectService != null){
      updatePrice(myProvider.dataSelectService.price, myProvider.dataSelectService.coin);
      _controllerName.text = myProvider.dataSelectService.name;
      _controllerDescription.text = myProvider.dataSelectService.description == 'null'? '' : myProvider.dataSelectService.description;
      _switchPublish = myProvider.dataSelectService.publish;
      _switchPostPurchase = myProvider.dataSelectService.postPurchase == null ? false :  myProvider.dataSelectService.postPurchase.length >0 ? true : false;
      _controllerPostPurchase.text = myProvider.dataSelectService.postPurchase == null ? "": myProvider.dataSelectService.postPurchase;

      setState(() {
        _dataProductsService.add("Picture");
        _dataProductsService.add("Name");
        _dataProductsService.add("Price");
      });
    }

    if(myProvider.coinUsers == 1){
      setState(() {
        _positionTopFirst = 35;
        _positionTopSecond = 0;
      });
    }
      
  }

  updatePrice(price, coin){
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    double priceDouble = double.parse(price);
    double varRate = double.parse(myProvider.dataRates[0].rate);

    if(coin == 0 && myProvider.coinUsers == 1)
      lowPrice.updateValue(priceDouble * varRate);
    else if(coin == 1 && myProvider.coinUsers == 0)
      lowPrice.updateValue(priceDouble / varRate);
    else
      lowPrice.updateValue(priceDouble);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Consumer<MyProvider>(
      builder: (context, myProvider, child) {
        return WillPopScope(
          onWillPop: () async {
            if(myProvider.statusButtonMenu){
              myProvider.statusButtonMenu = false;
              return false;
            }else
              return true;
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    myProvider.selectProductsServices== 0? myProvider.dataSelectProduct != null? Navbar('Modificar Producto', true) : Navbar('Nuevo Producto', true) : myProvider.dataSelectService != null? Navbar('Modificar Servicio', true) : Navbar('Nuevo Servicio', true),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          formProduct(),
                          Padding(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              children: <Widget>[
                                buttonNewProductService(),
                                Visibility(
                                  visible: myProvider.dataSelectProduct != null || myProvider.dataSelectService != null? true : false,
                                  child: Padding(
                                    padding: EdgeInsets.only(top:20),
                                    child: buttonDeleteProductService()
                                  )
                                )
                              ],
                            ),
                          ),
                        ]
                      ),
                    ),
                  ],
                ),
                AnimatedPositioned(
                  duration: Duration(milliseconds:250),
                  top: 0,
                  bottom: 0,
                  left: myProvider.statusButtonMenu? 0 : -size.width,
                  right: myProvider.statusButtonMenu? 0 : size.width,
                  child: MenuPage(),
                ),
              ],
            ),
          )
        );
      }
    );
  }

  Widget coinSecond(){
    var size = MediaQuery.of(context).size;
    return AnimatedPositioned(
      duration: Duration(milliseconds:300),
      top: _positionTopSecond,
      curve: Curves.linear,
      child: AnimatedPadding(
        duration: Duration(milliseconds:600),
        padding: _positionTopSecond == 0? EdgeInsets.only(left:5) : EdgeInsets.only(left:40),
        child: Container(
          alignment: Alignment.center,
          width: size.width / 7,
          height: size.width / 7,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(80),
            color: _positionTopSecond == 0? colorLogo : colorGrey,
          ),
          child: Container(
            child: AutoSizeText(
              "Bs",
              style:  TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'MontserratSemiBold',
              ),
              maxFontSize: 18,
              minFontSize: 18,
            )
          ),
        )
      ),
    );
  }

  Widget coinFirst(){
    var size = MediaQuery.of(context).size;
    return AnimatedPositioned(
      duration: Duration(milliseconds:300),
      top: _positionTopFirst,
      curve: Curves.linear,
      child: AnimatedPadding(
        duration: Duration(milliseconds:600),
        padding: _positionTopFirst == 0? EdgeInsets.only(left:5) : EdgeInsets.only(left:40),
        child: Container(
          alignment: Alignment.center,
          width: size.width / 7,
          height: size.width / 7,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(80),
            color: _positionTopFirst == 0? colorLogo : colorGrey,
          ),
          child: AutoSizeText(
            "\$" ,
            style:  TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'MontserratSemiBold',
            ),
            maxFontSize: 18,
            minFontSize: 18,
          ),
        ),
      ),
    );
  }

  Widget formProduct(){
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    var size = MediaQuery.of(context).size;

    return Expanded(
      child: Container(
        width: size.width-50,
        child: SafeArea(
          child: Scrollbar(
            controller: _scrollController, 
            isAlwaysShown: true,
            child: SingleChildScrollView(
              controller: _scrollController, 
              child: new Form(
                key: _formKeyProductService,
                child: Column(
                  children: <Widget>[
                    showImage(),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 0.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: AutoSizeText(
                          "Nombre",
                          style: TextStyle(
                            color: colorText,
                            fontFamily: 'MontserratSemiBold',
                          ),
                          maxFontSize: 17,
                          minFontSize: 17,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 0.0),
                      child: new TextFormField(
                        controller: _controllerName,
                        maxLines: 1,
                        maxLength: 50,
                        textCapitalization:TextCapitalization.words,
                        autofocus: false,
                        focusNode: _nameFocus,
                        onEditingComplete: () =>FocusScope.of(context).requestFocus(_priceFocus),
                        onChanged: (value) {
                          setState(() {
                            if (value.length >3 && !_dataProductsService.contains("Name")){
                              _dataProductsService.add("Name");
                            }else if(value.length <= 3 && _dataProductsService.contains("Name")){
                              _dataProductsService.remove("Name");
                            }
                          });
                        },
                        validator: _validateName,
                        onSaved: (value) => _name = value.trim(),
                        textInputAction: TextInputAction.next,
                        cursorColor: colorLogo,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'MontserratSemiBold',
                        ),
                      ),
                    ),


                    Padding(
                      padding: EdgeInsets.only(top:40),
                      child: GestureDetector(
                        onTap: () async {
                          myProvider.coinUsers = myProvider.coinUsers == 0 ? 1 : 0;
                          await Future.delayed(Duration(milliseconds: 200));
                          setState(() {
                            _positionTopFirst == 0? _positionTopFirst = 35 : _positionTopFirst = 0; 
                            _positionTopSecond == 0? _positionTopSecond = 35 : _positionTopSecond = 0; 
                          });
                          if(myProvider.coinUsers == 0)
                            lowPrice = MoneyMaskedTextController(initialValue:0, decimalSeparator: ',', thousandSeparator: '.',  leftSymbol: '\$ ', );
                          else
                            lowPrice = MoneyMaskedTextController(initialValue:0, decimalSeparator: ',', thousandSeparator: '.',  leftSymbol: 'Bs ', );

                          if(myProvider.dataSelectProduct != null)
                            updatePrice(myProvider.dataSelectProduct.price, myProvider.dataSelectProduct.coin);
                          else if(myProvider.dataSelectService != null)
                            updatePrice(myProvider.dataSelectService.price, myProvider.dataSelectService.coin);
                        },
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            width: size.width / 3,
                            height: size.width / 3.5,
                            child: Stack(
                              children: myProvider.coinUsers == 0 ?[
                                coinSecond(),
                                coinFirst(),
                              ]
                              :
                              [
                                coinFirst(),
                                coinSecond(),
                              ],
                            ),
                          )
                        )
                      )
                    ),


                    Padding(
                      padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: AutoSizeText(
                          "Precio",
                          style: TextStyle(
                            color: colorText,
                            fontFamily: 'MontserratSemiBold',
                          ),
                          maxFontSize: 17,
                          minFontSize: 17,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 0.0),
                      child: new TextFormField(
                        controller: lowPrice,
                        maxLines: 1,
                        inputFormatters: [  
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        keyboardType: TextInputType.number,
                        autofocus: false,
                        focusNode: _priceFocus,
                        onEditingComplete: () => FocusScope.of(context).requestFocus(_descriptionFocus),
                        onSaved: (value) => _price = value,
                        onChanged: (value) {
                          setState(() {
                            if (!value.contains("0,0") && !_dataProductsService.contains("Price")){
                              _dataProductsService.add("Price");
                            }else if(value.contains("0,0") || (value.contains("00") && value.length == 2) && _dataProductsService.contains("Price")){
                              _dataProductsService.remove("Price");
                            }
                          });
                        },
                        validator: (value) => !_dataProductsService.contains("Price")? 'Debe ingresar un precio Válido' : null,
                        cursorColor: colorLogo,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          color: colorGrey,
                          fontFamily: 'MontserratSemiBold',
                        ),
                        decoration: InputDecoration(
                          enabledBorder: InputBorder.none,
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                        ),    
                        onTap: () => lowPrice.selection = TextSelection.fromPosition(TextPosition(offset: lowPrice.text.length)),                 
                      ),
                    ),


                    Padding(
                      padding: const EdgeInsets.fromLTRB(15.0, 40.0, 15.0, 0.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: AutoSizeText(
                          "Descrición (optional)",
                          style: TextStyle(
                            color: colorText,
                            fontFamily: 'MontserratSemiBold',
                          ),
                          maxFontSize: 17,
                          minFontSize: 17,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 10.0),
                      child: new TextFormField(
                        controller: _controllerDescription,
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                        textCapitalization:TextCapitalization.sentences,
                        autofocus: false,
                        focusNode: _descriptionFocus,
                        onSaved: (value) => _description = value.trim(),
                        cursorColor: colorLogo,
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'MontserratSemiBold',
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(15.0, 40.0, 15.0, 0.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: AutoSizeText(
                          "Categorías (optional)",
                          style: TextStyle(
                            color: colorText,
                            fontFamily: 'MontserratSemiBold',
                          ),
                          maxFontSize: 17,
                          minFontSize: 17,
                        ),
                      ),
                    ),
                    Consumer<MyProvider>(
                      builder: (context, myProvider, child) {
                        _showCategories();
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 10.0),
                          child: new TextFormField(
                            onTap: () => Navigator.push(context, SlideLeftRoute(page: ListCategoryPage())) ,
                            readOnly: true,
                            controller: _controllerCategories,
                            keyboardType: TextInputType.multiline,
                            maxLines: 1,
                            textCapitalization:TextCapitalization.sentences,
                            autofocus: false,
                            onSaved: (value) => _categories = value.trim(),
                            cursorColor: colorLogo,
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                            ),
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'MontserratSemiBold',
                            ),
                          ),
                        );
                      },
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(15.0, 40.0, 15.0, 0.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: AutoSizeText(
                          "Catálogo de ${myProvider.selectProductsServices == 0? 'productos' : 'servicios'}",
                          style: TextStyle(
                            color: colorText,
                            fontFamily: 'MontserratSemiBold',
                          ),
                          maxFontSize: 17,
                          minFontSize: 17,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15.0, 40.0, 15.0, 0.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              AutoSizeText(
                                "Publicar",
                                style: TextStyle(
                                  color: colorText,
                                  fontFamily: 'MontserratSemiBold',
                                ),
                                maxFontSize: 15,
                                minFontSize: 15,
                              ),
                              Container(
                                width: size.width - 140,
                                child: AutoSizeText(
                                  "Mostrar en el catálogo de ${myProvider.selectProductsServices == 0? 'productos' : 'servicios'}",
                                  style: TextStyle(
                                    color: colorText,
                                    fontFamily: 'MontserratSemiBold',
                                  ),
                                  maxFontSize: 13,
                                  minFontSize: 13,
                                )
                              ),
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Switch(
                                value: _switchPublish ,
                                onChanged: (value) {
                                  setState(() {
                                    _switchPublish = value;
                                  });
                                },
                                activeTrackColor: colorGrey,
                                activeColor: colorLogo
                              ),
                            ],
                          ),
                        ],
                      )
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: Divider(color: Colors.black,),
                    ),


                    Visibility(
                      visible: myProvider.selectProductsServices == 0? true : false,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15.0, 40.0, 15.0, 0.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: AutoSizeText(
                            "Cantidad disponible",
                            style: TextStyle(
                              color: colorText,
                              fontFamily: 'MontserratSemiBold',
                            ),
                            maxFontSize: 17,
                            minFontSize: 17,
                          ),
                        ),
                      )
                    ),
                    Visibility(
                      visible: myProvider.selectProductsServices == 0? true : false,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 0.0),
                        child: new TextFormField(
                          controller: _controllerStock,
                          maxLines: 1,
                          inputFormatters: [  
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          keyboardType: TextInputType.number,
                          autofocus: false,
                          onSaved: (value) =>value == ''? _stock = 0 : _stock = int.parse(value),
                          cursorColor: colorLogo,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 25,
                            color: colorGrey,
                            fontFamily: 'MontserratSemiBold',
                          ),
                          decoration: InputDecoration(
                            hintText: "0",
                            hintStyle: TextStyle(
                              fontSize: 25,
                              color: colorGrey,
                              fontFamily: 'MontserratSemiBold',
                            ),
                            enabledBorder: InputBorder.none,
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                          ),                  
                        ),
                      )
                    ),
                    Visibility(
                      visible: myProvider.selectProductsServices == 0? true : false,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15.0, 5.0, 0.0, 0.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            AutoSizeText(
                              "Llevar inventario del ${myProvider.selectProductsServices == 0? 'producto' : 'servico'}",
                              style: TextStyle(
                                color: colorText,
                                fontFamily: 'MontserratSemiBold',
                              ),
                              maxFontSize: 14,
                              minFontSize: 14,
                            ),
                          ],
                        ),
                      )
                    ),
                    Visibility(
                      visible: myProvider.selectProductsServices == 0? true : false,
                      child: Padding(
                        padding: EdgeInsets.only(left: 15, right: 15),
                        child: Divider(color: Colors.black,),
                      )
                    ),


                    Padding(
                      padding: const EdgeInsets.fromLTRB(15.0, 40.0, 15.0, 0.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: AutoSizeText(
                          "Correo post-compra",
                          style: TextStyle(
                            color: colorText,
                            fontFamily: 'MontserratSemiBold',
                          ),
                          maxFontSize: 17,
                          minFontSize: 17,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15.0, 30.0, 15.0, 50.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                child: AutoSizeText(
                                  "Enviar automaticamente",
                                  style: TextStyle(
                                    color: colorText,
                                    fontFamily: 'MontserratSemiBold',
                                  ),
                                  maxFontSize: 15,
                                  minFontSize: 15,
                                )
                              ),
                              Container(
                                width: size.width - 140,
                                child: AutoSizeText(
                                  "Enviar correo personalizado automaticamente luego de la compra",
                                  style: TextStyle(
                                    color: colorText,
                                    fontFamily: 'MontserratSemiBold',
                                  ),
                                  maxFontSize: 12,
                                  minFontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          
                          Switch(
                            value: _switchPostPurchase ,
                            onChanged: (value) {
                              setState(() {
                                _switchPostPurchase = value;
                              });
                              if(value){
                                Timer(
                                  Duration(seconds: 1),
                                  () => _scrollController.jumpTo(_scrollController.position.maxScrollExtent),
                                );
                              }
                            },
                            activeTrackColor: colorGrey,
                            activeColor: colorLogo
                          ),
                        ],
                      )
                    ),

                    Visibility(
                      visible: _switchPostPurchase,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 0.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: AutoSizeText(
                            "Contenido del correo",
                            style: TextStyle(
                              color: colorText,
                              fontFamily: 'MontserratSemiBold',
                            ),
                            maxFontSize: 17,
                            minFontSize: 17,
                          ),
                        ),
                      ),
                    ),

                    Visibility(
                      visible: _switchPostPurchase,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 30.0),
                        child: new TextFormField(
                          controller: _controllerPostPurchase,
                          keyboardType: TextInputType.multiline,
                          maxLines: 3,
                          textCapitalization:TextCapitalization.sentences,
                          autofocus: false,
                          onSaved: (value) => _postPurchase = value.trim(),
                          validator: (value) => _switchPostPurchase? value.trim().isEmpty? 'Ingrese el contenido del correo': null : null,
                          cursorColor: colorLogo,
                          decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'MontserratSemiBold',
                          ),
                        ),
                      ),
                    ),
                  ]
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  showImage(){
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    var size = MediaQuery.of(context).size;
    if(_image != null){
      return GestureDetector(
        onTap: () => _showSelectionDialog(context),
        child: ClipOval(
          child: Image.file(
            _image,
            width: size.width / 4,
            height: size.width / 4,
            fit: BoxFit.cover
          ),
        )
      );
    }else if(myProvider.dataSelectProduct != null){
      return GestureDetector(
        onTap: () => _showSelectionDialog(context),
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: "http://"+url+myProvider.dataSelectProduct.url,
            fit: BoxFit.cover,
            height: size.width / 4,
            width: size.width / 4,
            placeholder: (context, url) {
              return Container(
                margin: EdgeInsets.all(15),
                child:CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(colorLogo),
                ),
              );
            },
            errorWidget: (context, url, error) => Icon(Icons.error, color: Colors.red, size: size.width / 8,),
          ),
        )
      );
    }if(myProvider.dataSelectService != null){
      return GestureDetector(
        onTap: () => _showSelectionDialog(context),
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: url+myProvider.dataSelectService.url,
            fit: BoxFit.cover,
            height: size.width / 4,
            width: size.width / 4,
            placeholder: (context, url) {
              return Container(
                margin: EdgeInsets.all(15),
                child:CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(colorLogo),
                ),
              );
            },
            errorWidget: (context, url, error) => Icon(Icons.error, color: Colors.red, size: size.width / 8,),
          ),
        )
      );
    }

    return GestureDetector(
      onTap: () => _showSelectionDialog(context),
      child: ClipOval(
        child: Image(
          image: AssetImage("assets/icons/addPhoto.png"),
          width: size.width/4,
          height: size.width/4,
        ),
      ),
    );
  }

  Future<void> _showSelectionDialog(BuildContext context) {
    
    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20)
        ),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext bc){
          return Container(
            child: new Wrap(
              spacing: 20,
              children: <Widget>[
                new ListTile(
                  leading: new Icon(Icons.crop_original, color:Colors.black, size: 30.0),
                  title: new AutoSizeText(
                    "Galeria",
                    style: TextStyle(
                      fontFamily: 'MontserratSemiBold',
                    ),
                    minFontSize: 14,
                    maxFontSize: 14,
                  ),
                  onTap: () => _getImage(context, ImageSource.gallery),       
                ),
                new ListTile(
                  leading: new Icon(Icons.camera, color:Colors.black, size: 30.0),
                  title: new AutoSizeText(
                    "Camara",
                    style: TextStyle(
                      fontFamily: 'MontserratSemiBold',
                    ),
                    minFontSize: 14,
                    maxFontSize: 14,
                  ),
                  onTap: () => _getImage(context, ImageSource.camera),          
                ),
              ],
            ),
          );
      }
    );
  }

  _getImage(BuildContext context, ImageSource source) async {
    var picture = await ImagePicker().pickImage(source: source,  imageQuality: 50, maxHeight: 600, maxWidth: 900);
    var cropped;

    if(picture != null){
      cropped = await ImageCropper().cropImage(
        sourcePath: picture.path,
        aspectRatio:  CropAspectRatio(
          ratioX: 1, ratioY: 1
        ),
        compressQuality: 100,
        maxWidth: 700,
        maxHeight: 700,
        cropStyle: CropStyle.circle,
        compressFormat: ImageCompressFormat.jpg,
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: "Editar Foto",
          backgroundColor: Colors.black,
          toolbarWidgetColor: Colors.black,
        ),
        iosUiSettings: IOSUiSettings(
          title: 'Editar Foto',
        )
      );

      if(cropped != null){
        this.setState(() {
          _image = cropped;
          _dataProductsService.add("Picture");
        });
      }
      Navigator.of(context).pop();
      
    }
  }

  Widget buttonNewProductService(){
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        if(_dataProductsService.length >=3){
          saveNewProductService();
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
          color: showColorButton(myProvider),
          borderRadius: BorderRadius.circular(30),

        ),
        child: Center(
          child: AutoSizeText(
            myProvider.selectProductsServices == 0? myProvider.dataSelectProduct != null ? "GUARDAR PRODUCTO" : "CREAR PRODUCTO" : myProvider.dataSelectService != null ? "GUARDAR SERVICIO" : "CREAR SERVICIO",
            style: TextStyle(
              color: Colors.white,
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

  Widget buttonDeleteProductService(){
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => deleteProductService(),
      child: Container(
        width:size.width - 100,
        height: size.height / 20,
        decoration: BoxDecoration(
          border: Border.all(
            color: colorGrey, 
            width: 1.0,
          ),
          color: _statusButtonDelete? colorGrey : Colors.red,
          borderRadius: BorderRadius.circular(30),

        ),
        child: Center(
          child: AutoSizeText(
            "ELIMINAR PRODUCTO",
            style: TextStyle(
              color:  Colors.white,
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

  showColorButton(myProvider){
    if(_dataProductsService.length <3)
        return colorGrey;
      else
        if(_statusButton)
          return colorGrey;

        return colorLogo;
    
  }

  saveNewProductService()async{
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    var response, result;
    setState(() => _statusButton = true);
    await Future.delayed(Duration(milliseconds: 150));
    setState(() => _statusButton = false);

    if (_formKeyProductService.currentState.validate() && (myProvider.dataSelectProduct == null && myProvider.dataSelectService == null)) {
      _formKeyProductService.currentState.save();
      try
      {
        _onLoading();
        
        result = await InternetAddress.lookup('google.com'); //verify network
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

          String base64Image = base64Encode(_image.readAsBytesSync());
          if(myProvider.selectProductsServices == 0){
            response = await http.post(
              Uri.parse(urlApi+"newProducts"),
              headers:{
                'Content-Type': 'application/json',
                'X-Requested-With': 'XMLHttpRequest',
                'authorization': 'Bearer ${myProvider.accessTokenUser}',
              },
              body: jsonEncode({
                "commerce_id": myProvider.dataCommercesUser[myProvider.selectCommerce].id.toString(),
                "image":base64Image,
                "name": _name,
                "price": _price,
                "coin": _statusCoin,
                "description": _description,
                "categories": _selectCategories,
                "publish": _switchPublish,
                "stock": _stock,
                "postPurchase": _postPurchase,
              }),
            ); 
          }else{
            response = await http.post(
              Uri.parse(urlApi+"newServices"),
              headers:{
                'Content-Type': 'application/json',
                'X-Requested-With': 'XMLHttpRequest',
                'authorization': 'Bearer ${myProvider.accessTokenUser}',
              },
              body: jsonEncode({
                "commerce_id": myProvider.dataCommercesUser[myProvider.selectCommerce].id.toString(),
                "image":base64Image,
                "name": _name,
                "price": _price,
                "coin": _statusCoin,
                "description": _description,
                "categories": _selectCategories,
                "publish": _switchPublish,
                "postPurchase": _postPurchase,
              }),
            ); 
          }
          

          var jsonResponse = jsonDecode(response.body); 
          print(jsonResponse); 
          if (jsonResponse['statusCode'] == 201) {
            await myProvider.getListProducts();
            await myProvider.getListServices();
            Navigator.pop(context);
            showMessage("Guardado Correctamente", true);
            await Future.delayed(Duration(seconds: 1));
            Navigator.pop(context);
            Navigator.pop(context);
          }
        }
      } on SocketException catch (_) {
        Navigator.pop(context);
        showMessage("Sin conexión a internet",false);
      }
    }else if (_formKeyProductService.currentState.validate() && (myProvider.dataSelectProduct != null || myProvider.dataSelectService != null)) {
      _formKeyProductService.currentState.save();
      try
      {
        _onLoading();
        
        result = await InternetAddress.lookup('google.com'); //verify network
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          String base64Image;
          if(_image != null)
            base64Image = base64Encode(_image.readAsBytesSync());
          else
            base64Image = myProvider.dataSelectProduct.url;

          if(myProvider.selectProductsServices == 0){
            response = await http.post(
              Uri.parse(urlApi+"updateProducts"),
              headers:{
                'Content-Type': 'application/json',
                'X-Requested-With': 'XMLHttpRequest',
                'authorization': 'Bearer ${myProvider.accessTokenUser}',
              },
              body: jsonEncode({
                "id": myProvider.dataSelectProduct.id,
                "commerce_id": myProvider.dataCommercesUser[myProvider.selectCommerce].id.toString(),
                "image":base64Image,
                "name": _name,
                "price": _price,
                "coin": _statusCoin,
                "description": _description,
                "categories": _selectCategories,
                "publish": _switchPublish,
                "stock": _stock,
                "postPurchase": _postPurchase,
                "url": _image == null? myProvider.dataSelectProduct.url : null,
              }),
            ); 
          }else{
            response = await http.post(
              Uri.parse(urlApi+"updateServices"),
              headers:{
                'Content-Type': 'application/json',
                'X-Requested-With': 'XMLHttpRequest',
                'authorization': 'Bearer ${myProvider.accessTokenUser}',
              },
              body: jsonEncode({
                "id": myProvider.dataSelectService.id,
                "commerce_id": myProvider.dataCommercesUser[myProvider.selectCommerce].id.toString(),
                "image":base64Image,
                "name": _name,
                "price": _price,
                "coin": _statusCoin,
                "description": _description,
                "categories": _selectCategories,
                "publish": _switchPublish,
                "stock": _stock,
                "postPurchase": _postPurchase,
                "url": _image == null? myProvider.dataSelectService.url : null,
              }),
            ); 
          }
          

          var jsonResponse = jsonDecode(response.body); 
          print(jsonResponse); 
          if (jsonResponse['statusCode'] == 201) {
            await myProvider.getListProducts();
            Navigator.pop(context);
            showMessage("Guardado Correctamente", true);
            await Future.delayed(Duration(seconds: 1));
            Navigator.pop(context);
            Navigator.pop(context);
          }
        }
      } on SocketException catch (_) {
        Navigator.pop(context);
        showMessage("Sin conexión a internet", false);
      } 
    }
  }

  deleteProductService()async{
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    var response, result;
    setState(() => _statusButtonDelete = true);
    await Future.delayed(Duration(milliseconds: 150));
    setState(() => _statusButtonDelete = false);

    try
      {
        _onLoading();
        
        result = await InternetAddress.lookup('google.com'); //verify network
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

          if(myProvider.selectProductsServices == 0){
            response = await http.post(
              Uri.parse(urlApi+"deleteProducts"),
              headers:{
                'Content-Type': 'application/json',
                'X-Requested-With': 'XMLHttpRequest',
                'authorization': 'Bearer ${myProvider.accessTokenUser}',
              },
              body: jsonEncode({
                "id": myProvider.dataSelectProduct.id,
                "url": myProvider.dataSelectProduct.url,
              }),
            ); 
          }else{
            response = await http.post(
              Uri.parse(urlApi+"deleteServices"),
              headers:{
                'Content-Type': 'application/json',
                'X-Requested-With': 'XMLHttpRequest',
                'authorization': 'Bearer ${myProvider.accessTokenUser}',
              },
              body: jsonEncode({
                "id": myProvider.dataSelectService.id,
                "url": myProvider.dataSelectService.url,
              }),
            ); 
          }
          

          var jsonResponse = jsonDecode(response.body); 
          print(jsonResponse); 
          if (jsonResponse['statusCode'] == 201) {
            var dbctpaga = DBctpaga();
            if(myProvider.selectProductsServices == 0){
              dbctpaga.deleteProduct(myProvider.dataSelectProduct.id);
              await myProvider.getListProducts();
            }
            else{
              dbctpaga.deleteService(myProvider.dataSelectService.id);
              await myProvider.getListServices();
            }
            
            Navigator.pop(context);
            showMessage("Eliminado Correctamente", true);
            await Future.delayed(Duration(seconds: 1));
            Navigator.pop(context);
            Navigator.pop(context);
          }
        }
      } on SocketException catch (_) {
        Navigator.pop(context);
        showMessage("Sin conexión a internet", false);
      } 
  }

  Future<void> showMessage(_titleMessage, _statusCorrectly) async {
    var size = MediaQuery.of(context).size;

    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _statusCorrectly? Padding(
                padding: EdgeInsets.all(5),
                child: Icon(
                  Icons.check_circle,
                  color: colorLogo,
                  size: size.width / 8,
                )
              )
              : Padding(
                padding: EdgeInsets.all(5),
                child: Icon(
                  Icons.error,
                  color: Colors.red,
                  size: size.width / 8,
                )
              ),
              Container(
                padding: EdgeInsets.all(5),
                child: Text(
                  _titleMessage,
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'MontserratSemiBold',
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _onLoading() async {
    
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            backgroundColor: Colors.white,
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(5),
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(colorLogo),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Cargando ",
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'MontserratSemiBold',
                          )
                        ),
                        TextSpan(
                          text: "...",
                          style: TextStyle(
                            color: colorLogo,
                            fontFamily: 'MontserratSemiBold',
                          )
                        ),
                      ]
                    ),
                  ),
                ),
              ],
            ),
          )
        );
      },
    );
  }

  _showCategories(){
    String list="";
    _selectCategories = "";
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    if(myProvider.dataCategoriesSelect.length >0){
      for (var item in myProvider.dataCategories) {
        if(myProvider.dataCategoriesSelect.contains(item.id.toString())){
            _selectCategories += item.id.toString()+', ';
            list += item.name+', ';
          }
      }
    }

    if(list.length >0){
      list = list.substring(0, list.length - 2);
      _selectCategories = _selectCategories.substring(0, _selectCategories.length - 2);
      _controllerCategories..text = list;
    }else{
      _selectCategories = "";
      _controllerCategories.clear();
    }
  }

  String _validateName(String value) {
    // This is just a regular expression for name 
    String p = '[a-zA-Z]';
    RegExp regExp = new RegExp(p);

    if (value.isNotEmpty && regExp.hasMatch(value) && value.length >=3) {
      // So, the name is valid
      _name = value;
      return null;
    }

    // The pattern of the name and surname didn't match the regex above.
    return 'Ingrese el nombre de producto válido';
  }
}