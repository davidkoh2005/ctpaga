
import 'package:ctpaga/views/navbar/navbar.dart';
import 'package:ctpaga/providers/provider.dart';
import 'package:ctpaga/env.dart';

import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class SalesReportPage extends StatefulWidget {
  
  @override
  _SalesReportPageState createState() => _SalesReportPageState();
}

class _SalesReportPageState extends State<SalesReportPage> {
  List<String> weekDay = <String> ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
  var formatter = new DateFormat('dd/M/yyyy');
  var formatterDay = new DateFormat('EEEE');
  var formatterMonth = new DateFormat('MMMM');
  DateTime _dateNow = DateTime.now(), _today, _firstDay, _lastDay;
  int _statusCoin = 1, _statusButtonDate = 0;

  @override
  void initState() {
    super.initState();
    initialVariable();
    _today = DateTime(_dateNow.year, _dateNow.month, _dateNow.day);
    int indexWeekDay =  weekDay.indexOf(formatterDay.format(_dateNow));
    _firstDay = DateTime(_dateNow.year, _dateNow.month, _dateNow.day-indexWeekDay);
    _lastDay = DateTime(_dateNow.year, _dateNow.month, _dateNow.day+(6-indexWeekDay));
  }

  @override
  void dispose() {
    super.dispose();
  }

  initialVariable(){
    var myProvider = Provider.of<MyProvider>(context, listen: false);

  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Navbar("Reporte de ventas", false),
              Padding(
                padding: EdgeInsets.only(right:30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    buttonBs(),
                    Padding(
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: Text(
                        "< >",
                        style: TextStyle(
                          color: colorGreen,
                          fontSize: size.width / 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ),
                    buttonUSD(),
                  ],
                ),
              ),
              showReport() 
            ],
          )
        ),
      );
  }

  Widget buttonUSD(){
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(right:0),
      child: GestureDetector(
        onTap: () => setState(() => _statusCoin = 0), 
        child: Container(
          child: Center(
            child: Text(
              "\$",
              style: TextStyle(
                color: _statusCoin == 0? colorGreen : Colors.grey,
                fontSize: size.width / 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      )
    );
  }

  Widget buttonBs(){
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(left:30),
      child: GestureDetector(
        onTap: () => setState(() => _statusCoin = 1), 
        child: Container(
          child: Center(
            child: Text(
              "Bs",
              style: TextStyle(
                color: _statusCoin == 1? colorGreen : Colors.grey,
                fontSize: size.width / 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      )
    );
  }

  Widget showReport(){
    var size = MediaQuery.of(context).size;
    return Consumer<MyProvider>(
      builder: (context, myProvider, child) {
        return Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 30.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        showDate(),
                        style: TextStyle(
                          color: colorText,
                          fontSize: size.width / 22,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 30),
                    child: Text(
                      showSales(),
                      style:  TextStyle(
                        fontSize: size.width / 6,
                      ),
                    )
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      showButtonDate(0),
                      showButtonDate(1),
                      showButtonDate(2),
                    ],
                  ),

                  showTable(),
                  
                ],
            )
          )
        );
      }
    );
  }

  showDate(){
    switch (_statusButtonDate) {
      case 0:
        return "VENTAS:  HOY ${formatter.format(_today)}";
        break;
      case 1:
        return "VENTAS:  FECHA ${formatter.format(_firstDay)} - ${formatter.format(_lastDay)} ";
        break;
      default:
        formatterMonth = new DateFormat('MMMM', 'es_ES');
        return "VENTAS:  MES ${formatterMonth.format(_today).toUpperCase()}";
    }
  }

  showSales(){
    var lowPrice = MoneyMaskedTextController(initialValue: 0, decimalSeparator: ',', thousandSeparator: '.',  leftSymbol: ' \$', );
  
    if(_statusCoin == 1)
      lowPrice = new MoneyMaskedTextController(initialValue: 0, decimalSeparator: ',', thousandSeparator: '.',  leftSymbol: 'Bs ', );
    
    return "${lowPrice.text}";
  }

  Widget showButtonDate(index){
    List<String> buttonDate = <String>["Hoy", "Esta semana", "Este mes"];
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => setState(() => _statusButtonDate = index),
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              _statusButtonDate == index? colorGreen : colorGrey,
              _statusButtonDate == index? colorGreen : colorGrey,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),

        ),
        child: Center(
          child: Text(
            buttonDate[index],
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

  Widget showTable(){
    return Padding(
      padding: EdgeInsets.all(20),
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Column(
            children: <Widget> [
              Container(
                decoration: BoxDecoration(
                  color: colorGreen,
                  border: Border.all(color: Colors.black26),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  )
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Center(
                        child: Text(
                          'Productos y/o Servicios',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Center(
                        child: Text(
                          'Fecha',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Center(
                        child: Text(
                          'Precio',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: colorGrey,
                  border: Border.all(color: Colors.black26),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  )
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Center(
                        child: Text(
                          'No ha realizado ninguna venta',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    
                  ],
                ),
              ),
            ]
          )
        ],
      ),
      
      
      
    );
  }

}