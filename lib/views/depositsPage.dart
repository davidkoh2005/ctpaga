import 'package:ctpaga/animation/slideRoute.dart';
import 'package:ctpaga/views/navbar/navbar.dart';
import 'package:ctpaga/providers/provider.dart';
import 'package:ctpaga/env.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class DepositsPage extends StatefulWidget {
  @override
  _DepositsPageState createState() => _DepositsPageState();
}

class _DepositsPageState extends State<DepositsPage> {
  final _scrollController = ScrollController();
  List _statusButton = new List();
  List _listVerification = new List();
  int _statusCoin = 0;

  void initState() {
    super.initState();
    verifyStatusBank(context, null);
  }

  void dispose(){
    super.dispose();
  }

  verifyStatusBank(BuildContext context, coin){
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    //myProvider.getDataUser(false, context);
    _listVerification = [];

  

    setState(() {
      if(coin == null && myProvider.selectCoinDeposits == null){
        myProvider.selectCoinDeposits = 1;
        _statusCoin = 1;
      }else if(coin != null){
        myProvider.selectCoinDeposits = coin;
        _statusCoin = coin;
      }else{
        _statusCoin = myProvider.selectCoinDeposits;
      }


      if (myProvider.dataBanksUser[_statusCoin] != null ){
        _listVerification.add("Bank");
      }
      for (var item in myProvider.dataPicturesUser) {
        if(item.description == 'Identification'){
            _listVerification.add("Identification");
        }else if(item.description == 'Selfie'){
            _listVerification.add("Selfie");
        }else if(item.description == 'RIF' && item.commerce_id == myProvider.dataCommercesUser[myProvider.selectCommerce].id){
          _listVerification.add("RIF"); 
        }
      }
    });
    myProvider.listVerification = _listVerification;
  }

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
          height: size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Navbar("Depósitos", false),
              Expanded(
                //height: size.height - 160,
                child: Scrollbar(
                  controller: _scrollController, 
                  isAlwaysShown: true,
                  child: SingleChildScrollView(
                    controller: _scrollController, 
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget> [
                        Padding(
                          padding: EdgeInsets.only(right: 30),
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
                          )
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.all(25),
                            child: Text(
                              "PROXIMO DEPÓSITO",
                              style:  TextStyle(
                                fontSize: size.width / 20,
                                color: colorGrey
                              ),
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            showDeposits(),
                            style:  TextStyle(
                              fontSize: size.width / 6,
                            ),
                          ),
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
                                    fontSize: size.width / 20,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ),
                        Visibility(
                          visible: _listVerification.length != 4? true : false,
                          child: Text(
                            "Necesitamos que completes la información marcada en rojo debajo",
                            textAlign: TextAlign.center,
                            style:  TextStyle(
                              fontSize: size.width / 20,
                              color: colorGrey
                            ),
                          )
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.all(25),
                            child: Text(
                              "INFORMACIÓN DEL DEPÓSITO",
                              style:  TextStyle(
                                fontSize: size.width / 20,
                                color: colorGrey
                              ),
                            ),
                          ),
                        ),
                        dropdownList(0, 'Bank'),
                        dropdownList(1, 'Selfie'),
                        dropdownList(2, 'Identification'),
                        dropdownList(3, 'RIF'),
                        Padding(
                          padding: EdgeInsets.fromLTRB(30, 20, 30, 5),
                          child: Text(
                            "Depositaremos tus ventas el DIA a la HORA en tu cuenta bancaria.",
                            textAlign: TextAlign.center,
                            style:  TextStyle(
                              fontSize: size.width / 20,
                              color: colorGrey
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(30, 20, 30, 0),
                          child: Text(
                            "El depósito te llegara dos dias habiles despues",
                            textAlign: TextAlign.center,
                            style:  TextStyle(
                              fontSize: size.width / 20,
                              color: colorGrey
                            ),
                          ),
                        ),
                        
                      ],
                    )
                  )
                ),
              ),
            ],
          )
        ),
      );
  }

  showDeposits(){
    var lowPrice = MoneyMaskedTextController(initialValue: 0, decimalSeparator: ',', thousandSeparator: '.',  leftSymbol: ' \$', );
  
    if(_statusCoin == 1)
      lowPrice = new MoneyMaskedTextController(initialValue: 0, decimalSeparator: ',', thousandSeparator: '.',  leftSymbol: 'Bs ', );
    
    return "${lowPrice.text}";
  }

  Widget buttonUSD(){
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(right:0),
      child: GestureDetector(
        onTap: () => verifyStatusBank(context, 0), 
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
        onTap: () => verifyStatusBank(context, 1), 
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

  dropdownList(index, title){
    var myProvider = Provider.of<MyProvider>(context, listen: false);

    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        if(!myProvider.listVerification.contains(title)) 
          nextPage(listMenuDeposits[index]['page'], index);
      },
      child: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top:5),
            child: Container(
              width: size.width,
              color: _statusButton.contains(index)? colorGreen : colorGrey,
              height: 45,
              child: Container(
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left:25),
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: listMenuDeposits[index]['icon'] == ''? Colors.transparent : Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Padding(
                padding: EdgeInsets.only(top:15, bottom: 15, left: 10, right: 10),
                child: Visibility(
                  visible: listMenuDeposits[index]['icon'] == ''? false : true,
                  child: Image.asset(
                    listMenuDeposits[index]['icon'],
                    color: _statusButton.contains(index)? colorGreen : Colors.black,
                  )
                ),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.only(left:100, top: 20),
            child: Text(
              listMenuDeposits[index]['title'],
              style: TextStyle(
                fontSize: size.width / 20,
                color: _statusButton.contains(index)? Colors.white : Colors.black,
              ),
            ),
          ),

          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(right: 30, top: 15),
              child: myProvider.listVerification.contains(title)? Icon(Icons.check_circle, color: colorGreen,) :  Icon(Icons.error, color: Colors.red,),
            )
          ),
        ],
      ),
    );
  }

  nextPage(page, index)async{
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    setState(() =>_statusButton.add(index));
    await Future.delayed(Duration(milliseconds: 150));
    setState(() =>_statusButton.remove(index));

    if(myProvider.dataCommercesUser.length != 0){
      //TODO: Falta validar diferente comercio
      Navigator.push(context, SlideLeftRoute(page: page));
    }else{
      Navigator.push(context, SlideLeftRoute(page: page));
    }
  }
}