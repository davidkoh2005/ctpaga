
import 'package:ctpaga/views/navbar/navbar.dart';
import 'package:ctpaga/providers/provider.dart';
import 'package:ctpaga/env.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

class UpdatePasswordPage extends StatefulWidget {
  
  @override
  _UpdatePasswordPageState createState() => _UpdatePasswordPageState();
}

class _UpdatePasswordPageState extends State<UpdatePasswordPage> {
  final _formKeyChangePassword = new GlobalKey<FormState>();
  bool _statusButtonSave = false, passwordVisible = true;
  String? _passwordCurrent, _password;

  void initState() {
    super.initState();
  }

  void dispose(){
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    return WillPopScope(
      onWillPop: () async {
        if(myProvider.statusButtonMenu){
          myProvider.statusButtonMenu = false;
          return false;
        }else{
          myProvider.clickButtonMenu = 0;
          return true;
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Navbar("Cambiar contraseña", false),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: formChangePassword()
                  ),
                ]
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 30),
              child: buttonSave()
            ),
          ],
        ),
      )
    );
  }

  Widget formChangePassword(){
    return new Form(
      key: _formKeyChangePassword,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
            child: new TextFormField(
              autofocus: false,
              maxLines: 1,
              keyboardType: TextInputType.text,
              obscureText: passwordVisible,
              decoration: new InputDecoration(
                  labelText: 'Contraseña Actual',
                  labelStyle: TextStyle(
                    color: colorLogo,
                    fontFamily: 'MontserratSemiBold',
                  ),
                  icon: new Icon(
                    Icons.lock,
                    color: colorLogo
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      passwordVisible
                      ? Icons.visibility_off
                      : Icons.visibility,
                      color: colorLogo
                      ),
                    onPressed: () {
                      setState(() {
                          passwordVisible = !passwordVisible;
                      });
                    },
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: colorLogo),
                  ),
              ),
              validator: _validatePassword,
              onSaved: (String? value) => _passwordCurrent = value,
              textInputAction: TextInputAction.next,
              cursorColor: colorLogo,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
            child: new TextFormField(
              autofocus: false,
              maxLines: 1,
              keyboardType: TextInputType.text,
              obscureText: passwordVisible,
              decoration: new InputDecoration(
                  labelText: 'Contraseña Nueva',
                  labelStyle: TextStyle(
                    color: colorLogo,
                    fontFamily: 'MontserratSemiBold',
                  ),
                  icon: new Icon(
                    Icons.lock,
                    color: colorLogo
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      passwordVisible
                      ? Icons.visibility_off
                      : Icons.visibility,
                      color: colorLogo
                      ),
                    onPressed: () {
                      setState(() {
                          passwordVisible = !passwordVisible;
                      });
                    },
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: colorLogo),
                  ),
              ),
              validator: _validatePassword,
              onSaved: (String? value) => _password = value,
              textInputAction: TextInputAction.next,
              cursorColor: colorLogo,
              style: TextStyle(
                fontFamily: 'MontserratSemiBold',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
            child: new TextFormField(
              autofocus: false,
              maxLines: 1,
              keyboardType: TextInputType.text,
              obscureText: passwordVisible,
              decoration: new InputDecoration(
                  labelText: 'Confirmar Contraseña',
                  labelStyle: TextStyle(
                    color: colorLogo,
                    fontFamily: 'MontserratSemiBold',
                    fontSize:14,
                  ),
                  icon: new Icon(
                    Icons.lock,
                    color: colorLogo
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      passwordVisible
                      ? Icons.visibility_off
                      : Icons.visibility,
                      color: colorLogo,
                      ),
                    onPressed: () {
                      setState(() {
                          passwordVisible = !passwordVisible;
                      });
                    },
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: colorLogo),
                  ),
                ),
              validator: _validatePasswordConfirm,
              cursorColor: colorLogo,
              style: TextStyle(
                fontFamily: 'MontserratSemiBold',
                fontSize:14,
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
      onTap: () => savePassword() ,
      child: Container(
        width:size.width - 100,
        height: size.height / 20,
        decoration: BoxDecoration(
          border: Border.all(
            color: colorGrey, 
            width: 1.0,
          ),
          color: _statusButtonSave? colorGrey : colorLogo,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: AutoSizeText(
            "GUARDAR",
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

  
  savePassword()async{
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    var response, result;
    setState(() => _statusButtonSave = true);
    await Future.delayed(Duration(milliseconds: 150));
    setState(() => _statusButtonSave = false);
    if (_formKeyChangePassword.currentState!.validate()) {
      _formKeyChangePassword.currentState!.save();
      try
      {
        _onLoading();
        result = await InternetAddress.lookup('google.com'); //verify network
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          response = await http.post(
            Uri.parse(urlApi+"updatePassword"),
            headers:{
              'Content-Type': 'application/json',
              'X-Requested-With': 'XMLHttpRequest',
              'authorization': 'Bearer ${myProvider.accessTokenUser}',
            },
            body: jsonEncode({
              "current_password" : _passwordCurrent,
              "new_password" : _password,
            }),
          ); 
          var jsonResponse = jsonDecode(response.body); 
          print(jsonResponse);
          if (jsonResponse['statusCode'] == 201) {
            await myProvider.getDataUser(false, true, context);
            Navigator.pop(context);
          }else{
            Navigator.pop(context);
            showMessage(jsonResponse['message'], false);
          }
        }
      } on SocketException catch (_) {
        Navigator.pop(context);
        showMessage("Sin conexión a internet", false);
      }
      
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


  String? _validatePassword(String? value) {
    String errorValidate = 'La contraseña es inválida, debe tener:';
    if (value!.isEmpty) {
      // The form is empty
      return 'Ingrese una contraseña válido';
    }
    // This is just a regular expression for password
    String epUpperCase = "(?=.*[A-Z])";                 // should contain at least one upper case
    String epLowerCase = "(?=.*[a-z])";                    // should contain at least one lower case
    String epDigit= "(?=.*?[0-9])";                        // should contain at least one digit
    String epSpecialCharacter = "(?=.*?[-_!@#\$&*~])";  // should contain at least one Special character
    RegExp regExp = new RegExp(epUpperCase);

    if (!regExp.hasMatch(value)){
      errorValidate = errorValidate + '\n\n Una letra mayúscula.';
    }
    regExp = new RegExp(epLowerCase);
    if (!regExp.hasMatch(value)){
      errorValidate = errorValidate + '\n\n Una letra minúscula.';
    }
    regExp = new RegExp(epDigit);
    if (!regExp.hasMatch(value)){
      errorValidate = errorValidate + '\n\n .';
    }
    regExp = new RegExp(epSpecialCharacter);
    if (!regExp.hasMatch(value)){
      errorValidate = errorValidate + '\n\n Un Carácter Especial.';
    }

    if (value.length < 6){
      errorValidate = errorValidate + '\n\n Al menos 6 caracteres.';
    }

    if (errorValidate == 'La contraseña es inválida, debe tener:'){
      // So, the Password is valid
      _password = value;
      return null;
    }
    
    return errorValidate;

  }

  String? _validatePasswordConfirm(String? value) {
    if(value!.isNotEmpty){
      if (_password == value){
        return null;
      }
      return 'La contraseña no coincide';
    }
    return 'Ingrese una contraseña valido';
  }

}