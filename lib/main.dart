import 'package:ctpaga/animation/slideRoute.dart';
import 'package:ctpaga/providers/provider.dart';
import 'package:ctpaga/views/loginPage.dart';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider( 
      create: (_) => MyProvider(),
      child: MaterialApp(
        title: 'Ctpaga',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MyHomePage(title: 'Ctpaga'),
      )
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  void initState() {
    super.initState();
    changePage();
  }

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async =>false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                image: AssetImage("assets/logo/logo.png"),
                width: size.width/2,
              ),
            ]
          ),
        ),
      ),
    );
  }

  changePage() async{
    // timeout and then shows login and registration
    await Future.delayed(Duration(seconds: 2));
    //TODO: verificar si esta logueado
    Navigator.pushReplacement(context, SlideLeftRoute(page: LoginPage()));
  }
}
