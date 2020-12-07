import 'package:ctpaga/env.dart';

import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKeyForgotPassword = new GlobalKey<FormState>();
  final FocusNode _emailFocus = FocusNode(); 
  String _email;

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;

    return Center(
      child: Scaffold(
        backgroundColor: Colors.white,
        body:Container(
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              Image(
                image: AssetImage("assets/logo/logo.png"),
                width: size.width/2,
              ),

              formEmail(),// form Email
              buttonSend(), //button send

            ]
          ),
        ),
      ),
    );
  }

  Widget formEmail(){
    return new Form(
      key: _formKeyForgotPassword,
      child: new ListView(
        shrinkWrap: true,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 50.0),
            child: new TextFormField(
              maxLines: 1,
              keyboardType: TextInputType.emailAddress,
              autofocus: false,
              focusNode: _emailFocus,
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              decoration: new InputDecoration(
                  hintText: "Email",
                  icon: new Icon(
                    Icons.mail,
                    color: colorGreen,
                  )
              ),
              validator: _validateEmail ,
              onSaved: (value) => _email = value.trim(),
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (term){
                FocusScope.of(context).requestFocus(new FocusNode()); //save the keyboard
                clickButtonSend(); //process to be performed when you press the submit button
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buttonSend(){
    var scaleFactor = MediaQuery.of(context).textScaleFactor;
    var size = MediaQuery.of(context).size;
    return  GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode()); //save the keyboard
        clickButtonSend(); //process to be performed when you press the submit button
      },
      child: Container(
        width:size.width - 100,
        height: size.height / 14,
        decoration: BoxDecoration(
          border: Border.all(
            color: colorGreen, 
            width: 1.0,
          ),
          gradient: LinearGradient(
            colors: [
              colorGreen,
              colorGreen,
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
            'Enviar',
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

  void clickButtonSend(){
    if (_formKeyForgotPassword.currentState.validate()) {
      _formKeyForgotPassword.currentState.save();
      //_onLoading();
      //TODO: Enviar Correo
    }
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
      return null;     
    }

    // The pattern of the email didn't match the regex above.
    return 'Ingrese un email válido';
  }
}