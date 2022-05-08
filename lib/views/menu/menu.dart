import 'package:ctpaga/animation/slideRoute.dart';
import 'package:ctpaga/providers/provider.dart';
import 'package:ctpaga/env.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:io';

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  List statusButton = [];

  @override
  Widget build(BuildContext context) {
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    var size = MediaQuery.of(context).size;
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            color: colorLogo.withOpacity(0.8),
            child: ListView.builder(
              itemCount: listMenu.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  onTap: () => nextPage(listMenu[index]['code'], listMenu[index]['page'], index),
                  leading: Visibility(
                    visible: listMenu[index]['icon'] == ''? false : true,
                    child: Image.asset(
                      listMenu[index]['icon'],
                      color: statusButton.contains(index)? Colors.black : Colors.white,
                      width: size.height/20,
                      height: size.height/20,
                    )
                  ),
                  title: AutoSizeText(
                    listMenu[index]['title'],
                    style: TextStyle(
                      color: statusButton.contains(index)? Colors.black : Colors.white,
                      fontWeight: listMenu[index]['title'] == "Cerrar sesión"? FontWeight.bold : statusButton.contains(index)? FontWeight.bold : FontWeight.normal,
                      fontFamily: 'MontserratSemiBold',
                    ),
                    maxFontSize: 14,
                    minFontSize: 14,
                  ),
                );
              },
            )
          )
        ),
        Align(
          alignment: Alignment(0, -0.9),
          child: GestureDetector(
            onTap: () => myProvider.statusButtonMenu = false,
            child: ClipPath(
              clipper: CustomMenuClipper() ,
              child: Container(
                width: 36,
                height: 110,
                color: colorLogo.withOpacity(0.8),
                child: Icon(Icons.chevron_left, size: 30,),
              )
            )
          )
        )
      ],
    );
  }

 

  nextPage(code, page, index)async{
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    setState(() =>statusButton.add(index));
    await Future.delayed(Duration(milliseconds: 150));
    setState(() =>statusButton.remove(index));
    
    if(code == myProvider.clickButtonMenu)
      myProvider.statusButtonMenu = false;
    else if(code == 3 || code == 4){
      if(verifyDataCommerce(myProvider)){
        showMessage("Debe ingresar los datos de la empresa", false);
      }else if(myProvider.dataRates.length == 0 ){
        showMessage("Debe ingresar la tasa de cambio", false);
      }else{
        if(code == 3){
          myProvider.selectProductsServices = 0;
          myProvider.statusTrolleyAnimation = 1.0;
          myProvider.getListCategories();
        }else if(code == 4){
          myProvider.selectProductsServices = 1;
          myProvider.statusTrolleyAnimation = 1.0;
          myProvider.getListCategories();
        }
        myProvider.statusButtonMenu = false;
        await Future.delayed(Duration(milliseconds: 150));
        myProvider.clickButtonMenu = code;
        Navigator.push(context, SlideLeftRoute(page: page));
      }
    }else if(code == 12){
      _onLoading();
      var myProvider = Provider.of<MyProvider>(context, listen: false);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var result, response, jsonResponse;
      try {
        result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          response = await http.post(
            Uri.parse(urlApi+"logout"),
            headers:{
              'Content-Type': 'application/json',
              'X-Requested-With': 'XMLHttpRequest',
              'authorization': 'Bearer ${myProvider.accessTokenUser}',
            },
          );

          jsonResponse = jsonDecode(response.body); 
          print(jsonResponse);
          prefs.remove("access_token");
          prefs.remove('selectCommerce');
          myProvider.removeSession(context, false);
          Navigator.pop(context);
          myProvider.statusButtonMenu = false;
          await Future.delayed(Duration(milliseconds: 150));
          myProvider.clickButtonMenu = 0;
          Navigator.pushReplacement(context, SlideLeftRoute(page: page));
        }
      } on SocketException catch (_) {
        Navigator.pop(context);
        showMessage("Sin conexión a internet. Intentalo de nuevo!", false);
      } 
    }else if(code == 10){
      myProvider.clickButtonMenu = 0;
      launchWhatsApp(false);
    }else if(code == 11){
      myProvider.clickButtonMenu = 0;
      launchWhatsApp(true);
    }else{
      myProvider.statusButtonMenu = false;
      myProvider.selectDateRate = 0;
      
      if(code == 1){
         myProvider.getDataUser(false, false, context);
      }else if(myProvider.listCommerces.length != 0){
        if(code == 2){
          myProvider.getListBalances();
        }

        if(code == 8){
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
        }
      }
      myProvider.statusUrlCommerce = false;
      myProvider.clickButtonMenu = code;
      await Future.delayed(Duration(milliseconds: 150));
      Navigator.push(context, SlideLeftRoute(page: page));
    }
  }

  verifyDataCommerce(myProvider){
    if(myProvider.dataCommercesUser.length != 0){
      if(myProvider.dataCommercesUser[myProvider.selectCommerce].rif != '' && myProvider.dataCommercesUser[myProvider.selectCommerce].name != '' && myProvider.dataCommercesUser[myProvider.selectCommerce].userUrl != '')
        return false;
    }

    return true;
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
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: size.width / 20,
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

  void launchWhatsApp(status) async {
    String url() {
      if(status){
        if (Platform.isIOS) {
          return "whatsapp://wa.me/$phoneCt/?text=$messageHelp";
        } else {
          return "whatsapp://send?phone=$phoneCt&text=$messageHelp";
        }
      }else{
        if (Platform.isIOS) {
          return "whatsapp://wa.me/?text=$recommend";
        } else {
          return "whatsapp://send?text=$recommend";
        }
      }
    }

    if (await canLaunch(url())) {
      await launch(url());
    } else {
      throw 'Could not launch ${url()}';
    }
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
}

class CustomMenuClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Paint paint = Paint();
    paint.color = Colors.white;

    final width = size.width;
    final height = size.height;

    Path path = Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(0, 8, 10, 16);
    path.quadraticBezierTo(width - 1, height / 2 - 20, width, height / 2);
    path.quadraticBezierTo(width + 1, height / 2 + 20, 10, height - 16);
    path.quadraticBezierTo(0, height - 8, 0, height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}