
import 'package:ctpaga/views/navbar/navbar.dart';
import 'package:ctpaga/providers/provider.dart';
import 'package:ctpaga/env.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';



class ShowDataPaidPage extends StatefulWidget {
  
  @override
  _ShowDataPaidPageState createState() => _ShowDataPaidPageState();
}

class _ShowDataPaidPageState extends State<ShowDataPaidPage> {
  String codeUrl;
  List _listSales = new List();

  void initState() {
    super.initState();
    initialVariable();
  }

  void dispose(){
    super.dispose();
  }

  initialVariable()async{
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    codeUrl = myProvider.selectPaid.codeUrl;
    try
      {
        var response, result;
        result = await InternetAddress.lookup('google.com'); //verify network
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

          var parameters = jsonToUrl(jsonEncode({
              "codeUrl": codeUrl,
            }));

          response = await http.get(
            urlApi+"showSales/$parameters",
            headers:{
              'Content-Type': 'application/json',
              'X-Requested-With': 'XMLHttpRequest',
              'authorization': 'Bearer ${myProvider.accessTokenUser}',
            },
          ); 

          var jsonResponse = jsonDecode(response.body); 
          print(jsonResponse);
          if (jsonResponse['statusCode'] == 201) {
            for (var item in jsonResponse['data']) {
              setState(() {
                _listSales.add(item);
              });
            }
            Navigator.pop(context);
          } 
        }
      } on SocketException catch (_) {
        Navigator.pop(context);
        showMessage("Sin conexión a internet, no se podra mostrar los Productos y/o Servicos. Intentalo de nuevo!", false);
      }
  }

  String jsonToUrl(value){
    String parametersUrl="?";
    final json = jsonDecode(value) as Map;
    for (final name in json.keys) {
      final value = json[name];
      parametersUrl = parametersUrl + "$name=$value&";
    }
    
    return parametersUrl.substring(0, parametersUrl.length-1);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {return true;},
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Navbar("Reporte", false),
            Expanded(
              child: showDataPaid(),
            ),
          ],
        ),
      )
    );
  }

  Widget showDataPaid(){
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    var scaleFactor = MediaQuery.of(context).textScaleFactor;
    var size = MediaQuery.of(context).size;
    return ListView(
      padding: EdgeInsets.only(bottom: 20),
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(40, 0, 40, 20),
          child: Container(
            alignment: Alignment.center,
            height: size.height / 20,
            decoration: BoxDecoration(
              color: colorGreen,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Center(
              child: Text(
                "CONTACTO",
                style: TextStyle(
                  fontSize: 15 * scaleFactor,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'MontserratSemiBold',
                ),
              ),
            )
          )
        ),

        Container(
          padding: EdgeInsets.fromLTRB(30,0,30,5),
          alignment: Alignment.centerLeft,
          child: RichText(
            text: TextSpan(
              text: 'Nombre: ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15 * scaleFactor,
                color: Colors.black,
                fontFamily: 'MontserratSemiBold',
              ),
              children: <TextSpan>[
                TextSpan(
                  text: myProvider.selectPaid.nameClient,
                  style: TextStyle(
                    fontSize: 15 * scaleFactor,
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'MontserratSemiBold',
                  ),
                ),
              ],
            ),
          ),
        ),

        Container(
          padding: EdgeInsets.fromLTRB(30,0,30,5),
          alignment: Alignment.centerLeft,
          child: RichText(
            text: TextSpan(
              text: 'Correo: ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15 * scaleFactor,
                color: Colors.black,
                fontFamily: 'MontserratSemiBold',
              ),
              children: <TextSpan>[
                TextSpan(
                  text: myProvider.selectPaid.email,
                  style: TextStyle(
                    fontSize: 15 * scaleFactor,
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'MontserratSemiBold',
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(30,0,30,5),
          alignment: Alignment.centerLeft,
          child: RichText(
            text: TextSpan(
              text: 'Código de compra: ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15 * scaleFactor,
                color: Colors.black,
                fontFamily: 'MontserratSemiBold',
              ),
              children: <TextSpan>[
                TextSpan(
                  text: myProvider.selectPaid.codeUrl,
                  style: TextStyle(
                    fontSize: 15 * scaleFactor,
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'MontserratSemiBold',
                  ),
                ),
              ],
            ),
          ),
        ),

        Padding(
          padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
          child: Container(
            alignment: Alignment.center,
            height: size.height / 20,
            decoration: BoxDecoration(
              color: colorGreen,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Center(
              child: Text(
                "DETALLE DE ENVÍO",
                style: TextStyle(
                  fontSize: 15 * scaleFactor,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'MontserratSemiBold',
                ),
              ),
            )
          )
        ),

        Container(
          padding: EdgeInsets.fromLTRB(30,0,30,5),
          alignment: Alignment.centerLeft,
          child: RichText(
            text: TextSpan(
              text: 'Nombre: ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15 * scaleFactor,
                color: Colors.black,
                fontFamily: 'MontserratSemiBold',
              ),
              children: <TextSpan>[
                TextSpan(
                  text: myProvider.selectPaid.nameShipping,
                  style: TextStyle(
                    fontSize: 15 * scaleFactor,
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'MontserratSemiBold',
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(30,0,30,5),
          alignment: Alignment.centerLeft,
          child: RichText(
            text: TextSpan(
              text: 'Teléfono: ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15 * scaleFactor,
                color: Colors.black,
                fontFamily: 'MontserratSemiBold',
              ),
              children: <TextSpan>[
                TextSpan(
                  text: myProvider.selectPaid.numberShipping,
                  style: TextStyle(
                    fontSize: 15 * scaleFactor,
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'MontserratSemiBold',
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(30,0,30,5),
          alignment: Alignment.centerLeft,
          child: RichText(
            text: TextSpan(
              text: 'Dirección: ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15 * scaleFactor,
                color: Colors.black,
                fontFamily: 'MontserratSemiBold',
              ),
              children: <TextSpan>[
                TextSpan(
                  text: myProvider.selectPaid.addressShipping,
                  style: TextStyle(
                    fontSize: 15 * scaleFactor,
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'MontserratSemiBold',
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(30,0,30,5),
          alignment: Alignment.centerLeft,
          child: RichText(
            text: TextSpan(
              text: 'Detalle: ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15 * scaleFactor,
                color: Colors.black,
                fontFamily: 'MontserratSemiBold',
              ),
              children: <TextSpan>[
                TextSpan(
                  text: myProvider.selectPaid.detailsShipping,
                  style: TextStyle(
                    fontSize: 15 * scaleFactor,
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'MontserratSemiBold',
                  ),
                ),
              ],
            ),
          ),
        ),

        Padding(
          padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
          child: Container(
            alignment: Alignment.center,
            height: size.height / 20,
            decoration: BoxDecoration(
              color: colorGreen,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Center(
              child: Text(
                "ENVIO SELECCIONADO",
                style: TextStyle(
                  fontSize: 15 * scaleFactor,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'MontserratSemiBold',
                ),
              ),
            )
          )
        ),
        Container(
          padding: EdgeInsets.fromLTRB(30,0,30,5),
          alignment: Alignment.centerLeft,
          child: RichText(
            text: TextSpan(
              text: 'Estado: ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15 * scaleFactor,
                color: Colors.black,
                fontFamily: 'MontserratSemiBold',
              ),
              children: <TextSpan>[
                TextSpan(
                  text: showStatus(myProvider.selectPaid.statusShipping),
                  style: TextStyle(
                    fontSize: 15 * scaleFactor,
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'MontserratSemiBold',
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(30,0,30,5),
          alignment: Alignment.centerLeft,
          child: RichText(
            text: TextSpan(
              text: 'Descripción: ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15 * scaleFactor,
                color: Colors.black,
                fontFamily: 'MontserratSemiBold',
              ),
              children: <TextSpan>[
                TextSpan(
                  text: myProvider.selectPaid.selectShipping,
                  style: TextStyle(
                    fontSize: 15 * scaleFactor,
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'MontserratSemiBold',
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(30,0,30,5),
          alignment: Alignment.centerLeft,
          child: RichText(
            text: TextSpan(
              text: 'Precio: ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15 * scaleFactor,
                color: Colors.black,
                fontFamily: 'MontserratSemiBold',
              ),
              children: <TextSpan>[
                TextSpan(
                  text: showTotal(myProvider.selectPaid.coin, myProvider.selectPaid.priceShipping),
                  style: TextStyle(
                    fontSize: 15 * scaleFactor,
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'MontserratSemiBold',
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(30,0,30,5),
          alignment: Alignment.centerRight,
          child: RichText(
            text: TextSpan(
              text: 'Descuento: ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15 * scaleFactor,
                color: Colors.black,
                fontFamily: 'MontserratSemiBold',
              ),
              children: <TextSpan>[
                TextSpan(
                  text: "${myProvider.selectPaid.percentage} %",
                  style: TextStyle(
                    fontSize: 15 * scaleFactor,
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'MontserratSemiBold',
                  ),
                ),
              ],
            ),
          ),
        ),

        Container(
          padding: EdgeInsets.fromLTRB(30,0,30,5),
          alignment: Alignment.centerRight,
          child: RichText(
            text: TextSpan(
              text: 'Total: ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15 * scaleFactor,
                color: Colors.black,
                fontFamily: 'MontserratSemiBold',
              ),
              children: <TextSpan>[
                TextSpan(
                  text: showTotal(myProvider.selectPaid.coin, myProvider.selectPaid.total),
                  style: TextStyle(
                    fontSize: 15 * scaleFactor,
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'MontserratSemiBold',
                  ),
                ),
              ],
            ),
          ),
        ),

        
        Container(
          padding: EdgeInsets.fromLTRB(30,0,30,5),
          alignment: Alignment.center,
          child: RichText(
            text: TextSpan(
              text: 'Estado del Pago: ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15 * scaleFactor,
                color: Colors.black,
                fontFamily: 'MontserratSemiBold',
              ),
              children: <TextSpan>[
                TextSpan(
                  text: _listSales.length ==0? "SIN PAGAR" : _listSales[0]['statusSale'] == 0? "SIN PAGAR" : "PAGADO",
                  style: TextStyle(
                    fontSize: 15 * scaleFactor,
                    color: _listSales.length ==0? Colors.red : _listSales[0]['statusSale'] == 0? Colors.red : Colors.green,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'MontserratSemiBold',
                  ),
                ),
              ],
            ),
          ),
        ),

        Padding(
          padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
          child: Container(
            alignment: Alignment.center,
            height: size.height / 20,
            decoration: BoxDecoration(
              color: colorGreen,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Center(
              child: Text(
                "PRODUCTOS Y/O SERVICIOS",
                style: TextStyle(
                  fontSize: 15 * scaleFactor,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'MontserratSemiBold',
                ),
              ),
            )
          )
        ),

        Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: DataTable(
            columns: <DataColumn>[
              DataColumn(
                label: Text(
                  'Cantidad',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 15 * scaleFactor,
                    fontFamily: 'MontserratSemiBold',
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Nombre',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 15 * scaleFactor,
                    fontFamily: 'MontserratSemiBold',
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Precio',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 15 * scaleFactor,
                    fontFamily: 'MontserratSemiBold',
                  ),
                ),
              ),
            ],
            rows: _listSales.length == 0?
              const <DataRow>[]
            :
              List<DataRow>.generate(
                _listSales.length,
                (index) => DataRow(
                  cells: [
                    DataCell(
                      Text(_listSales[index]['quantity'].toString()),
                    ),
                    DataCell(
                      Text(_listSales[index]['name']),
                    ),
                    DataCell(
                      Text(showPrice(_listSales[index]['price'], _listSales[index]['coinClient'], _listSales[index]['coin'], _listSales[index]['rate']),),
                    ),
                  ]
                )
              ).toList(),
          )
        )

      ],
    );
  }

  showStatus(status){
    switch(status) { 
      case 0: { return "PRODUCTOS NO RETIRADO"; } 
      break; 
     
      case 1: { return "PRODUCTOS RETIRADO"; } 
      break; 
     
      case 2: { return "PRODUCTOS ENTREGADO"; } 
      break;     
    } 
  }

  showTotal(coin, price){
    var lowPrice = new MoneyMaskedTextController(initialValue: 0, decimalSeparator: ',', thousandSeparator: '.',  leftSymbol: '\$', );
    
    if(coin  == 1)
      lowPrice = new MoneyMaskedTextController(initialValue: 0, decimalSeparator: ',', thousandSeparator: '.',  leftSymbol: 'Bs ', );

    lowPrice.updateValue(double.parse(price));

    return "${lowPrice.text}";
  }

  showPrice(price, coinClient, coin ,rate){
    price = price.replaceAll(",", ".");
    var lowPrice = new MoneyMaskedTextController(initialValue: 0, decimalSeparator: ',', thousandSeparator: '.',  leftSymbol: '\$', );
    double priceDouble = double.parse(price);
    double varRate = double.parse(rate);

    if(coinClient  == 1)
      lowPrice = new MoneyMaskedTextController(initialValue: 0, decimalSeparator: ',', thousandSeparator: '.',  leftSymbol: 'Bs ', );

    if(coin == 0 && coinClient == 1)
      lowPrice.updateValue(priceDouble * varRate);
    else if(coin == 1 && coinClient == 0)
      lowPrice.updateValue(priceDouble / varRate);
    else
      lowPrice.updateValue(priceDouble);

    return "${lowPrice.text}";
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

}