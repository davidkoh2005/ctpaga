
import 'package:ctpaga/animation/slideRoute.dart';
import 'package:ctpaga/providers/provider.dart';
import 'package:ctpaga/views/loginPage.dart';
import 'package:ctpaga/env.dart';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:package_info/package_info.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

void main() async {
  runApp(MyApp());
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(messageHandler);
}

Future<void> messageHandler(RemoteMessage message) async {
  print('onMessage: $message');
  showNotification(message.notification!.title, message.notification!.body);
  return;
}

void initialNotification() {
    var initializationSettingsAndroid = new AndroidInitializationSettings('app_icon');
    
    var initializationSettingsIOS = IOSInitializationSettings(
      onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, 
      iOS: initializationSettingsIOS,
    );

    flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: selectNotification);
}

 Future onDidReceiveLocalNotification(
      int? id, String? title, String? body, String? payload) async {
    print('onDidReceiveLocalNotification');
  }

Future selectNotification(String? payload) async {
    
}

void showNotification(title, message) async {

    var androidNotificationDetails = AndroidNotificationDetails(
        'Message New id',
        'Message New name',
        priority: Priority.max,
        importance: Importance.max,
        playSound: true,
    );


    var iOSNotificationDetails = IOSNotificationDetails(presentSound: false);

    var platformChannelSpecifics = NotificationDetails(
      android: androidNotificationDetails,
      iOS:iOSNotificationDetails
    );

   await flutterLocalNotificationsPlugin.show(
        0, title, message, platformChannelSpecifics, payload: "true"
      );

    FlutterRingtonePlayer.play(
      android: AndroidSounds.notification,
      ios: IosSounds.glass,
    ); 

  }

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider( 
      create: (_) => MyProvider(),
      child: MaterialApp(
        title: 'Compralotodo',
        theme: ThemeData(
          primarySwatch: Colors.orange,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        supportedLocales: [
          Locale('es','ES'),
        ],
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        home: MyHomePage(title: 'Compralotodo'),
      )
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  String versionApp = "", newVersionApp = "" ;

  void initState() {
    super.initState();
    //changePage();
    checkVersion();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
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
                image: AssetImage("assets/logo/logo2.png"),
                width: size.width/2,
              ),
              Container(
                padding: EdgeInsets.only(top:5, bottom: 5),
                child: AutoSizeText(
                  "Cargando...",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'MontserratSemiBold',
                  ),
                  maxFontSize: 24,
                  minFontSize: 24,
                ),
              ),
              CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(colorLogo),
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
          Uri.parse(urlApi+"version"),
          headers:{
            'Content-Type': 'application/json',
            'X-Requested-With': 'XMLHttpRequest',
          },
          body: jsonEncode({
            'app': nameAppApi,
          }),
        ); 

        jsonResponse = jsonDecode(response.body);
        print(jsonResponse);
        if (jsonResponse['statusCode'] == 201) {
          if(info.version != jsonResponse['data']['version']){
            versionApp = info.version;
            newVersionApp = jsonResponse['data']['version'];
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
            title: Text(
              "Nueva versión",
              style: TextStyle(
                fontFamily: 'MontserratSemiBold',
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children:[
                Text(
                  "Versión Actual es $versionApp y la nueva versión es $newVersionApp.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontFamily: 'MontserratSemiBold',
                  ),
                ),
                SizedBox(height: 20,),
                Text(
                  "Por favor Actualice Ctpaga desde tu tienda favorita",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontFamily: 'MontserratSemiBold',
                  ),
                ),
              ]
            ),
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
      myProvider.coinUsers = 0;
      myProvider.accessTokenUser = prefs.getString('access_token')!;
      myProvider.selectCommerce = prefs.getInt('selectCommerce')!;
      myProvider.descriptionShipping = prefs.getString('descriptionShipping')!;
      myProvider.getDataUser(true, false, context);
      myProvider.dataPurchase = [];
      myProvider.statusButtonMenu = false;
      myProvider.clickButtonMenu = 0;
      myProvider.getTokenFCM = (prefs.containsKey('tokenFCM')? prefs.getString('tokenFCM') : null)!;
    }else{
      DefaultCacheManager().emptyCache();
      Navigator.pushReplacement(context, SlideLeftRoute(page: LoginPage()));
    }
  }
}
