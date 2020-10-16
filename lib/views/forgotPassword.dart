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
        body:Container(
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              Image(
                image: AssetImage("assets/logo/logo.png"),
                width: size.width/2,
              ),

              formEmail(),
              buttonNext(),

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
              validator: (value) => value.isEmpty? 'Email no puede estar vacío' : null ,
              onSaved: (value) => _email = value.trim(),
              textInputAction: TextInputAction.next,
            ),
          ),
        ],
      ),
    );
  }

  Widget buttonNext(){
    var size = MediaQuery.of(context).size;
    return  GestureDetector(
      onTap: () => clickButtonNext(),
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
            'Siguiente',
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

  void clickButtonNext() async{
    if (_formKeyForgotPassword.currentState.validate()) {
      _formKeyForgotPassword.currentState.save();
      //_onLoading();
    }
  }
}