
import 'package:ctpaga/animation/slideRoute.dart';
import 'package:ctpaga/views/navbar/navbar.dart';
import 'package:ctpaga/views/showDAtaPaidPage.dart';
import 'package:ctpaga/providers/provider.dart';
import 'package:ctpaga/env.dart';

import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:video_player/video_player.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';


class SalesReportPage extends StatefulWidget {
  SalesReportPage(this._statusMenuBar);
  final bool _statusMenuBar;
  @override
  _SalesReportPageState createState() => _SalesReportPageState(this._statusMenuBar);
}

class _SalesReportPageState extends State<SalesReportPage> {
  _SalesReportPageState(this._statusMenuBar);
  final bool _statusMenuBar;
  VideoPlayerController _controller;
  var controllerInitialDate = TextEditingController();
  var controllerFinalDate = TextEditingController();
  List<String> weekDay = <String> ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
  var formatter = new DateFormat('dd/M/yyyy');
  var formatterDay = new DateFormat('EEEE');
  var formatterMonth = new DateFormat('MMMM');
  DateTime _dateNow = DateTime.now(), _today, _firstDay, _lastDay;
  int _statusCoin = 1, _statusButtonDate = 0;
  List _listVerification = new List();
  var formatterTable = new DateFormat('dd/M/yyyy hh:mm aaa');
  List _reportSales = new List ();
  DateTime _initialDate = DateTime.now();
  DateTime _finalDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    _today = DateTime(_dateNow.year, _dateNow.month, _dateNow.day);
    int indexWeekDay =  weekDay.indexOf(formatterDay.format(_dateNow));
    _firstDay = DateTime(_dateNow.year, _dateNow.month, _dateNow.day-indexWeekDay);
    _lastDay = DateTime(_dateNow.year, _dateNow.month, _dateNow.day+(6-indexWeekDay));
    initialVariable();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  initialVariable(){
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    changeVideo(myProvider);
    verifyData();
  }

