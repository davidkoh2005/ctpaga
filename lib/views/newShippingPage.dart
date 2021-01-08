
import 'package:ctpaga/database.dart';
import 'package:ctpaga/views/navbar/navbar.dart';
import 'package:ctpaga/providers/provider.dart';
import 'package:ctpaga/env.dart';

import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:io';

class NewShippingPage extends StatefulWidget {
  NewShippingPage(this.index);
  final int index;
  @override
  _NewShippingPageState createState() => _NewShippingPageState(index);
}

class _NewShippingPageState extends State<NewShippingPage> {
  _NewShippingPageState(this.index);
  final int index;
  final _formKeyShipping = new GlobalKey<FormState>();
  final _controllerDescription= TextEditingController();
  final FocusNode _priceFocus = FocusNode();
  var lowPrice = MoneyMaskedTextController(initialValue: 0, decimalSeparator: ',', thousandSeparator: '.',  leftSymbol: '\$ ', );
  bool _statusButtonSave = false, _switchFree = false, _statusButtonDelete = false;
  int _statusCoin;
  String _description, _descriptionData, _price;
  List _dataShipping = new List();

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
    
    _statusCoin = myProvider.coinUsers;

    if(_statusCoin == 0){
      lowPrice = MoneyMaskedTextController(initialValue:0, decimalSeparator: ',', thousandSeparator: '.',  leftSymbol: 'Bs ', );
      lowPrice = MoneyMaskedTextController(initialValue:0, decimalSeparator: ',', thousandSeparator: '.',  leftSymbol: '\$ ', );
    }else{
      lowPrice = MoneyMaskedTextController(initialValue:0, decimalSeparator: ',', thousandSeparator: '.',  leftSymbol: 'Bs ', );
    }
    
