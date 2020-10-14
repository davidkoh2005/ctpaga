import 'package:ctpaga/animation/slideRoute.dart';
import 'package:ctpaga/views/forgotPassword.dart';
import 'package:ctpaga/views/registerPage.dart';
import 'package:ctpaga/views/mainPage.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKeyLogin = new GlobalKey<FormState>();
  final FocusNode _emailFocus = FocusNode();  
  final FocusNode _passwordFocus = FocusNode();
  final _passwordController = TextEditingController();
  String _email, _password;
  bool passwordVisible = true;

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
                  formLogin(),
                buttonLogin(),
                Padding(padding: EdgeInsets.only(top:20)),
                buttonRegister(),
              ]
            ),
          ),
        ),
      ),
    );
  }

  Widget formLogin(){
    return new Form(
      key: _formKeyLogin,
      child: new ListView(
        shrinkWrap: true,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 0.0),
            child: new TextFormField(
              maxLines: 1,
              keyboardType: TextInputType.emailAddress,
              autofocus: false,
              focusNode: _emailFocus,
              onEditingComplete: () => FocusScope.of(context).requestFocus(_passwordFocus),
              decoration: new InputDecoration(
                  labelText: "Email",
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
              onSaved: (value) => _email = value.trim(),
              textInputAction: TextInputAction.next,
              cursorColor: Colors.green,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 0.0),
            child: new TextFormField(
              controller: _passwordController,
              maxLines: 1,
              autofocus: false,
              keyboardType: TextInputType.text,
              obscureText: passwordVisible,
              focusNode: _passwordFocus,
              decoration: new InputDecoration(
                  labelText: "Contraseña",
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
              validator: (value) => value.isEmpty? 'Ingrese una contraseña válido': null,
              onSaved: (value) => _password = value.trim(),
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (term){
                FocusScope.of(context).requestFocus(new FocusNode());
                clickButtonLogin();
              },
              cursorColor: Colors.green,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
            child: FlatButton(
              onPressed: () {
                _passwordController.clear();
                Navigator.push(context, SlideLeftRoute(page: ForgotPassword()));
              },
              child: Text(
                "Olvidé mi contraseña?",
                style: TextStyle(
                  color: Colors.green,
                ),
              )
            )
          ),
        ],
      ),
    );
  }

  Widget buttonLogin(){
    var size = MediaQuery.of(context).size;
    return  GestureDetector(
      onTap: () => clickButtonLogin(),
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
            'Ingresar',
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

  Widget buttonRegister(){
    var size = MediaQuery.of(context).size;
    return  GestureDetector(
      onTap: () => Navigator.push(context, SlideLeftRoute(page: RegisterPage())),
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
            'Registrar',
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

  void clickButtonLogin() async{
    Navigator.push(context, SlideLeftRoute(page: MainPage()));
    /* if (_formKeyLogin.currentState.validate()) {
      _formKeyLogin.currentState.save();
      //_onLoading();
    } */
  }

}