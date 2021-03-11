import 'package:ctpaga/animation/slideRoute.dart';
import 'package:ctpaga/views/navbar/navbar.dart';
import 'package:ctpaga/providers/provider.dart';
import 'package:ctpaga/env.dart';

import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class DepositsPage extends StatefulWidget {
  DepositsPage(this._statusMenuBar);
  final bool _statusMenuBar;
  @override
  _DepositsPageState createState() => _DepositsPageState(this._statusMenuBar);
}

class _DepositsPageState extends State<DepositsPage> {
  _DepositsPageState(this._statusMenuBar);
  final bool _statusMenuBar;
  final _scrollController = ScrollController();
  bool _statusInfoPayment = false;
  List _statusButton = new List();
  double _positionTopFirst = 0,
        _positionTopSecond = 35;

  void initState() {
    super.initState();
    initialVariable();
  }

  void dispose(){
    super.dispose();
  }

  initialVariable(){
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    if(myProvider.selectCoinDeposits == 1){
      setState(() {
        _positionTopFirst = 35;
        _positionTopSecond = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Consumer<MyProvider>(
      builder: (context, myProvider, child) {
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
            body: Stack(
              children: <Widget>[
                Container(
                  height: size.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Visibility(
                        visible: !_statusMenuBar,
                        child: Navbar("Banco", false)
                      ),
                      Expanded(
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
                                  padding: _statusMenuBar? EdgeInsets.only(top:40) : EdgeInsets.zero ,
                                  child: GestureDetector(
                                    onTap: () async {
                                      myProvider.selectCoinDeposits = myProvider.selectCoinDeposits == 0 ? 1 : 0;
                                      await Future.delayed(Duration(milliseconds: 200));
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
                                          children: myProvider.selectCoinDeposits == 0 ?[
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
                                  )
                                ),

                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(top:10, left: 25, bottom: 25),
                                    child: AutoSizeText(
                                      "PROXIMO DEPÓSITO",
                                      style:  TextStyle(
                                        color: colorGrey
                                      ),
                                      maxFontSize: 14,
                                      minFontSize: 14,
                                    ),
                                  ),
                                ),
                                Container(
                                  child: AutoSizeText(
                                    showDeposits(myProvider),
                                    style:  TextStyle(
                                      fontFamily: 'MontserratSemiBold',
                                    ),
                                    maxFontSize: 28,
                                    minFontSize: 28,
                                  ),
                                ),

                                Consumer<MyProvider>(
                                  builder: (context, myProvider, child) {
                                    return Column(
                                      children : <Widget>[
                                        Visibility(
                                          visible: myProvider.listVerification.length != 4? true : false,
                                          child: Padding(
                                            padding: EdgeInsets.only(top: 10, bottom: 10),
                                            child: Container(
                                              width:size.width - 100,
                                              height: size.height / 20,
                                              decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius: BorderRadius.circular(30),
                                              ),
                                              child: Center(
                                                child: AutoSizeText(
                                                  'No podemos enviarte tu dinero',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: 'MontserratSemiBold',
                                                  ),
                                                  maxFontSize: 14,
                                                  minFontSize: 14,
                                                ),
                                              ),
                                            )
                                          ),
                                        ),

                                        Visibility(
                                          visible: myProvider.listVerification.length != 4? true : false,
                                          child: AutoSizeText(
                                            "Necesitamos que completes la información marcada en rojo debajo",
                                            textAlign: TextAlign.center,
                                            style:  TextStyle(
                                              color: colorGrey,
                                              fontFamily: 'MontserratSemiBold',
                                            ),
                                            maxFontSize: 14,
                                            minFontSize: 14,
                                          )
                                        ),
                                        
                                      ]
                                    );
                                  }
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: EdgeInsets.all(25),
                                    child: AutoSizeText(
                                      "INFORMACIÓN DEL DEPÓSITO",
                                      style:  TextStyle(
                                        color: colorGrey,
                                        fontFamily: 'MontserratSemiBold',
                                      ),
                                      maxFontSize: 14,
                                      minFontSize: 14,
                                    ),
                                  ),
                                ),
                                dropdownList(0, 'Bank', myProvider),
                                dropdownList(1, 'Selfie', myProvider),
                                dropdownList(2, 'Identification', myProvider),
                                dropdownList(3, 'RIF', myProvider),               
                              ],
                            )
                          )
                        ),
                      ),
                    ],
                  )
                ),
                
                AnimatedPositioned(
                  duration: Duration(milliseconds:300),
                  bottom: _statusInfoPayment? 0 : -140,
                  child: Container(
                    width: size.width,
                    height: size.height /3.7, 
                    alignment: Alignment.bottomCenter,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15)
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.8),
                          spreadRadius: 15,
                          blurRadius: 20,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: (){
                            setState(() => _statusInfoPayment = !_statusInfoPayment);
                          },
                          child: Container(
                            color: Colors.white,
                            width: size.width,
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              width: size.width / 10,
                              height: size.width / 10,
                              child: Center(
                                child:Image.asset(
                                  _statusInfoPayment? "assets/icons/arrows_down.png" : "assets/icons/arrows_up.png",
                                  width: size.width / 15,
                                  height: size.width / 15,
                                  color: colorGreyLogo
                                ) 
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5, bottom:20),
                          child: AutoSizeText(
                            "¿Cuándo llegara mi dinero?",
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'MontserratSemiBold',
                              fontWeight: FontWeight.bold,
                            ),
                            maxFontSize: 14,
                            minFontSize: 14,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(30, 10, 30, 5),
                          child: AutoSizeText(
                            "Depositaremos tus ventas TODOS LOS DIAS a tu cuenta bancaria.",
                            textAlign: TextAlign.center,
                            style:  TextStyle(
                              color: colorGrey,
                              fontFamily: 'MontserratSemiBold',
                            ),
                            maxFontSize: 14,
                            minFontSize: 14,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(30, 10, 30, 15),
                          child: AutoSizeText(
                            "El depósito a Bancos Nacionales, estarán disponibles a las 01:00 PM, en caso de ser Bancos en Panamá o USA, se harán efectivos a más tardar en 48 horas.",
                            textAlign: TextAlign.center,
                            style:  TextStyle(
                              color: colorGrey,
                              fontFamily: 'MontserratSemiBold',
                            ),
                            maxFontSize: 14,
                            minFontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        );
      }
    );
  }

  Widget coinSecond(){
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
            child: AutoSizeText(
              "Bs",
              style:  TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'MontserratSemiBold',
              ),
              maxFontSize: 18,
              minFontSize: 18,
            )
          ),
        )
      ),
    );
  }

  Widget coinFirst(){
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
          child: AutoSizeText(
            "\$" ,
            style:  TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'MontserratSemiBold',
            ),
            maxFontSize: 18,
            minFontSize: 18,
          ),
        ),
      ),
    );
  }

  showDeposits(myProvider){
    var lowPrice = MoneyMaskedTextController(initialValue: 0, decimalSeparator: ',', thousandSeparator: '.',  leftSymbol: '\$ ', );
  
    if(myProvider.selectCoinDeposits == 1)
      lowPrice = new MoneyMaskedTextController(initialValue: 0, decimalSeparator: ',', thousandSeparator: '.',  leftSymbol: 'Bs ', );
    
    for (var item in myProvider.dataBalances) {
      if(item.coin == myProvider.selectCoinDeposits){
        lowPrice.updateValue(double.parse(item.total));
        break;
      }
    }

    return "${lowPrice.text}";
  }

  dropdownList(index, title, myProvider){
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
              color: _statusButton.contains(index)? colorGreen : colorGreyOpacity,
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
            child: AutoSizeText(
              listMenuDeposits[index]['title'],
              style: TextStyle(
                color: _statusButton.contains(index)? Colors.white : Colors.black,
                fontFamily: 'MontserratSemiBold',
              ),
              maxFontSize: 14,
              minFontSize: 14,
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
    setState(() =>_statusButton.add(index));
    await Future.delayed(Duration(milliseconds: 100));
    setState(() =>_statusButton.remove(index));

    Navigator.push(context, SlideLeftRoute(page: page));
  }
}