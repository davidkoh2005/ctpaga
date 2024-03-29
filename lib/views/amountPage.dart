import 'package:ctpaga/animation/slideRoute.dart';
import 'package:ctpaga/models/product.dart';
import 'package:ctpaga/views/menu/menu.dart';
import 'package:ctpaga/views/navbar/navbarTrolley.dart';
import 'package:ctpaga/views/newSalesPage.dart';
import 'package:ctpaga/views/productsServicesPage.dart';
import 'package:ctpaga/providers/provider.dart';
import 'package:ctpaga/env.dart';

import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:numeric_keyboard/numeric_keyboard.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AmountPage extends StatefulWidget {
  @override
  _AmountPageState createState() => _AmountPageState();
}

class _AmountPageState extends State<AmountPage> {
  var lowAmount = new MoneyMaskedTextController(initialValue: 0, decimalSeparator: ',', thousandSeparator: '.',  leftSymbol: '\$ ', );
  final FocusNode _priceFocus = FocusNode();
  final _controllerDescription = TextEditingController();
  // ignore: unused_field
  String? _description, _price='';
  // ignore: unused_field
  bool _statusSalesProducts = false, _statusSalesServices = false,  _statusButtonCharge = false;
  double _total = 0.0;
  var myGroup = AutoSizeGroup();

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

    if(myProvider.coinUsers  == 1)
      lowAmount = new MoneyMaskedTextController(initialValue: 0, decimalSeparator: ',', thousandSeparator: '.',  leftSymbol: 'Bs ', );
  