    if(index != null){
      if(myProvider.dataShipping[index].price == "FREE")
        setState(() => _switchFree = true);
      else
        lowPrice.updateValue(double.parse(myProvider.dataShipping[index].price));
      
      _controllerDescription.text = myProvider.dataShipping[index].description;
      _descriptionData = myProvider.dataShipping[index].description;
      setState(() {
        _dataShipping.add("Description");
        _dataShipping.add("Price");
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Navbar("Nueva tarifa", false),
          Expanded(
            child: formShipping(),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                buttonSave(),
                Visibility(
                  visible: index==null? false: true,
                  child: Padding(
                    padding: EdgeInsets.only(top:20),
                    child: buttonDelete()
                  )
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget formShipping(){
    var scaleFactor = MediaQuery.of(context).textScaleFactor;
    return new Form(
      key: _formKeyShipping,
      child: ListView (
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "DESCRIPCIÓN",
                style: TextStyle(
                  color: colorText,
                  fontSize: 15 * scaleFactor,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 0.0),
            child: new TextFormField(
              controller: _controllerDescription,
              maxLines: 1,
              textCapitalization:TextCapitalization.words,
              autofocus: false,
              validator: validateDescription,
              onSaved: (value) => _description = value.trim(),
              onChanged: (value) {
                setState(() {
                  if (value.length >3 && !_dataShipping.contains("Description")){
                    _dataShipping.add("Description");
                  }else if(value.length <= 3 && _dataShipping.contains("Description")){
                    _dataShipping.remove("Description");
                  }
                });
              },
              onEditingComplete: () => FocusScope.of(context).requestFocus(_priceFocus),
              textInputAction: TextInputAction.next,
              cursorColor: colorGreen,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color:  Colors.black),
                ),
              ),
              style: TextStyle(
                fontSize: 15 * scaleFactor,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 0.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "PRECIO",
                style: TextStyle(
                  color: colorText,
                  fontSize: 15 * scaleFactor,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 0.0),
            child: new TextFormField(
              controller: lowPrice,
              readOnly: _switchFree,
              maxLines: 1,
              inputFormatters: [  
                FilteringTextInputFormatter.digitsOnly,
              ],
              keyboardType: TextInputType.number,
              autofocus: false,
              focusNode: _priceFocus,
              onSaved: (value) => _price = value,
              onChanged: (value) {
                setState(() {
                  if (!value.contains("0,0") && !_dataShipping.contains("Price")){
                    _dataShipping.add("Price");
                  }else if(value.contains("0,0") || (value.contains("00") && value.length == 2) && _dataShipping.contains("Price")){
                    _dataShipping.remove("Price");
                  }
                });
              },
              validator: (value) => !_dataShipping.contains("Price")? 'Debe ingresar un precio Válido' : null,
              cursorColor: colorGreen,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30 * scaleFactor,
                color: colorGrey,
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
            padding: EdgeInsets.only(left: 30, right: 30),
            child: Divider(color:Colors.black,)
          ),

          Center(
            child: Padding(
              padding: EdgeInsets.only(top:30),
              child: Column(
                children: <Widget>[
                  Switch(
                    value: _switchFree ,
                    onChanged: (value) {
                      setState(() {
                        if(value && !_dataShipping.contains("Price"))
                          _dataShipping.add("Price");
                        
                        _switchFree = value;
                      });
                    },
                    activeTrackColor: colorGrey,
                    activeColor: colorGreen
                  ),
                  Text(
                    "Envíos gratis",
                    style: TextStyle(
                      color: colorText,
                      fontSize: 20 * scaleFactor,
                    ),
                  ),
                ],
              )
            ),
          ),
        ],
      )
    );
  }

  Widget buttonSave(){
    var scaleFactor = MediaQuery.of(context).textScaleFactor;
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => saveShipping(),
      child: Container(
        width:size.width - 100,
        height: size.height / 20,
        decoration: BoxDecoration(
          border: Border.all(
            color: colorGrey, 
            width: 1.0,
          ),
          color: _dataShipping.length ==2?  _statusButtonSave? colorGrey : colorGreen : colorGrey,
          borderRadius: BorderRadius.circular(30),
          ),
        child: Center(
          child: Text(
            index == null? "CREAR TARIFA" : "GUARDAR TARIFA",
            style: TextStyle(
              color: Colors.white,
              fontSize: 15 * scaleFactor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget buttonDelete(){
    var scaleFactor = MediaQuery.of(context).textScaleFactor;
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => deleteShipping(),
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
            "ELIMINAR TARIFA",
            style: TextStyle(
              color: _statusButtonDelete? colorGreen : Colors.white,
              fontSize: 15 * scaleFactor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  saveShipping()async{
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    var response, result;
    setState(() => _statusButtonSave = true);
    await Future.delayed(Duration(milliseconds: 150));
    setState(() => _statusButtonSave = false);
    if (_formKeyShipping.currentState.validate()) {
      _formKeyShipping.currentState.save();
      
      if(_switchFree)
        _price = "FREE";

      try
      {
        _onLoading();
        result = await InternetAddress.lookup('google.com'); //verify network
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          if(index == null){
            response = await http.post(
              urlApi+"newShipping",
              headers:{
                'Content-Type': 'application/json',
                'X-Requested-With': 'XMLHttpRequest',
                'authorization': 'Bearer ${myProvider.accessTokenUser}',
              },
              body: jsonEncode({
                "description": _description,
                "price": _price,
                "coin": _statusCoin,
              }),
            ); 
          }else{
            response = await http.post(
              urlApi+"updateShipping",
              headers:{
                'Content-Type': 'application/json',
                'X-Requested-With': 'XMLHttpRequest',
                'authorization': 'Bearer ${myProvider.accessTokenUser}',
              },
              body: jsonEncode({
                "id": myProvider.dataShipping[index].id,
                "description": _description,
                "price": _price,
                "coin": _statusCoin,
              }),
            ); 
          }
          
          var jsonResponse = jsonDecode(response.body); 
          print(jsonResponse); 
          if (jsonResponse['statusCode'] == 201) {
            myProvider.getListShipping();
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

  deleteShipping()async{
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

        response = await http.post(
          urlApi+"deleteShipping",
          headers:{
            'Content-Type': 'application/json',
            'X-Requested-With': 'XMLHttpRequest',
            'authorization': 'Bearer ${myProvider.accessTokenUser}',
          },
          body: jsonEncode({
            "id": myProvider.dataShipping[index].id,
          }),
        );         

        var jsonResponse = jsonDecode(response.body); 
        print(jsonResponse); 
        if (jsonResponse['statusCode'] == 201) {
          var dbctpaga = DBctpaga();
          dbctpaga.deleteShipping(myProvider.dataShipping[index].id);
          myProvider.getListShipping();
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
    var scaleFactor = MediaQuery.of(context).textScaleFactor;
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
                  color: colorGreen,
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
                    fontSize: 15 * scaleFactor,
                  )
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  Future<void> _onLoading() async {
    var scaleFactor = MediaQuery.of(context).textScaleFactor;

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
                    valueColor: new AlwaysStoppedAnimation<Color>(colorGreen),
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
                            fontSize: 15 * scaleFactor,
                          )
                        ),
                        TextSpan(
                          text: "...",
                          style: TextStyle(
                            color: colorGreen,
                            fontSize: 15 * scaleFactor,
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

  String validateDescription(value){
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    value.trim();
    if (value.length <=3){
      return 'Debe ingresar la descripción correctamente';
    }else{
      if(_descriptionData != value)
        for (var item in myProvider.dataShipping) {
          if (item.description == value)
            return 'La descripción ingresado ya se encuentra registrado';
        }

      return null;
    }
  }

}