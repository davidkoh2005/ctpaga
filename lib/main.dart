import 'package:ctpaga/animation/slideRoute.dart';
import 'package:ctpaga/providers/provider.dart';
import 'package:ctpaga/views/loginPage.dart';
import 'package:ctpaga/env.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info/package_info.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

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
  String versionApp = "", newVersionApp = "" , urlApp;
  void initState() {
    super.initState();
    //changePage();
    checkVersion();
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

  checkVersion()async{
    var result, response, jsonResponse;
    final PackageInfo info = await PackageInfo.fromPlatform();
    try {
      result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        response = await http.post(
          urlApi+"version",
          headers:{
            'Content-Type': 'application/json',
            'X-Requested-With': 'XMLHttpRequest',
          },
        ); 

        jsonResponse = jsonDecode(response.body);
        print(jsonResponse);
        if (jsonResponse['statusCode'] == 201) {
          if(info.version != jsonResponse['data'][0]['version']){
            versionApp = info.version;
            newVersionApp = jsonResponse['data'][0]['version'];
            urlApp = jsonResponse['data'][0]['url'];
            showAlert();
          }else{
            changePage();
          }
        }else{
          print("Error Network");
          changePage();
        }
      }
    } on SocketException catch (_) {
      print("Error Network");
      changePage();
    }
  }

  showAlert(){
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async =>false,
          child: AlertDialog(
            title: Text("Nueva versión"),
            content: Text("Versión Actual es $versionApp y la nueva versión es $newVersionApp "),
            actions: <Widget>[
              FlatButton(
                child: Text('Update'),
                onPressed: () {
                  launch(urlApp);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  changePage() async{
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // timeout and then shows login and registration or main page
    await Future.delayed(Duration(seconds: 2));
    if(prefs.containsKey('access_token')){
      myProvider.getDataUser(true, context);
      myProvider.coinUsers = 1;
      myProvider.accessTokenUser = prefs.getString('access_token');
      myProvider.selectCommerce = prefs.getInt('selectCommerce');
    }else{
      Navigator.pushReplacement(context, SlideLeftRoute(page: LoginPage()));
    }
  }
}
