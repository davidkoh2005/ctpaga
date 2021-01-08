import 'package:ctpaga/animation/slideRoute.dart';
import 'package:ctpaga/views/navbar/navbar.dart';
import 'package:ctpaga/providers/provider.dart';
import 'package:ctpaga/env.dart';

import 'package:flutter_masked_text/flutter_masked_text.dart';
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
    var scaleFactor = MediaQuery.of(context).textScaleFactor;
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
                                    padding: EdgeInsets.all(25),
                                    child: Text(
                                      "PROXIMO DEPÓSITO",
                                      style:  TextStyle(
                                        fontSize: 15 * scaleFactor,
                                        color: colorGrey
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    showDeposits(myProvider),
                                    style:  TextStyle(
                                      fontSize: 34 * scaleFactor,
                                    ),
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
                                                child: Text(
                                                  'No podemos enviarte tu dinero',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15 * scaleFactor,
                                                  ),
                                                ),
                                              ),
                                            )
                                          ),
                                        ),

                                        Visibility(
                                          visible: myProvider.listVerification.length != 4? true : false,
                                          child: Text(
                                            "Necesitamos que completes la información marcada en rojo debajo",
                                            textAlign: TextAlign.center,
                                            style:  TextStyle(
                                              fontSize: 15 * scaleFactor,
                                              color: colorGrey
                                            ),
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
                                    child: Text(
                                      "INFORMACIÓN DEL DEPÓSITO",
                                      style:  TextStyle(
                                        fontSize: 15 * scaleFactor,
                                        color: colorGrey
                                      ),
                                    ),
                                  ),
                                ),
                                dropdownList(0, 'Bank', myProvider),
                                dropdownList(1, 'Selfie', myProvider),
                                dropdownList(2, 'Identification', myProvider),
                                dropdownList(3, 'RIF', myProvider),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(30, 20, 30, 5),
                                  child: Text(
                                    "Depositaremos tus ventas el DIA a la HORA en tu cuenta bancaria.",
                                    textAlign: TextAlign.center,
                                    style:  TextStyle(
                                      fontSize: 15 * scaleFactor,
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
                                      fontSize: 15 * scaleFactor,
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
              ],
            ),
          )
        );
      }
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
    var scaleFactor = MediaQuery.of(context).textScaleFactor;
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
            child: Text(
              listMenuDeposits[index]['title'],
              style: TextStyle(
                fontSize: 15 * scaleFactor,
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
    setState(() =>_statusButton.add(index));
    await Future.delayed(Duration(milliseconds: 100));
    setState(() =>_statusButton.remove(index));

    Navigator.push(context, SlideLeftRoute(page: page));
  }
}