import 'package:ctpaga/animation/slideRoute.dart';
import 'package:ctpaga/views/perfilPage.dart';
import 'package:ctpaga/providers/provider.dart';
import 'package:ctpaga/env.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class NavbarMain extends StatefulWidget {
  NavbarMain();

  @override
  _NavbarMainState createState() => _NavbarMainState();
}

class _NavbarMainState extends State<NavbarMain> {
  _NavbarMainState();

  @override
  Widget build(BuildContext context) {
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    var size = MediaQuery.of(context).size;

    return Stack(
      children: <Widget>[
        Container(
          width: size.width,
          height: size.height/7,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top:20, right:20),
                child: IconButton(
                  iconSize: size.width / 10,
                  icon: Icon(
                    Icons.menu,
                    color: Colors.black,
                    ),
                  onPressed: () {
                    myProvider.statusButtonMenu = true;
                  }
                )
              )
            ]
          ),
        ),

        Padding(
          padding: EdgeInsets.only(top: 50, left: 50),
          child: GestureDetector(
            onTap: () {
              myProvider.clickButtonMenu = 1;
              Navigator.push(context, SlideLeftRoute(page: PerfilPage()));
            },
            child: Container(
              width: size.width/8,
              height: size.width/8,
              child: showImagen(),
            )
          )
        ),

      ],
    );

  }

  showImagen(){
    var myProvider = Provider.of<MyProvider>(context, listen: false);
    var size = MediaQuery.of(context).size;
    var urlProfile='';

    if(myProvider.dataPicturesUser != null){
      for (var item in myProvider.dataPicturesUser) {
        if(item != null && item.description == 'Profile' && item.commerce_id == myProvider.dataCommercesUser[myProvider.selectCommerce].id){
          urlProfile = item.url;
          break;
        }
      }
      
      //removeCache();

      if (urlProfile != null)
      {
        return ClipOval(
          child: new CachedNetworkImage(
            imageUrl: "http://"+url+urlProfile,
            fit: BoxFit.cover,
            placeholder: (context, url) {
              return Container(
                margin: EdgeInsets.all(15),
                child:CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(colorGreen),
                ),
              );
            },
            errorWidget: (context, url, error) => Icon(Icons.error, color: Colors.red, size: size.width / 8),
          ),
        );
      }
    } 

    return ClipOval(
      child: Image.asset(
        "assets/icons/perfil.png",
        fit: BoxFit.cover
      ),
    );
  }
}