import 'package:ctpaga/animation/slideRoute.dart';
import 'package:ctpaga/views/navbar/navbar.dart';
import 'package:ctpaga/providers/provider.dart';
import 'package:ctpaga/env.dart';

import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:video_player/video_player.dart';
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
  VideoPlayerController _controller;
  List _statusButton = new List();

  void initState() {
    super.initState();
    initialVariable();
  }

  void dispose(){
    _controller.dispose();
    super.dispose();
  }

  initialVariable(){
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    changeVideo(myProvider);
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
                                GestureDetector(
                                  onTap: () async {
                                    myProvider.selectCoinDeposits = myProvider.selectCoinDeposits == 0 ? 1 : 0;
                                    setState(() {
                                      _controller.play();
                                    });
                                    await Future.delayed(Duration(milliseconds: 150));
                                    changeVideo(myProvider);
                                  },
                                  child: Container(
                                    alignment: Alignment.centerRight,
                                    padding: EdgeInsets.only(top: 20, right:30),
                                    child: _controller != null?
                                        Container(
                                            width: size.width/3.5,
                                            height: size.width/3.5,
                                            child: VideoPlayer(_controller),
                                          )
                                      :
                                        Container(),
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
                                    showDeposits(myProvider),
                                    style:  TextStyle(
                                      fontSize: size.width / 10,
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
                                Consumer<MyProvider>(
                                  builder: (context, myProvider, child) {
                                    return Visibility(
                                      visible: myProvider.listVerification.length != 4? true : false,
                                      child: Text(
                                        "Necesitamos que completes la información marcada en rojo debajo",
                                        textAlign: TextAlign.center,
                                        style:  TextStyle(
                                          fontSize: size.width / 20,
                                          color: colorGrey
                                        ),
                                      )
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
                                        fontSize: size.width / 20,
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
              ],
            ),
          )
        );
      }
    );
  }

  changeVideo(myProvider){
    if(myProvider.selectCoinDeposits == 0){
      _controller = VideoPlayerController.asset("assets/videos/botonUSD.mp4");
    }else{
       _controller = VideoPlayerController.asset("assets/videos/botonBs.mp4");
    }
    _controller.initialize();
  }

  showDeposits(myProvider){
    var lowPrice = MoneyMaskedTextController(initialValue: 0, decimalSeparator: ',', thousandSeparator: '.',  leftSymbol: '\$ ', );
  
    if(myProvider.selectCoinDeposits == 1)
      lowPrice = new MoneyMaskedTextController(initialValue: 0, decimalSeparator: ',', thousandSeparator: '.',  leftSymbol: 'Bs ', );
    
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
    setState(() =>_statusButton.add(index));
    await Future.delayed(Duration(milliseconds: 100));
    setState(() =>_statusButton.remove(index));

    Navigator.push(context, SlideLeftRoute(page: page));
  }
}