  @override
  Widget build(BuildContext context) {
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    var size = MediaQuery.of(context).size;
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
                child: Navbar("Transacciones", false),
              ),
              GestureDetector(
                onTap: () async {
                  setState(() {
                    _controller.play();
                    _statusCoin = _statusCoin == 0 ? 1 : 0;
                  });
                  verifyData();
                  await Future.delayed(Duration(milliseconds: 150));
                  changeVideo(myProvider);
                },
                child: Container(
                  alignment: Alignment.centerRight,
                  padding: !_statusMenuBar? EdgeInsets.only(top: 0, right:30) : EdgeInsets.only(top: 25, right:30),
                  child: _controller != null?
                      Container(
                          width: size.width/4,
                          height: size.width/4,
                          child: VideoPlayer(_controller),
                        )
                    :
                      Container(),
                )
              ),
              showReport() 
            ],
          )
        ),
      )
    );
  }

  changeVideo(myProvider){
    if(_statusCoin == 0){
      _controller = VideoPlayerController.asset("assets/videos/botonUSD.mp4");
    }else{
       _controller = VideoPlayerController.asset("assets/videos/botonBs.mp4");
    }
    _controller.initialize();
  }

  Widget showReport(){
    var scaleFactor = MediaQuery.of(context).textScaleFactor;
    var size = MediaQuery.of(context).size;
    return Consumer<MyProvider>(
      builder: (context, myProvider, child) {
        return Expanded(
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
                      fontSize: 16 * scaleFactor,
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  showSales(myProvider),
                  style:  TextStyle(
                    fontSize: 35 * scaleFactor,
                  ),
                )
              ),

              Padding(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    width:size.width - 100,
                    height: size.height / 20,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.red,
                          Colors.red,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: Text(
                        'No podemos enviarte tu dinero',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15 * scaleFactor,
                        ),
                      ),
                    ),
                  ),
                )
              ),
              Visibility(
                visible: _listVerification.length != 4? true : false,
                child: Text(
                  "Necesitamos que completes la información que aparece en el Banco",
                  textAlign: TextAlign.center,
                  style:  TextStyle(
                    fontSize:  15 * scaleFactor,
                    color: colorText
                  ),
                )
              ),

              Padding(
                padding: EdgeInsets.only(top:20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    showButtonDate(0),
                    showButtonDate(1),
                    showButtonDate(2),
                  ],
                )
              ),

              Padding(
                padding: EdgeInsets.only(top:20),
                child: Text(
                  "O rango de fecha:",
                  textAlign: TextAlign.center,
                  style:  TextStyle(
                    fontSize:  15 * scaleFactor,
                    color: colorText
    ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top:5, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    showInputDate("Inicial",controllerInitialDate,1),
                    showInputDate("Final",controllerFinalDate,2),
                  ],
                )
              ),

              Expanded(
                child: SingleChildScrollView(
                  child: showTable()
                ),
              ),
              
            ],
          )
        );
      }
    );
  }

  showInputDate(_title, _controller,index){
    var scaleFactor = MediaQuery.of(context).textScaleFactor;
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width/3,
      child: TextFormField(
        readOnly: true,
        decoration: InputDecoration(
          labelText: _title,
        ),
        controller: _controller,
        style: TextStyle(
          fontSize: 15 * scaleFactor,
        ),
        onTap: () {
          setState(() {
            _statusButtonDate = 3;
          });
          if(index == 1)
            _selectDateInitial(context);
          else
            _selectDateFinal(context);
        }
      )
    );
  }

  Future<Null> _selectDateInitial(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _dateNow,
        firstDate: DateTime(_dateNow.year-1,1),
        lastDate: _dateNow,
        helpText: "Seleccionar la Fecha Inicial:"
      );
    if (picked != null && picked != DateTime.now())
      setState(() {
        _initialDate = picked;
        controllerInitialDate.text = formatter.format(_initialDate);
      });
    
    verifyData();
  }

  Future<Null> _selectDateFinal(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
        locale : const Locale("es","ES"),
      initialDate: _dateNow,
      firstDate: DateTime(_dateNow.year-1, 1),
      lastDate: _dateNow,
      helpText: "Seleccionar la Fecha Final:"
      );
    if (picked != null && picked != DateTime.now())
      setState(() {
        _finalDate = picked;
        controllerFinalDate.text = formatter.format(_finalDate);
      });
    
    verifyData();
  }

  showDate(){
    switch (_statusButtonDate) {
      case 0:
        return "VENTAS:  HOY ${formatter.format(_today)}";
        break;
      case 1:
        return "VENTAS:  FECHA ${formatter.format(_firstDay)} - ${formatter.format(_lastDay)} ";
        break;
      case 2:
        formatterMonth = new DateFormat('MMMM', 'es_ES');
        return "VENTAS:  MES ${formatterMonth.format(_today).toUpperCase()}";
      default:
        formatterMonth = new DateFormat('MMMM', 'es_ES');
        return "VENTAS: ${controllerInitialDate.text} al ${controllerFinalDate.text}";
    }
  }

  showSales(myProvider){
    var lowPrice = MoneyMaskedTextController(initialValue: 0, decimalSeparator: ',', thousandSeparator: '.',  leftSymbol: '\$', );
    if(_statusCoin == 1){
      lowPrice = new MoneyMaskedTextController(initialValue: 0, decimalSeparator: ',', thousandSeparator: '.',  leftSymbol: 'Bs ', );
    }

    for (var item in myProvider.dataBalances) {
      if(item['coin'] == _statusCoin){
        lowPrice.updateValue(double.parse(item['total']));
        break;
      }
    }
      
    
    return "${lowPrice.text}";
  }

  Widget showButtonDate(index){
    List<String> buttonDate = <String>["Hoy", "Esta semana", "Este mes"];
    var scaleFactor = MediaQuery.of(context).textScaleFactor;
    return GestureDetector(
      onTap: () {
        setState(() {
          _statusButtonDate = index;
          _initialDate = _dateNow;
          _finalDate = _dateNow;
        });
        controllerInitialDate.clear();
        controllerFinalDate.clear();
        verifyData();
      },
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
              fontSize: 15 * scaleFactor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget showTable(){
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    var scaleFactor = MediaQuery.of(context).textScaleFactor;
    return DataTable(
      columns: <DataColumn>[
        DataColumn(
          label: Text(
            'Cliente',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontSize: 12 * scaleFactor,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            'Fecha',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontSize: 12 * scaleFactor,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            'Precio',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontSize: 12 * scaleFactor,
            ),
          ),
        ),
      ],
      rows: _reportSales.length == 0?
        const <DataRow>[]
      :
        List<DataRow>.generate(
          _reportSales.length,
          (index) => DataRow(
            cells: [
              DataCell(
                Text(_reportSales[index].nameClient),
                onTap: (){
                  myProvider.selectPaid = _reportSales[index];
                  Navigator.push(context, SlideLeftRoute(page: ShowDataPaidPage()));
                  _onLoading();
                }
              ),
              DataCell(
                Text(showDateTable(_reportSales[index].date)),
                onTap: (){
                  myProvider.selectPaid = _reportSales[index];
                  Navigator.push(context, SlideLeftRoute(page: ShowDataPaidPage()));
                  _onLoading();
                }
              ),
              DataCell(
                Text(showPriceTable(_reportSales[index].total)),
                onTap: (){
                  myProvider.selectPaid = _reportSales[index];
                  Navigator.push(context, SlideLeftRoute(page: ShowDataPaidPage()));
                  _onLoading();
                }
              ),
            ]
          )
        ).toList(),
    );
  }


  verifyData(){
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    setState(() => _reportSales = []);
    for (var item in myProvider.dataPaids) {
      DateTime dateItem = DateTime.parse(item.date);
      if(_statusButtonDate == 0){
        if(item.coin == _statusCoin && dateItem.day == _dateNow.day && dateItem.month == _dateNow.month && dateItem.year == _dateNow.year)
          setState(() => _reportSales.add(item));
      }else if(_statusButtonDate == 1){
        if(item.coin == _statusCoin && _firstDay.isBefore(dateItem) && _lastDay.isAfter(dateItem))
          setState(() => _reportSales.add(item));
      }else if(_statusButtonDate == 2){
        if(item.coin == _statusCoin && dateItem.month == _dateNow.month)
          setState(() => _reportSales.add(item));
      }else if(_statusButtonDate == 3){
        if(item.coin == _statusCoin && _initialDate.isBefore(dateItem) && _finalDate.isAfter(dateItem))
          setState(() => _reportSales.add(item));
      }
    }

  }

  showDateTable(date){
    return formatterTable.format(DateTime.parse(date));
  }

  showPriceTable(total){
    var lowPrice = MoneyMaskedTextController(initialValue: 0, decimalSeparator: ',', thousandSeparator: '.',  leftSymbol: '\$', );
  
    if(_statusCoin == 1)
      lowPrice = new MoneyMaskedTextController(initialValue: 0, decimalSeparator: ',', thousandSeparator: '.',  leftSymbol: 'Bs ', );
    
    lowPrice.updateValue(double.parse(total));

    return "${lowPrice.text}";
  }

  Future<void> _onLoading() async {
    var scaleFactor = MediaQuery.of(context).textScaleFactor;

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
                    valueColor: new AlwaysStoppedAnimation<Color>(colorGreen),
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
                            fontSize: 15 * scaleFactor,
                          )
                        ),
                        TextSpan(
                          text: "...",
                          style: TextStyle(
                            color: colorGreen,
                            fontSize: 15 * scaleFactor,
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