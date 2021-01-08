
import 'package:ctpaga/animation/slideRoute.dart';
import 'package:ctpaga/views/navbar/navbar.dart';
import 'package:ctpaga/views/showDAtaPaidPage.dart';
import 'package:ctpaga/providers/provider.dart';
import 'package:ctpaga/env.dart';

import 'package:flutter_masked_text/flutter_masked_text.dart';
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
  var controllerInitialDate = TextEditingController();
  var controllerFinalDate = TextEditingController();
  List<String> weekDay = <String> ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
  var formatter = new DateFormat('dd/M/yyyy');
  var formatterDay = new DateFormat('EEEE');
  var formatterMonth = new DateFormat('MMMM');
  DateTime _dateNow = DateTime.now(), _today, _firstDay, _lastDay;
  int _statusCoin = 1, _statusButtonDate = 0;
  var formatterTable = new DateFormat('dd/M/yyyy hh:mm aaa');
  DateTime _initialDate = DateTime.now();
  DateTime _finalDate = DateTime.now();
  double _positionTopFirst = 35,
        _positionTopSecond = 0;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    _today = DateTime(_dateNow.year, _dateNow.month, _dateNow.day);
    int indexWeekDay =  weekDay.indexOf(formatterDay.format(_dateNow));
    _firstDay = DateTime(_dateNow.year, _dateNow.month, _dateNow.day-indexWeekDay);
    _lastDay = DateTime(_dateNow.year, _dateNow.month, _dateNow.day+(6-indexWeekDay));
    verifyData();
  }

  @override
  void dispose() {
    super.dispose();
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
              Padding(
                padding: _statusMenuBar? EdgeInsets.only(top:40) : EdgeInsets.zero ,
                child: GestureDetector(
                  onTap: () async {
                    setState(() => _statusCoin = _statusCoin == 0 ? 1 : 0);
                    await Future.delayed(Duration(milliseconds: 20));
                    setState(() {
                      _positionTopFirst == 0? _positionTopFirst = 35 : _positionTopFirst = 0; 
                      _positionTopSecond == 0? _positionTopSecond = 35 : _positionTopSecond = 0; 
                    }); 
                  },
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: size.width / 3,
                      height: size.width / 3.5,
                      child: Stack(
                        children: _statusCoin == 0 ?[
                          coinSecond(),
                          coinFirst(),
                        ]
                        :
                        [
                          coinFirst(),
                          coinSecond(),
                        ],
                      ),
                    )
                  )
                ),
              ),
              
              showReport() 
            ],
          )
        ),
      )
    );
  }

  Widget coinSecond(){
    var scaleFactor = MediaQuery.of(context).textScaleFactor;
    var size = MediaQuery.of(context).size;
    return AnimatedPositioned(
      duration: Duration(milliseconds:300),
      top: _positionTopSecond,
      curve: Curves.linear,
      child: AnimatedPadding(
        duration: Duration(milliseconds:600),
        padding: _positionTopSecond == 0? EdgeInsets.only(left:5) : EdgeInsets.only(left:40),
        child: Container(
          alignment: Alignment.center,
          width: size.width / 7,
          height: size.width / 7,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(80),
            color: _positionTopSecond == 0? colorGreen : colorGrey,
          ),
          child: Container(
            child: Text(
              "Bs",
              style:  TextStyle(
                fontSize: 18 * scaleFactor,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            )
          ),
        )
      ),
    );
  }

  Widget coinFirst(){
    var scaleFactor = MediaQuery.of(context).textScaleFactor;
    var size = MediaQuery.of(context).size;
    return AnimatedPositioned(
      duration: Duration(milliseconds:300),
      top: _positionTopFirst,
      curve: Curves.linear,
      child: AnimatedPadding(
        duration: Duration(milliseconds:600),
        padding: _positionTopFirst == 0? EdgeInsets.only(left:5) : EdgeInsets.only(left:40),
        child: Container(
          alignment: Alignment.center,
          width: size.width / 7,
          height: size.width / 7,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(80),
            color: _positionTopFirst == 0? colorGreen : colorGrey,
          ),
          child: Text(
            "\$" ,
            style:  TextStyle(
              fontSize: 18 * scaleFactor,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget showReport(){
    var scaleFactor = MediaQuery.of(context).textScaleFactor;
    return Consumer<MyProvider>(
      builder: (context, myProvider, child) {
        verifyData();
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
        
        if (controllerFinalDate.text.length == 0)
          controllerFinalDate.text = formatter.format(DateTime.now());
        
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
        _finalDate = DateTime(picked.year, picked.month, picked.day+1);
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

    lowPrice.updateValue(myProvider.totalSales);
      
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
          color: _statusButtonDate == index? colorGreen : colorGrey,
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
      rows: myProvider.dataReportSales.length == 0?
        const <DataRow>[]
      :
        List<DataRow>.generate(
          myProvider.dataReportSales.length,
          (index) => DataRow(
            cells: [
              DataCell(
                Text(myProvider.dataReportSales[index].nameClient),
                onTap: (){
                  myProvider.selectPaid = myProvider.dataReportSales[index];
                  Navigator.push(context, SlideLeftRoute(page: ShowDataPaidPage()));
                  _onLoading();
                }
              ),
              DataCell(
                Text(showDateTable(myProvider.dataReportSales[index].date)),
                onTap: (){
                  myProvider.selectPaid = myProvider.dataReportSales[index];
                  Navigator.push(context, SlideLeftRoute(page: ShowDataPaidPage()));
                  _onLoading();
                }
              ),
              DataCell(
                Text(showPriceTable(myProvider.dataReportSales[index].total)),
                onTap: (){
                  myProvider.selectPaid = myProvider.dataReportSales[index];
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
    myProvider.totalSales = 0;
    myProvider.dataReportSales = [];
    for (var item in myProvider.dataPaids) {
      DateTime dateItem = DateTime.parse(item.date);
      if(_statusButtonDate == 0){
        if(item.coin == _statusCoin && dateItem.day == _dateNow.day && dateItem.month == _dateNow.month && dateItem.year == _dateNow.year){
          myProvider.dataReportSales.add(item);
          myProvider.totalSales = myProvider.totalSales + double.parse(item.total);
        }
      }else if(_statusButtonDate == 1){
        if(item.coin == _statusCoin && _firstDay.isBefore(dateItem) && _lastDay.isAfter(dateItem)){
          myProvider.dataReportSales.add(item);
          myProvider.totalSales = myProvider.totalSales + double.parse(item.total);
        }
      }else if(_statusButtonDate == 2){
        if(item.coin == _statusCoin && dateItem.month == _dateNow.month){
          myProvider.dataReportSales.add(item);
          myProvider.totalSales = myProvider.totalSales + double.parse(item.total);
        }
      }else if(_statusButtonDate == 3){
        if(item.coin == _statusCoin && _initialDate.isBefore(dateItem) && _finalDate.isAfter(dateItem)){
          myProvider.dataReportSales.add(item);
          myProvider.totalSales = myProvider.totalSales + double.parse(item.total);
        }
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