    for (var item in myProvider.dataPurchase) {
      if(item['data'].id == 0){
        _controllerDescription.text = item['data'].name;
        lowAmount.updateValue(double.parse(item['data'].price));
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              NavbarTrolley("Monto"),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    formQuantity(),
                  ]
                ),
              ),
            ],
          ),

          Consumer<MyProvider>(
            builder: (context, myProvider, child) {
              return AnimatedPositioned(
                duration: Duration(milliseconds:250),
                top: 0,
                bottom: 0,
                left: myProvider.statusButtonMenu? 0 : -size.width,
                right: myProvider.statusButtonMenu? 0 : size.width,
                child: MenuPage(),
              );
            }
          ),
        ],
      ),   
    );
  }

  Widget formQuantity(){
    var size = MediaQuery.of(context).size;
    return Consumer<MyProvider>(
      builder: (context, myProvider, child) {
        if(myProvider.statusRemoveShopping){
          myProvider.statusRemoveShopping = false;
          lowAmount.updateValue(double.parse("0"));
          _controllerDescription.clear();
        }
        return Expanded(
          child: Container(
            width: size.width,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.fromLTRB(15.0, 30.0, 15.0, 0.0),
                    child: AutoSizeText(
                      "${lowAmount.text}",
                      style: TextStyle(
                        color: colorText,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'MontserratSemiBold',
                      ),
                      maxFontSize: 28,
                      minFontSize: 28,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 10.0),
                    child: new TextFormField(
                      controller: _controllerDescription,
                      maxLines: 1,
                      textCapitalization:TextCapitalization.words,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[a-zA-Z\ áéíóúÁÉÍÓÚñÑ\s]")),
                        FilteringTextInputFormatter.allow(RegExp("[/\\\\]")),
                      ], 
                      autofocus: false,
                      onEditingComplete: () => FocusScope.of(context).requestFocus(_priceFocus),
                      onSaved: (value) => _description = value!.trim(),
                      onChanged: (value){
                        updateAmount(0, false);
                      },
                      textInputAction: TextInputAction.next,
                      cursorColor: colorLogo,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        fillColor: Colors.blue,
                        enabledBorder: InputBorder.none,
                        hintText: "AGREGAR DESCRIPCIÓN",
                        hintStyle: TextStyle(
                          color: colorGrey,
                          fontFamily: 'MontserratSemiBold',
                          fontSize: 14,
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                      ),
                      style: TextStyle(
                        color: colorText,
                        fontSize: 14,
                      ),
                    ),
                  ),

                  showOptiones(myProvider),


                  Padding(
                    padding: EdgeInsets.only(top:10),
                    child: numPad()
                  ),
                  Padding(
                    padding: EdgeInsets.only(top:30),
                    child: buttonCharge(myProvider)
                  ),
                  SizedBox(height:80),

                ]
              ),
            ),
          ),
        );
      }
    );
    
  }

  showOptiones(myProvider){
    var size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            myProvider.selectProductsServices = 0;
            setState(() => _statusSalesProducts = true);
            nextPage(ProductsServicesPage(true));
          },
          child: Container(
            alignment: Alignment.center,
            width: size.width/2,
            height: size.width/9,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide( 
                  color: colorGreyOp,
                  width: 2.0,
                ),
                right: BorderSide( 
                  color: Colors.white,
                  width: 1.0,
                ),
              ),
              color: _statusSalesProducts? Colors.white : colorGrey,
            ),
            child: AutoSizeText(
              "AGREGAR VENTAS",
              style: TextStyle(
                color: _statusSalesProducts? colorLogo : Colors.black,
                fontFamily: 'MontserratSemiBold',
              ),
              group: myGroup,
              minFontSize: 12,
              maxFontSize: 12,
            ),
          )
        ),
        GestureDetector(
          onTap: (){
            myProvider.selectProductsServices = 1;
            setState(() => _statusSalesServices = true);
            nextPage(ProductsServicesPage(true));
          },
          child: Container(
            alignment: Alignment.center,
            width: size.width/2,
            height: size.width/9,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide( 
                  color: colorGreyOp,
                  width: 2.0,
                ),
                left: BorderSide( 
                  color: Colors.white,
                  width: 1.0,
                ),
              ),
              color: _statusSalesServices? Colors.white : colorGrey,
            ),
            child: AutoSizeText(
              "AGREGAR SERVICIOS",
              style: TextStyle(
                color: _statusSalesServices? colorLogo : Colors.black,
                fontFamily: 'MontserratSemiBold',
              ),
              group: myGroup,
              minFontSize: 12,
              maxFontSize: 12,
            ),
          )
        ),
      ],
    );
  }

  showTotal(){
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    var lowPurchase = new MoneyMaskedTextController(initialValue: 0, decimalSeparator: ',', thousandSeparator: '.',  leftSymbol: '\$ ', );
    
    double priceDouble;
    double varRate = double.parse(myProvider.dataRates[0].rate);
    _total = 0.0;

    if(myProvider.coinUsers  == 1)
      lowPurchase = new MoneyMaskedTextController(initialValue: 0, decimalSeparator: ',', thousandSeparator: '.',  leftSymbol: 'Bs ', );

    for (var item in myProvider.dataPurchase) {
      priceDouble = double.parse(item['data'].price);
      priceDouble *= item['quantity'];
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

  Widget numPad(){
    return NumericKeyboard(
      onKeyboardTap: _onKeyboardTap,
      textColor: Colors.black54,
      rightButtonFn: () {
        if(lowAmount.text.length >0){
          setState(() {
          lowAmount.updateValue(updateAmount(1, 0));
        });
        }
      },
      rightIcon: Icon(
        Icons.backspace,
        color: Colors.black54,
      ),
    );
  }

  _onKeyboardTap(String? value) {
    setState(() {
      lowAmount.updateValue(updateAmount(2, value));
    });
  }


  updateAmount(status, value){
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    bool _statusDataAmount = false;
    var _listPurchase = [];

    String result = lowAmount.text;
    result = result.replaceAll("Bs ", "");
    result = result.replaceAll("\$ ", "");
    result = result.replaceAll(".", "");
    result = result.replaceAll(",", "");

    if(status != 0){
      if(status == 1)
        result = result.substring(0, result.length-1);
      else 
        result += value;
    }

    result = result.substring(0, result.length-2)+"."+result.substring(result.length-2, result.length);

    for (var item in myProvider.dataPurchase) {
      if(item['data'].id == 0){
        _statusDataAmount = true;
        item['data'].price = result;
        item['data'].name = _controllerDescription.text.length != 0? _controllerDescription.text : "Sin descripción";
        item['data'].coin = myProvider.coinUsers;
      }

      _listPurchase.add(item);
    }

    if(!_statusDataAmount){
      var productAmount = Product(
        id:0,
        name: _controllerDescription.text,
        price: double.parse(result).toString(),
      );

      _listPurchase.add({
        "data" :productAmount,
        "quantity" : 1,
        "type": 0,
      });
    }

    myProvider.dataPurchase = _listPurchase;

    return double.parse(result);

  }


  Widget buttonCharge(myProvider){
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        setState(() => _statusButtonCharge = true);
        nextPage(NewSalesPage());
      },
      child: Container(
        width:size.width - 100,
        height: size.height / 20,
        decoration: BoxDecoration(
          border: Border.all(
            color: colorGrey, 
            width: 1.0,
          ),
          color: myProvider.dataPurchase.length != 0? _statusButtonCharge? colorGrey : colorLogo : colorGrey,
          borderRadius: BorderRadius.circular(30),

        ),
        child: Center(
          child: AutoSizeText(
            myProvider.dataPurchase.length == 0? "COBRAR" : "COBRAR ${showTotal()}",
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

  nextPage(page)async{
    await Future.delayed(Duration(milliseconds: 150));
    setState(() {
      _statusSalesProducts = false;
      _statusSalesServices = false;
      _statusButtonCharge = false;
    });
    
    Navigator.push(context, SlideLeftRoute(page: page));
  }
}