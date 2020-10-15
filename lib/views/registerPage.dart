import 'package:ctpaga/animation/slideRoute.dart';
import 'package:ctpaga/env.dart';
import 'package:ctpaga/views/mainPage.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:io';

class RegisterPage extends StatefulWidget {

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKeyRegister = new GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final FocusNode _nameFocus = FocusNode(); 
  final FocusNode _addressFocus = FocusNode();  
  final FocusNode _phoneFocus = FocusNode();  
  final FocusNode _emailFocus = FocusNode();  
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _passwordConfirmFocus = FocusNode();
  String _name, _address, _phone, _email, _password, _passwordConfirm, _messageError;
  bool passwordVisible = true, _statusError = false;
  var jsonResponse;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Center(
      child: Scaffold(
        body: Container(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                  Image(
                  image: AssetImage("assets/logo/logo.png"),
                  width: size.width/2,
                ),
                
                formRegister(),
                buttonRegister(),
              ]
            ),
          ),
        ),
      ),
    );
  }

  Widget formRegister(){
    return new Form(
      key: _formKeyRegister,
      child: new ListView(
        shrinkWrap: true,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
            child: new TextFormField(
              autofocus: false,
              focusNode: _nameFocus,
              onEditingComplete: () => FocusScope.of(context).requestFocus(_addressFocus),
              textCapitalization:TextCapitalization.words,
              inputFormatters: [
                WhitelistingTextInputFormatter(RegExp("[a-zA-Z\ áéíóúÁÉÍÓÚñÑ\s]")),
                BlacklistingTextInputFormatter(RegExp("[/\\\\]")),
              ], 
              decoration: InputDecoration(
                icon: Icon(Icons.person, color: Colors.green),
                labelText: 'Nombre y Apellido',
                labelStyle: TextStyle(
                  color: Colors.green
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
              ),
              onSaved: (String value) => _name = value,
              validator: _validateName,
              textInputAction: TextInputAction.next,
              cursorColor: Colors.green,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
            child: new TextFormField(
              autofocus: false,
              focusNode: _addressFocus,
              onEditingComplete: () => FocusScope.of(context).requestFocus(_phoneFocus),
              textCapitalization:TextCapitalization.sentences,
              decoration: InputDecoration(
                icon: Icon(Icons.home, color: Colors.green),
                labelText: 'Dirección',
                labelStyle: TextStyle(
                  color: Colors.green
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
              ),
              onSaved: (String value) => _address = value,
              validator: _validateAddress,
              textInputAction: TextInputAction.next,
              cursorColor: Colors.green,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
            child: new TextFormField(
              autofocus: false,
              focusNode: _phoneFocus,
              onEditingComplete: () => FocusScope.of(context).requestFocus(_emailFocus),
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                icon: Icon(Icons.phone, color: Colors.green),
                labelText: 'Teléfono',
                labelStyle: TextStyle(
                  color: Colors.green
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
              ),
              onSaved: (String value) => _phone = value,
              validator: _validatePhone,
              textInputAction: TextInputAction.next,
              cursorColor: Colors.green,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
            child: new TextFormField(
              autofocus: false,
              maxLines: 1,
              keyboardType: TextInputType.emailAddress,
              focusNode: _emailFocus,
              onEditingComplete: () => FocusScope.of(context).requestFocus(_passwordFocus),
              decoration: new InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(
                    color: Colors.green
                  ),
                  icon: new Icon(
                    Icons.mail,
                    color: Colors.green,
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
              ),
              validator: _validateEmail,
              onSaved: (String value) => _email = value,
              textInputAction: TextInputAction.next,
              cursorColor: Colors.green,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
            child: new TextFormField(
              autofocus: false,
              maxLines: 1,
              keyboardType: TextInputType.text,
              obscureText: passwordVisible,
              focusNode: _passwordFocus,
              onEditingComplete: () => FocusScope.of(context).requestFocus(_passwordConfirmFocus),
              decoration: new InputDecoration(
                  labelText: 'Contraseña',
                  labelStyle: TextStyle(
                    color: Colors.green
                  ),
                  icon: new Icon(
                    Icons.lock,
                    color: Colors.green
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      passwordVisible
                      ? Icons.visibility_off
                      : Icons.visibility,
                      color: Colors.green
                      ),
                    onPressed: () {
                      setState(() {
                          passwordVisible = !passwordVisible;
                      });
                    },
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
              ),
              validator: _validatePassword,
              onSaved: (String value) => _password = value,
              textInputAction: TextInputAction.next,
              cursorColor: Colors.green,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
            child: new TextFormField(
              autofocus: false,
              maxLines: 1,
              keyboardType: TextInputType.text,
              obscureText: passwordVisible,
              focusNode: _passwordConfirmFocus,
              decoration: new InputDecoration(
                  labelText: 'Confirmar Contraseña',
                  labelStyle: TextStyle(
                    color: Colors.green
                  ),
                  icon: new Icon(
                    Icons.lock,
                    color: Colors.green
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      passwordVisible
                      ? Icons.visibility_off
                      : Icons.visibility,
                      color: Colors.green,
                      ),
                    onPressed: () {
                      setState(() {
                          passwordVisible = !passwordVisible;
                      });
                    },
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
              validator: _validatePasswordConfirm,
              onSaved: (String value) => _passwordConfirm = value,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (term){
                FocusScope.of(context).requestFocus(new FocusNode());
                _clickButtonRegister();
              },
              cursorColor: Colors.green,
            ),
          ),

          _statusError ? Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 15.0, 0.0, 50.0),
                child: Text(
                  _messageError == null? '' : _messageError,
                  style: TextStyle(
                    color: Colors.red
                  ),
                ),
              ),
            )
          : Padding(padding: EdgeInsets.only(top: 50.0)),
        ],
      ),
    );
  }

  Widget buttonRegister(){
    var size = MediaQuery.of(context).size;
    return  GestureDetector(
      onTap: () => _clickButtonRegister(),
      child: Container(
        width:size.width - 100,
        height: size.height / 14,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.green, 
            width: 1.0,
          ),
          gradient: LinearGradient(
            colors: [
              Colors.green,
              Colors.green,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(5, 5),
              blurRadius: 10,
            )
          ],
        ),
        child: Center(
          child: Text(
            'Registrar Cuenta',
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

  _clickButtonRegister() async{
    setState(() {
      _statusError = false;
    });
    if (_formKeyRegister.currentState.validate()) {
      _formKeyRegister.currentState.save();
      
      _onLoading();

      var result, response;

      try {
        result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

          response = await http.post(
            urlApi+"signup/",
            headers: <String, String>{
              'Content-Type': 'application/json',
              'X-Requested-With': 'XMLHttpRequest',
            },
            body: jsonEncode({
              'name': _name,
              'email': _email,
              'password': _password,
              'password_confirmation': _passwordConfirm,
              'address': _address,
              'phone': _phone,
            }),
          );
          
          jsonResponse = jsonDecode(response.body);
          if (jsonResponse['statusCode'] == 201) {
            //TODO: Falta obtener el token
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('access_token', jsonResponse['access_token']);
            Navigator.pop(context);
            Navigator.pushReplacement(context, SlideLeftRoute(page: MainPage()));
          } else if(jsonResponse['errors'] != null){
            setState(() {
              _statusError = true;
              _messageError = 'El correo ya se encuentra registrado.';
            });
            Navigator.pop(context);
            //print('Request failed: ${jsonResponse.message}.');
          }  
        }
      } on SocketException catch (_) {
        setState(() {
          _statusError = true;
          _messageError = "Sin conexión, inténtalo de nuevo mas tarde";
        });
        Navigator.pop(context);
      } 
    }
  }

  Future<void> _onLoading() async {
    var size = MediaQuery.of(context).size;

    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(5),
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.green),
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
                          color: Colors.white,
                          fontSize: size.width / 20,
                        )
                      ),
                      TextSpan(
                        text: "...",
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: size.width / 20,
                        )
                      ),
                    ]
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
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
    return 'Ingrese nombre y apellido válido';
  }

  String _validateAddress(String value) {
    // This is just a regular expression for address
    String p = '[a-zA-Z]';
    RegExp regExp = new RegExp(p);

    if (regExp.hasMatch(value) && value.length >=3) {
      // So, the address is valid
      _address = value;
      return null;
    }

    // The pattern of the address didn't match the regex above.
    return 'Ingrese una dirección válido';
  }

  String _validatePhone(String value) {
    // This is just a regular expression for phone
    String p = r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$';
    RegExp regExp = new RegExp(p);

    if (value.isNotEmpty && regExp.hasMatch(value) && value.length >=3) {
      // So, the phone is valid
      _phone = value;
      return null;
    }

    // The pattern of the phone didn't match the regex above.
    return 'Ingrese un número de teléfono válido';
  }

  String _validateEmail(String value) {
    value = value.trim().toLowerCase();
    // This is just a regular expression for email addresses
    String p = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
        "\\@" +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
        "(" +
        "\\." +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
        ")+";
    RegExp regExp = new RegExp(p);

    if (value.isNotEmpty &&regExp.hasMatch(value)) {
      _email = value;
      return null;     
    }

    // The pattern of the email didn't match the regex above.
    return 'Ingrese un email válido';
  }


  String _validatePassword(String value) {
    String errorValidate = 'La contraseña es inválida, debe tener:';
    if (value.isEmpty) {
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
      errorValidate = errorValidate + '\n\n Un número numérico';
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

  String _validatePasswordConfirm(String value) {
    if(value.isNotEmpty){
      if (_password == value){
        _passwordConfirm = value;
        return null;
      }
      return 'La contraseña no coincide';
    }
    return '';
  }
}