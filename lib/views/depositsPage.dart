import 'package:ctpaga/animation/slideRoute.dart';
import 'package:ctpaga/views/navbar/navbar.dart';
import 'package:ctpaga/providers/provider.dart';
import 'package:ctpaga/env.dart';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class DepositsPage extends StatefulWidget {
  @override
  _DepositsPageState createState() => _DepositsPageState();
}

class _DepositsPageState extends State<DepositsPage> {
  final _scrollController = ScrollController();
  List statusButton = [];
  bool _statusBank = false, _statusIdentication = false, _statusSelfie = false, _statusRif = false;
  int countStatus = 4;
  int _statusCoin = 0;

  void initState() {
    super.initState();
    verifyStatusBank(context);
  }

  void dispose(){
    super.dispose();
  }

  verifyStatusBank(BuildContext context){
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    //myProvider.getDataUser(false, context);

    setState(() {
      _statusBank = myProvider.dataBanksUser[_statusCoin] == null ? false : true;
      countStatus -= 1;
    });
    
    for (var item in myProvider.dataPicturesUser) {
      if(item.description == 'Identification'){
        setState(() { 
          _statusIdentication = true;
          countStatus -= 1;
        });
      }else if(item.description == 'Selfie'){
        setState(() {
          _statusSelfie = true;
          countStatus -= 1;
        });
      }else if(item.description == 'RIF'){
        setState(() {
          _statusRif = true;
          countStatus -= 1;
        });
      }
    }
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
              Container(
                height: size.height - 160,
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
                          padding: EdgeInsets.only(top:20, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              buttonUSD(),
                              buttonBs(),
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
                        _statusCoin == 0? Text(
                            "\$ 0,00",
                            style:  TextStyle(
                              fontSize: size.width / 6,
                            ),
                          )
                        : Text(
                            "Bs 0,00",
                            textAlign: TextAlign.center,
                            style:  TextStyle(
                              fontSize: size.width / 6,
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
                          visible: countStatus != 0? true : false,
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
                        dropdownList(0, _statusBank),
                        dropdownList(1, _statusIdentication),
                        dropdownList(2, _statusSelfie),
                        dropdownList(3, _statusRif),
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

  Widget buttonUSD(){
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(left:30),
      child: GestureDetector(
        onTap: () => setState(() => _statusCoin = 0), 
        child: Container(
          width:size.width / 5,
          height: size.height / 25,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                _statusCoin == 0? colorGreen : colorGrey,
                _statusCoin == 0? colorGreen : colorGrey
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30),
            ),
          child: Center(
            child: Text(
              "\$",
              style: TextStyle(
                color: Colors.white,
                fontSize: size.width / 20,
                fontWeight: FontWeight.w500,
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
      padding: EdgeInsets.only(left:20),
      child: GestureDetector(
        onTap: () => setState(() => _statusCoin = 1), 
        child: Container(
          width:size.width / 5,
          height: size.height / 25,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                _statusCoin == 1? colorGreen : colorGrey,
                _statusCoin == 1? colorGreen : colorGrey
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30),
            ),
          child: Center(
            child: Text(
              "Bs",
              style: TextStyle(
                color: Colors.white,
                fontSize: size.width / 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      )
    );
  }

  dropdownList(index, status){
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        if(status == false) 
          nextPage(listMenuDeposits[index]['page'], index);
      },
      child: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top:5),
            child: Container(
              width: size.width,
              color: statusButton.contains(index)? colorGreen : colorGrey,
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
                    color: statusButton.contains(index)? colorGreen : Colors.black,
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
                color: statusButton.contains(index)? Colors.white : Colors.black,
              ),
            ),
          ),

          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(right: 30, top: 15),
              child: status? Icon(Icons.check_circle, color: colorGreen,) :  Icon(Icons.error, color: Colors.red,),
            )
          ),
        ],
      ),
    );
  }

 

  nextPage(page, index)async{
    setState(() =>statusButton.add(index));
    await Future.delayed(Duration(milliseconds: 150));
    setState(() =>statusButton.remove(index));
    Navigator.push(context, SlideLeftRoute(page: page));
  }
}