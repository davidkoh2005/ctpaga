
import 'package:ctpaga/animation/slideRoute.dart';
import 'package:ctpaga/views/navbar/navbar.dart';
import 'package:ctpaga/views/newExchangeRatePage.dart';
import 'package:ctpaga/providers/provider.dart';
import 'package:ctpaga/env.dart';

import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class ExchangeRatePage extends StatefulWidget {
  ExchangeRatePage(this._statusMenuBar);
  final bool _statusMenuBar;
  @override
  _ExchangeRatePageState createState() => _ExchangeRatePageState(this._statusMenuBar);
}

class _ExchangeRatePageState extends State<ExchangeRatePage> {
  _ExchangeRatePageState(this._statusMenuBar);
  final bool _statusMenuBar;
  var lowPrice = new MoneyMaskedTextController(initialValue: 0, decimalSeparator: ',', thousandSeparator: '.',  leftSymbol: 'Bs ', );
  List<String> weekDay = <String> ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
  var formatter = new DateFormat('dd/M/yyyy');
  var formatterDay = new DateFormat('EEEE');
  var formatterMonth = new DateFormat('MMMM');
  var formatterTable = new DateFormat('dd/M/yyyy hh:mm aaa');

  DateTime? _dateNow = DateTime.now(), _today, _firstDay, _lastDay;
  bool _statusButton =false;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    initialVariable();
    _today = DateTime(_dateNow!.year, _dateNow!.month, _dateNow!.day);
    int indexWeekDay =  weekDay.indexOf(formatterDay.format(_dateNow!));
    _firstDay = DateTime(_dateNow!.year, _dateNow!.month, _dateNow!.day-indexWeekDay);
    _lastDay = DateTime(_dateNow!.year, _dateNow!.month, _dateNow!.day+(6-indexWeekDay));
  }

  @override
  void dispose() {
    super.dispose();
  }

  initialVariable(){
    var myProvider = Provider.of<MyProvider>(context, listen: false);

    if(myProvider.dataRates.length != 0)
      lowPrice.updateValue(double.parse(myProvider.dataRates[0].rate));
     
  }

  @override
  Widget build(BuildContext context) {
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    return WillPopScope(
      onWillPop: () async {
        if(myProvider.statusButtonMenu){
          myProvider.statusButtonMenu = false;
          return false;
        }else{
          myProvider.clickButtonMenu = 0;
          return true;
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Visibility(
                visible: !_statusMenuBar,
                child: Navbar("Tasa de cambio", false),
              ),
              showReport(),
              
              Padding(
                padding: EdgeInsets.only(top: 20, bottom: 50),
                child: buttonNew()
              ), 
            ],
          )
        ),
      )
    );
  }

  Widget showReport(){
    
    return Consumer<MyProvider>(
      builder: (context, myProvider, child) {
        return Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                  Padding(
                    padding: _statusMenuBar? const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 30.0) : const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 30.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: AutoSizeText(
                        showDate(myProvider),
                        style: TextStyle(
                          color: colorText,
                          fontFamily: 'MontserratSemiBold',
                        ),
                        maxFontSize: 14,
                        minFontSize: 14,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 30),
                    child: AutoSizeText(
                      updatePrice(myProvider),
                      textAlign: TextAlign.center,
                      style:  TextStyle(
                        fontFamily: 'MontserratSemiBold',
                      ),
                      maxFontSize: 20,
                      minFontSize: 20,
                    )
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      showButtonDate(0, myProvider),
                      showButtonDate(1, myProvider),
                      showButtonDate(2, myProvider),
                    ],
                  ),

                  showTable(myProvider),
                  
                ],
            )
          )
        );
      }
    );
  }

  updatePrice(myProvider){
    if(myProvider.dataRates.length != 0)
      lowPrice.updateValue(double.parse(myProvider.dataRates[0].rate));
    

    return "${lowPrice.text}";
  }

  showDate(myProvider){
    switch (myProvider.selectDateRate) {
      case 0:
        return "TASA:  HOY ${formatter.format(_today!)}";
      case 1:
        return "TASA:  FECHA ${formatter.format(_firstDay!)} - ${formatter.format(_lastDay!)} ";
      default:
        formatterMonth = new DateFormat('MMMM','es_ES');
        return "TASA:  MES ${formatterMonth.format(_today!).toUpperCase()}";
    }
  }

  

  Widget showButtonDate(index, myProvider){
    List<String> buttonDate = <String>["Hoy", "Esta semana", "Este mes"];
    
    return GestureDetector(
      onTap: () {
        myProvider.selectDateRate = index;
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
        decoration: BoxDecoration(
          color: myProvider.selectDateRate == index? colorLogo : colorGrey,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: AutoSizeText(
            buttonDate[index],
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontFamily: 'MontserratSemiBold',
            ),
            maxFontSize: 14,
            minFontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget showTable(myProvider){
    
    return Padding(
      padding: EdgeInsets.all(20),
      child: DataTable(
        columns:  <DataColumn>[
          DataColumn(
            label: Text(
              'TASA',
              style: TextStyle(fontFamily: 'MontserratSemiBold'),
            ),
          ),
          DataColumn(
            label: Text(
              'FECHA',
              style: TextStyle(fontFamily: 'MontserratSemiBold'),
            ),
          ),
        ],
        rows: verifyData(myProvider)?
          const <DataRow>[]
        :
          List<DataRow>.generate(
            tableLength(myProvider),
            (index) => DataRow(
              cells: [
                DataCell(
                  Text(showRate(myProvider, index)),
                ),
                DataCell(
                  Text(showRateDate(myProvider, index)),
                ),
              ]
            )
          ).toList(),

      ),
    );
  }

  verifyData(myProvider){
    if(myProvider.selectDateRate == 0){
      if(myProvider.dataRatesSelectToday == null)
        return true;
      else if(myProvider.dataRatesSelectToday.length ==0)
        return true;

    }else if(myProvider.selectDateRate == 1){
      if(myProvider.dataRatesSelectWeek == null)
        return true;
      else if(myProvider.dataRatesSelectWeek.length ==0)
        return true;

    }else if(myProvider.selectDateRate == 3){
      if(myProvider.dataRatesSelectMonth == null)
        return true;
      else if(myProvider.dataRatesSelectMonth.length ==0)
        return true;
    } 

    return false;
  }

  int tableLength(myProvider){
    if(myProvider.selectDateRate == 0)
      return myProvider.dataRatesSelectToday.length;

    else if(myProvider.selectDateRate == 1)
      return myProvider.dataRatesSelectWeek.length;

    else if(myProvider.selectDateRate == 2)
      return myProvider.dataRatesSelectMonth.length;
    

    return 0;
  }

  showRate(myProvider, index){
    if(myProvider.selectDateRate == 0){
      return showExhangeRate(myProvider.dataRatesSelectToday[index].rate);
    }else if(myProvider.selectDateRate == 1){
      return showExhangeRate(myProvider.dataRatesSelectWeek[index].rate);
    }

    return showExhangeRate(myProvider.dataRatesSelectMonth[index].rate);
  }

  showRateDate(myProvider, index){
    if(myProvider.selectDateRate == 0){
      return formatterTable.format(DateTime.parse(myProvider.dataRatesSelectToday[index].date));
    }else if(myProvider.selectDateRate == 1){
      return formatterTable.format(DateTime.parse(myProvider.dataRatesSelectWeek[index].date));
    }
    return formatterTable.format(DateTime.parse(myProvider.dataRatesSelectMonth[index].date));
  }

  showExhangeRate(rate){
    var lowRate = new MoneyMaskedTextController(initialValue: 0, decimalSeparator: ',', thousandSeparator: '.',  leftSymbol: 'Bs ', );

    lowRate.updateValue(double.parse(rate));

    return "${lowRate.text}";
  }

  Widget buttonNew(){
    var size = MediaQuery.of(context).size;
    return  GestureDetector(
      onTap: () => nextPage(),
      child: Container(
        width:size.width - 100,
        height: size.height / 20,
        decoration: BoxDecoration(
          border: Border.all(
            color: colorGrey, 
            width: 1.0,
          ),
          color: _statusButton? colorLogo : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: AutoSizeText(
            "NUEVA TASA",
            style: TextStyle(
              color: _statusButton? Colors.white : colorLogo,
              fontWeight: FontWeight.w500,
              fontFamily: 'MontserratSemiBold',
            ),
            maxFontSize: 14,
            minFontSize: 14,
          ),
        ),
      ),
    );
  }

  nextPage()async{
    setState(() => _statusButton = true);
    await Future.delayed(Duration(milliseconds: 150));
    setState(() => _statusButton = false);
    Navigator.push(context, SlideLeftRoute(page: NewExchangeRatePage()));
  }

}