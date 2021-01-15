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
import 'package:pusher_websocket_flutter/pusher.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
  Channel _channel;
  User user = User();
  List bankUser = new List(2);
  Bank bankUserUSD = Bank();
  Bank bankUserBs = Bank();
  // ignore: unused_field
  int clickBotton = 0, _statusCoin = 0;

  @override
  void initState() {
    super.initState();
    initialNotification();
    initialVariable();
    initialPusher();
  }

  @override
  void dispose() {
    super.dispose();
  }

  initialVariable(){
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    _statusCoin = myProvider.coinUsers;
  }

  Future<void> initialPusher() async{
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    try {
      PusherOptions options = PusherOptions(
        host: url.replaceAll(':8000', ''),
        port: 6001,
        encrypted: false,
      );
      await Pusher.init("local",options);
    } catch (e) {
      print(e);
    }

    Pusher.connect(
      onConnectionStateChange: (val){
        print(val.currentState);
      },
      onError: (err) {
        print(err.message);
      }
    );

    _channel = await Pusher.subscribe("channel-ctpaga");

    _channel.bind("event-ctpaga", (onEvent) { 
      var notification = jsonDecode(onEvent.data);
      print(onEvent.data);

      if(myProvider.dataCommercesUser[myProvider.selectCommerce].id == notification['data']['commerce_id'])
        if(notification['data']['coin'] == 0)
          showNotification("Recibiste un pago de \$ ${notification['data']['total']}");
        else
          showNotification("Recibiste un pago de Bs ${notification['data']['total']}");
        
    });

  }

  @override
  Widget build(BuildContext context) {
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    return WillPopScope(
      onWillPop: () async {
        if(myProvider.statusButtonMenu){
          myProvider.statusButtonMenu = false;
        }
        
        return false;
      },
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
    var scaleFactor = MediaQuery.of(context).textScaleFactor;
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
            child: Text(
              _title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15 * scaleFactor,
                fontWeight: FontWeight.bold,
                fontFamily: 'MontserratSemiBold',
              ),
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
    var scaleFactor = MediaQuery.of(context).textScaleFactor;
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
                    fontSize: 15 * scaleFactor,
                    fontFamily: 'MontserratSemiBold',
                  )
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
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: selectNotification,);
  }

  Future selectNotification(String payload) async {
    if(payload == "true")
      Navigator.push(context, SlideLeftRoute(page: SalesReportPage(false)));
  }

  void showNotification(message) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'Message New id',
        'Message New name',
        'Message New description',
        importance: Importance.max,
        priority: Priority.high,
    );

    var iOS = IOSNotificationDetails();
    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics, iOS:  iOS);

    await flutterLocalNotificationsPlugin.show(
        0, "Nuevo Pago Recibido", message, platformChannelSpecifics, payload: "true"
      );

  }

}
