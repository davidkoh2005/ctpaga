
import 'package:ctpaga/database.dart';
import 'package:ctpaga/views/navbar/navbar.dart';
import 'package:ctpaga/providers/provider.dart';
import 'package:ctpaga/env.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:io';

class NewDiscountPage extends StatefulWidget {
  NewDiscountPage(this.index);
  final int index;
  @override
  _NewDiscountPageState createState() => _NewDiscountPageState(index);
}

class _NewDiscountPageState extends State<NewDiscountPage> {
  _NewDiscountPageState(this.index);
  final int index;
  final _formKeyDiscount = new GlobalKey<FormState>();
  final _controllerCode= TextEditingController();
  final _controllerPercentage= TextEditingController();
  final FocusNode _percentageFocus = FocusNode();
  bool _statusButtonSave = false, _statusButtonDelete = false;
  String _code;
  int _percentage;
  List _dataDiscount = new List();

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
    
    if(index != null){
      _controllerCode.text = myProvider.dataDiscount[index].code;
      _controllerPercentage.text = myProvider.dataDiscount[index].percentage.toString();
      setState(() {
        _dataDiscount.add("Code");
        _dataDiscount.add("Percentage");
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
          Navbar("Nuevo descuento", false),
          Expanded(
            child: formDiscount(),
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

  Widget formDiscount(){
    return new Form(
      key: _formKeyDiscount,
      child: ListView (
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: AutoSizeText(
                "CÓDIGO",
                style: TextStyle(
                  color: colorText,
                  fontFamily: 'MontserratSemiBold',
                ),
                maxFontSize: 14,
                minFontSize: 14,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 0.0),
            child: new TextFormField(
              controller: _controllerCode,
              maxLines: 1,
              inputFormatters: [
                UpperCaseTextFormatter(),
              ],
              textCapitalization:TextCapitalization.none,
              autofocus: false,
              validator: validateCode,
              maxLength: 20,
              onSaved: (value) => _code = value.trim(),
              onChanged: (value) {
                setState(() {
                  if (value.length >3 && !_dataDiscount.contains("Code")){
                    _dataDiscount.add("Code");
                  }else if(value.length <= 3 && _dataDiscount.contains("Code")){
                    _dataDiscount.remove("Code");
                  }
                });
              },
              onEditingComplete: () => FocusScope.of(context).requestFocus(_percentageFocus),
              textInputAction: TextInputAction.next,
              cursorColor: colorLogo,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color:  Colors.black),
                ),
              ),
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'MontserratSemiBold',
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 0.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: AutoSizeText(
                "DESCUENTO (%)",
                style: TextStyle(
                  color: colorText,
                  fontFamily: 'MontserratSemiBold',
                ),
                maxFontSize: 14,
                minFontSize: 14,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 0.0),
            child: new TextFormField(
              controller: _controllerPercentage,
              maxLines: 1,
              inputFormatters: [  
                FilteringTextInputFormatter.digitsOnly,
              ],
              keyboardType: TextInputType.number,
              autofocus: false,
              validator: (value)=> value.isNotEmpty? (int.parse(value) > 0 && int.parse(value) < 100)? null: 'Debe ingresar el descuento correctamente':'Debe ingresar el descuento correctamente',
              onSaved: (value) => _percentage = int.parse(value.trim()),
              onChanged: (value) {
                setState(() {
                  _dataDiscount.remove("Percentage");
                  if (value.isNotEmpty)
                    if (int.parse(value) > 0 && int.parse(value) <= 100){
                      if(!_dataDiscount.contains("Percentage"))
                        _dataDiscount.add("Percentage");
                    }
                }); 
              }, 
              cursorColor: colorLogo,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: "50",
                hintStyle: TextStyle(
                  fontSize: 20,
                  fontFamily: 'MontserratSemiBold',
                  color: colorGrey,
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color:  Colors.black),
                ),
              ),
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'MontserratSemiBold',
              ),
            ),
          ),
        ],
      )
    );
  }

  Widget buttonSave(){
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => saveDiscount(),
      child: Container(
        width:size.width - 100,
        height: size.height / 20,
        decoration: BoxDecoration(
          border: Border.all(
            color: colorGrey, 
            width: 1.0,
          ),
          color: _dataDiscount.length == 2?  _statusButtonSave? colorGrey : colorLogo : colorGrey,
          borderRadius: BorderRadius.circular(30),
          ),
        child: Center(
          child: AutoSizeText(
            index == null? "CREAR DESCUENTO" : "GUARDAR DESCUENTO",
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

  Widget buttonDelete(){
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => deleteDiscounts(),
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
            "ELIMINAR DESCUENTO",
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

  saveDiscount()async{
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    var response, result;
    setState(() => _statusButtonSave = true);
    await Future.delayed(Duration(milliseconds: 150));
    setState(() => _statusButtonSave = false);
    if (_formKeyDiscount.currentState.validate()) {
      _formKeyDiscount.currentState.save();
      try
      {
        _onLoading();
        result = await InternetAddress.lookup('google.com'); //verify network
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          if(index ==null){
            response = await http.post(
              urlApi+"newDiscounts",
              headers:{
                'Content-Type': 'application/json',
                'X-Requested-With': 'XMLHttpRequest',
                'authorization': 'Bearer ${myProvider.accessTokenUser}',
              },
              body: jsonEncode({
                "code": _code,
                "percentage": _percentage,
              }),
            ); 
          }else{
            response = await http.post(
              urlApi+"updateDiscounts",
              headers:{
                'Content-Type': 'application/json',
                'X-Requested-With': 'XMLHttpRequest',
                'authorization': 'Bearer ${myProvider.accessTokenUser}',
              },
              body: jsonEncode({
                "id": myProvider.dataDiscount[index].id,
                "code": _code,
                "percentage": _percentage,
              }),
            ); 
          }
          
          var jsonResponse = jsonDecode(response.body); 
          print(jsonResponse); 
          if (jsonResponse['statusCode'] == 201) {
            await myProvider.getListDiscounts();
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

  deleteDiscounts()async{
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
          urlApi+"deleteDiscounts",
          headers:{
            'Content-Type': 'application/json',
            'X-Requested-With': 'XMLHttpRequest',
            'authorization': 'Bearer ${myProvider.accessTokenUser}',
          },
          body: jsonEncode({
            "id": myProvider.dataDiscount[index].id,
          }),
        );         

        var jsonResponse = jsonDecode(response.body); 
        print(jsonResponse); 
        if (jsonResponse['statusCode'] == 201) {
          var dbctpaga = DBctpaga();
          dbctpaga.deleteDiscounts(myProvider.dataDiscount[index].id);
          myProvider.getListDiscounts();
          
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

  String validateCode(value){
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    value.trim();
    if (value.length <=3){
      return 'Debe ingresar el código correctamente';
    }else{
      for (var item in myProvider.dataDiscount) {
        if (item.code == value)
          return 'El código ingresado ya se encuentra registrado';
      }
      return null;
    }
  }

}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text?.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
