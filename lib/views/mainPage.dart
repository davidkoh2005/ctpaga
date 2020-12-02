import 'package:ctpaga/animation/slideRoute.dart';
import 'package:ctpaga/views/navbar/navbarMain.dart';
import 'package:ctpaga/views/productsServicesPage.dart';
import 'package:ctpaga/views/amountPage.dart';
import 'package:ctpaga/providers/provider.dart';
import 'package:ctpaga/models/user.dart';
import 'package:ctpaga/models/bank.dart';
import 'package:ctpaga/env.dart';

import 'package:video_player/video_player.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';


class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  VideoPlayerController _controller;
  User user = User();
  List bankUser = new List(2);
  Bank bankUserUSD = Bank();
  Bank bankUserBs = Bank();
  int clickBotton = 0, _statusCoin = 0;

  @override
  void initState() {
    super.initState();
    initialVariable();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  initialVariable(){
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    _statusCoin = myProvider.coinUsers;
    changeVideo();
  }

  changeVideo(){
    if(_statusCoin == 0){
      _controller = VideoPlayerController.asset("assets/videos/botonUSD.mp4");
    }else{
       _controller = VideoPlayerController.asset("assets/videos/botonBs.mp4");
    }
    print("coin: $_statusCoin");
    _controller.initialize();
  }

  @override
  Widget build(BuildContext context) {
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    var size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        if(myProvider.statusButtonMenu){
          myProvider.statusButtonMenu = false;
        }
        
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget> [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                NavbarMain(),
                GestureDetector(
                  onTap: () async {
                    myProvider.coinUsers = _statusCoin == 0 ? 1 : 0;
                    setState(() {
                      _controller.play();
                      _statusCoin = _statusCoin == 0 ? 1 : 0;
                    });
                    await Future.delayed(Duration(milliseconds: 150));
                    changeVideo();
                  },
                  child: Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(top: 10, right:30),
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
                Expanded(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      buttonMain("Productos",1, ProductsServicesPage(true)), //send variable the same design
                      buttonMain("Servicios",2, ProductsServicesPage(true)), //send variable the same design
                      buttonMain("Monto",3, AmountPage()), //send variable the same design
                      SizedBox(height:100),
                    ]
                  )
                ),
              ],
            ),
          ]
        )
      )
    );
  }
  

  Widget buttonMain(_title, _index, _page){
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: GestureDetector(
        onTap: () {
          setState(() => clickBotton = _index); //I add color selected button
          nextPage(_page, _index); //next page
        },
        child: Container(
          width:size.width - 100,
          height: size.height / 20,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                clickBotton == _index? colorGreen : colorGrey,
                clickBotton == _index? colorGreen : colorGrey,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Text(
              _title,
              style: TextStyle(
                color: Colors.white,
                fontSize: size.width / 20,
              ),
            ),
          ),
        ),
      )
    );
  }

  changeButtonCoin(coin){
    var myProvider = Provider.of<MyProvider>(context, listen: false);

    setState(() => _statusCoin = coin);
    myProvider.coinUsers = coin;
  }

  Future<void> showMessage(_titleMessage, _statusCorrectly) async {
    var size = MediaQuery.of(context).size;

    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
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
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: size.width / 20,
                  )
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  nextPage(Widget page, _index)async{
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    await Future.delayed(Duration(milliseconds: 150)); //wait time
    setState(() => clickBotton = 0); //delete selected button color

    if(verifyDataCommerce(myProvider)){
      showMessage("Debe ingresar los datos de la empresa", false);
    }else if(verifyPicture(myProvider)){
      showMessage("Debe ingresar el logo de la empresa", false);
    }else if(myProvider.dataRates.length == 0){
      showMessage("Debe ingresar la tasa de cambio", false);
    }else{
      if(_index == 1){
        myProvider.clickButtonMenu = 3;
        myProvider.selectProductsServices = 0;
        myProvider.statusTrolleyAnimation = 1.0;
        myProvider.getListCategories();
      }else if(_index == 2){
        myProvider.clickButtonMenu = 4;
        myProvider.selectProductsServices = 1;
        myProvider.statusTrolleyAnimation = 1.0;
        myProvider.getListCategories();
      }else{
        myProvider.selectDateRate = 0;
        myProvider.statusTrolleyAnimation = 1.0;
        myProvider.statusRemoveShopping = false;
      }
      Navigator.push(context, SlideLeftRoute(page: page));
    }
  }

  verifyPicture(myProvider){
    for (var item in myProvider.dataPicturesUser) {
      if(item != null && item.description == 'Profile' && item.commerce_id == myProvider.dataCommercesUser[myProvider.selectCommerce].id){
        return false;
      }
    }
    return true;
  }

  verifyDataCommerce(myProvider){
    if(myProvider.dataCommercesUser.length != 0){
      if(myProvider.dataCommercesUser[myProvider.selectCommerce].rif != '' && myProvider.dataCommercesUser[myProvider.selectCommerce].name != '' && myProvider.dataCommercesUser[myProvider.selectCommerce].userUrl != '')
        return false;
    }

    return true;
  }

}

class NavBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    var sw = size.width;
    var sh = size.height;

    path.cubicTo(sw / 12, 0, sw / 12, 2 * sh / 5, 2 * sw / 12, 2 * sh / 5);
    path.cubicTo(3 * sw / 12, 2 * sh / 5, 3 * sw / 12, 0, 4 * sw / 12, 0);
    path.cubicTo(
        5 * sw / 12, 0, 5 * sw / 12, 2 * sh / 5, 6 * sw / 12, 2 * sh / 5);
    path.cubicTo(7 * sw / 12, 2 * sh / 5, 7 * sw / 12, 0, 8 * sw / 12, 0);
    path.cubicTo(
        9 * sw / 12, 0, 9 * sw / 12, 2 * sh / 5, 10 * sw / 12, 2 * sh / 5);
    path.cubicTo(11 * sw / 12, 2 * sh / 5, 11 * sw / 12, 0, sw, 0);
    path.lineTo(sw, sh);
    path.lineTo(0, sh);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class NavBarClipperSearch extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    var sw = size.width;
    var sh = size.height;

    path.cubicTo(4 * sw / 12, sh / 40, 3 * sw / 12, 0, 4 * sw / 12, 0);
    path.cubicTo(
        5 * sw / 12, 0, 5 * sw / 12, 2 * sh / 5, 6 * sw / 12, 2 * sh / 5);
    path.cubicTo(7 * sw / 12, 2 * sh / 5, 7 * sw / 12, 0, 8 * sw / 12, 0);
    path.lineTo(sw, 0);
    path.lineTo(sw, sh);
    path.lineTo(0, sh);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
