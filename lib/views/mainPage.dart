import 'package:ctpaga/animation/slideRoute.dart';
import 'package:ctpaga/views/navbar/navbarMain.dart';
import 'package:ctpaga/views/productsServicesPage.dart';
import 'package:ctpaga/views/amountPage.dart';
import 'package:ctpaga/providers/provider.dart';
import 'package:ctpaga/models/user.dart';
import 'package:ctpaga/models/bank.dart';
import 'package:ctpaga/env.dart';
import 'package:ctpaga/views/salesReportPage.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with WidgetsBindingObserver{
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  User user = User();
  List bankUser = new List(2);
  Bank bankUserUSD = Bank();
  Bank bankUserBs = Bank();
  // ignore: unused_field
  int clickBotton = 0, _statusCoin = 0;
  DateTime currentBackPressTime;

  @override
  void initState() {
    super.initState();
    initialNotification();
    initialVariable();
    registerNotification();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void registerNotification() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    _firebaseMessaging.requestNotificationPermissions();

    _firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      print('onMessage: $message');
      showNotification(message['notification']['title'],message['notification']['body']);
      return;
    }, onResume: (Map<String, dynamic> message) {
      print('onResume: $message');
      showNotification(message['notification']['title'],message['notification']['body']);
      return;
    }, onLaunch: (Map<String, dynamic> message) {
      print('onLaunch: $message');
      showNotification(message['notification']['title'],message['notification']['body']);
      return;
    });

    _firebaseMessaging.getToken().then((token) {
      print("token: $token");
      prefs.setString('tokenFCM', token);
      myProvider.getTokenFCM = token;
      if(token != myProvider.dataUser.tokenFCM)
        myProvider.updateToken(token, context);
    }).catchError((err) {
      Fluttertoast.showToast(msg: err.message.toString());
    });
  }

  initialVariable(){
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    _statusCoin = myProvider.coinUsers;
  }

  // ignore: missing_return
  Future<bool> _onBackPressed(){
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    if(myProvider.statusButtonMenu){
      myProvider.statusButtonMenu = false;
    }else{
      DateTime now = DateTime.now();
      if (currentBackPressTime == null || now.difference(currentBackPressTime) > Duration(seconds: 2)) {
        currentBackPressTime = now;
        Fluttertoast.showToast(msg: "Presiona dos veces para salir de la aplicación");
        return Future.value(false);
      }
      exit(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget> [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                NavbarMain(),
                Expanded(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      buttonMain("Productos",1, ProductsServicesPage(true)), //send variable the same design
                      buttonMain("Servicios",2, ProductsServicesPage(true)), //send variable the same design
                      buttonMain("Monto",3, AmountPage()), //send variable the same design
                    ]
                  )
                ),
              ],
            ),
          ]
        )
      )
    );
  }
  

  Widget buttonMain(_title, _index, _page){
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: GestureDetector(
        onTap: () {
          setState(() => clickBotton = _index); //I add color selected button
          nextPage(_page, _index); //next page
        },
        child: Container(
          width:size.width - 100,
          height: size.height / 20,
          decoration: BoxDecoration(
            color: clickBotton == _index? colorGreen : colorGreyOp,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: AutoSizeText(
              _title,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'MontserratSemiBold',
              ),
              maxFontSize: 14,
              minFontSize: 14,
            ),
          ),
        ),
      )
    );
  }

  changeButtonCoin(coin){
    var myProvider = Provider.of<MyProvider>(context, listen: false);

    setState(() => _statusCoin = coin);
    myProvider.coinUsers = coin;
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
                  textAlign: TextAlign.center,
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

  nextPage(Widget page, _index)async{
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    await Future.delayed(Duration(milliseconds: 150)); //wait time
    setState(() => clickBotton = 0); //delete selected button color

    if(verifyDataCommerce(myProvider)){
      showMessage("Debe ingresar los datos de la empresa", false);
    }else if(verifyPicture(myProvider)){
      showMessage("Debe ingresar el logo de la empresa", false);
    }else if(myProvider.dataRates.length == 0){
      showMessage("Debe ingresar la tasa de cambio", false);
    }else{
      if(_index == 1){
        myProvider.clickButtonMenu = 3;
        myProvider.selectProductsServices = 0;
        myProvider.statusTrolleyAnimation = 1.0;
        myProvider.getListCategories();
      }else if(_index == 2){
        myProvider.clickButtonMenu = 4;
        myProvider.selectProductsServices = 1;
        myProvider.statusTrolleyAnimation = 1.0;
        myProvider.getListCategories();
      }else{
        myProvider.selectDateRate = 0;
        myProvider.statusTrolleyAnimation = 1.0;
        myProvider.statusRemoveShopping = false;
      }
      Navigator.push(context, SlideLeftRoute(page: page));
    }
  }

  verifyPicture(myProvider){
    for (var item in myProvider.dataPicturesUser) {
      if(item != null && item.description == 'Profile' && item.commerce_id == myProvider.dataCommercesUser[myProvider.selectCommerce].id){
        return false;
      }
    }
    return true;
  }

  verifyDataCommerce(myProvider){
    if(myProvider.dataCommercesUser.length != 0){
      if(myProvider.dataCommercesUser[myProvider.selectCommerce].rif != '' && myProvider.dataCommercesUser[myProvider.selectCommerce].name != '' && myProvider.dataCommercesUser[myProvider.selectCommerce].userUrl != '')
        return false;
    }

    return true;
  }

  void initialNotification() {
    var initializationSettingsAndroid = new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          (int id, String title, String body, String payload) async {});
    var initializationSettings = InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: selectNotification,);
  }

  Future selectNotification(String payload) async {
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    if(payload == "true"){
      myProvider.totalSales = 0;
      myProvider.dataReportSales=[];
      myProvider.getListPaids();
      List<String> weekDay = <String> ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
      DateTime _dateNow = DateTime.now();
      DateTime _initialDate = DateTime.now();
      DateTime _finalDate = DateTime.now();
      var formatterDay = new DateFormat('EEEE');
      int indexWeekDay =  weekDay.indexOf(formatterDay.format(_dateNow));
      var _firstDay = DateTime(_dateNow.year, _dateNow.month, _dateNow.day-indexWeekDay);
      var _lastDay = DateTime(_dateNow.year, _dateNow.month, _dateNow.day+(6-indexWeekDay));
      myProvider.verifyDataTransactions(0, 1, _dateNow, _firstDay, _lastDay, _initialDate, _finalDate);
      Navigator.push(context, SlideLeftRoute(page: SalesReportPage(false)));
    }
  }

  void showNotification(title, message) async {

    var android = AndroidNotificationDetails(
        'Message New id',
        'Message New name',
        'Message New description',
        priority: Priority.High,
        importance: Importance.Max,
    );


    var iOS = IOSNotificationDetails(presentSound: false);

    var platformChannelSpecifics = NotificationDetails(
    android, iOS);

    await flutterLocalNotificationsPlugin.show(
        0, title, message, platformChannelSpecifics, payload: "true"
      );

    FlutterRingtonePlayer.playNotification();

  }

}
