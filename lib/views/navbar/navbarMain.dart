import 'package:ctpaga/animation/slideRoute.dart';
import 'package:ctpaga/views/profilePage.dart';
import 'package:ctpaga/providers/provider.dart';
import 'package:ctpaga/env.dart';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
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
    var size = MediaQuery.of(context).size;
    return Consumer<MyProvider>(
      builder: (context, myProvider, child) {
        return Stack(
          children: <Widget>[
            Container(
              color: Colors.white,
              width: size.width,
              height: size.height/7,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 20, right: 15),
                    child: GestureDetector(
                      onTap: () async {
                        myProvider.clickButtonMenu = 1;
                        await Future.delayed(Duration(milliseconds: 150));
                        Navigator.push(context, SlideLeftRoute(page: ProfilePage()));
                      },
                      child: Container(
                        width: size.width/8,
                        height: size.width/8,
                        child: showImagen(myProvider),
                      )
                    ),
                  ),
                    
                      
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

            GestureDetector(
              onTap: () => launch("http://$url"),
              child: Padding(
                padding: EdgeInsets.only(top: 35, left: 30),
                child: Container(
                  child: Image(
                    image: AssetImage("assets/logo/logo2.png"),
                    width: size.width/3.5,
                  ),
                )
              )
            ),

          ],
        );
      }
    );

  }

  showImagen(myProvider){
    var size = MediaQuery.of(context).size;
    var urlProfile; 
    if(myProvider.dataPicturesUser != null){
      for (var item in myProvider.dataPicturesUser) {

        if(item != null && item.description == 'Profile' && item.commerce_id == myProvider.dataCommercesUser[myProvider.selectCommerce].id){
          if(urlProfile != null)
            if(urlProfile.indexOf('/storage/Users/')<0)
              DefaultCacheManager().emptyCache();
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
                  valueColor: new AlwaysStoppedAnimation<Color>(colorLogo),
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
        "assets/icons/perfil2.png",
        fit: BoxFit.cover
      ),
    );
  }

}