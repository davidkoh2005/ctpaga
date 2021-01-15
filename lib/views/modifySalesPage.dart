import 'package:ctpaga/views/navbar/navbar.dart';
import 'package:ctpaga/providers/provider.dart';
import 'package:ctpaga/env.dart';

import 'package:numeric_keyboard/numeric_keyboard.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class ModifySalesPage extends StatefulWidget {
  @override
  _ModifySalesPageState createState() => _ModifySalesPageState();
}

class _ModifySalesPageState extends State<ModifySalesPage> {
  // ignore: unused_field
  String _name, _quantity;
  bool _statusButtonSave = false, _statusButtonDelete =false;


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
    setState(() {
      _quantity = myProvider.dataPurchase[myProvider.positionModify]['quantity'].toString();
    });

  }

  @override
  Widget build(BuildContext context) {
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Navbar(myProvider.dataPurchase[myProvider.positionModify]['data'].name.length != 0? myProvider.dataPurchase[myProvider.positionModify]['data'].name : 'Sin descripción' , false),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                formQuantity(),
              ]
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 100),
            child: Column(
              children: <Widget>[
                buttonDelete(),
                SizedBox(height:40),
                buttonSave(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget formQuantity(){
    var scaleFactor = MediaQuery.of(context).textScaleFactor;
    var size = MediaQuery.of(context).size;
    return Consumer<MyProvider>(
      builder: (context, myProvider, child) {
        return Expanded(
          child: Container(
            width: size.width,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.fromLTRB(15.0, 30.0, 15.0, 30.0),
                    child: Text(
                      _quantity.length == 0? "0" : _quantity,
                      style: TextStyle(
                        color: colorText,
                        fontSize: 35 * scaleFactor,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'MontserratSemiBold',
                      ),
                    ),
                  ),
                  numPad(),

                ]
              ),
            ),
          ),
        );
      }
    );
    
  }
  Widget numPad(){
    return NumericKeyboard(
      onKeyboardTap: _onKeyboardTap,
      textColor: Colors.black54,
      rightButtonFn: () {
        if(_quantity.length >0){
          setState(() {
            _quantity = _quantity.substring(0, _quantity.length - 1);

          });
        }
      },
      rightIcon: Icon(
        Icons.backspace,
        color: Colors.black54,
      ),
    );
  }

  _onKeyboardTap(String value) {
    setState(() {
      _quantity = _quantity + value;
    });
  }


  Widget buttonSave(){
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: ()=> saveQuantity(),
      child: Container(
        width:size.width - 100,
        height: size.height / 20,
        decoration: BoxDecoration(
          border: Border.all(
            color: colorGrey, 
            width: 1.0,
          ),
          color: _quantity.length != 0? _statusButtonSave? colorGrey : colorGreen : colorGrey,
          borderRadius: BorderRadius.circular(30),

        ),
        child: Center(
          child: Text(
            "GUARDAR",
            style: TextStyle(
              color: Colors.white,
              fontSize: size.width / 20,
              fontWeight: FontWeight.w500,
              fontFamily: 'MontserratSemiBold',
            ),
          ),
        ),
      ),
    );
  }

  Widget buttonDelete(){
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => deleteQuantity(),
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
          child: Text(
            "ELIMINAR",
            style: TextStyle(
              color: _statusButtonDelete? colorGreen : Colors.white,
              fontSize: size.width / 20,
              fontWeight: FontWeight.w500,
              fontFamily: 'MontserratSemiBold',
            ),
          ),
        ),
      ),
    );
  }

  saveQuantity()async{
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    List _listPurchase = List();

    setState(() => _statusButtonSave = true);
    await Future.delayed(Duration(milliseconds: 150));
    setState(() => _statusButtonSave = false);

    if(int.parse(_quantity)>0){
      for (var item in myProvider.dataPurchase) {
        if(item['data'].id == myProvider.dataPurchase[myProvider.positionModify]['data'].id && item['type'] == myProvider.dataPurchase[myProvider.positionModify]['type'] ){
          item['quantity'] = int.parse(_quantity);
        }
        _listPurchase.add(item);
      }
      myProvider.dataPurchase = _listPurchase;
      Navigator.pop(context);
    }
  }

  deleteQuantity()async{
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    List _listPurchase = List();

    setState(() => _statusButtonDelete = true);
    await Future.delayed(Duration(milliseconds: 150));
    setState(() => _statusButtonDelete = false);

    if(myProvider.dataPurchase[myProvider.positionModify]['data'].id == 0)
      myProvider.statusRemoveShopping = true;

    for (var item in myProvider.dataPurchase) {
      if(!(item['data'].id == myProvider.dataPurchase[myProvider.positionModify]['data'].id && item['type'] == myProvider.dataPurchase[myProvider.positionModify]['type'] )){
        _listPurchase.add(item);
      }
    }
    myProvider.dataPurchase = _listPurchase;
    myProvider.positionModify = 0;
    Navigator.pop(context);
  }

}