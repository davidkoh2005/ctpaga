import 'package:ctpaga/animation/slideRoute.dart';
import 'package:ctpaga/models/picture.dart';
import 'package:ctpaga/models/user.dart';
import 'package:ctpaga/models/bank.dart';
import 'package:ctpaga/views/loginPage.dart';
import 'package:ctpaga/views/mainPage.dart';
import 'package:ctpaga/database.dart';
import 'package:ctpaga/env.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

class MyProvider with ChangeNotifier {

  String _accessToken;
  String get accessTokenUser =>_accessToken; 
  
  set accessTokenUser(String newToken) {
    _accessToken = newToken; 
    notifyListeners(); 
  }

  User _user = User();
  User get dataUser =>_user;

  set dataUser(User newUser){
    _user = newUser;
    notifyListeners();
  }

  int _coinUser;
  int get coinUsers =>_coinUser; 
  
  set coinUsers(int newCoin) {
    _coinUser = newCoin; 
    notifyListeners(); 
  }

  List _bank = new List(2);
  List get dataBanksUser =>_bank;

  set dataBanksUser(List newBankUser){
    _bank = newBankUser;
    notifyListeners();
  }

  List _storage = new List();
  List get dataPicturesUser =>_storage;

  set dataPicturesUser(List newStorageUser){
    _storage = newStorageUser;
    notifyListeners();
  }

  User user = User();
  List bankUser = new List(2);
  Bank bankUserUSD = Bank();
  Bank bankUserBs = Bank();
  Picture pictureUser = Picture();
  List listPicturesUser = new List();

  getDataUser(status, context)async{
    //call function BD
    var dbctpaga = DBctpaga();    

    var result, response, jsonResponse;
    listPicturesUser = [];

    try {
      result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        response = await http.post(
          urlApi+"user",
          headers:{
            'Content-Type': 'application/json',
            'X-Requested-With': 'XMLHttpRequest',
            'authorization': 'Bearer $accessTokenUser',
          },
        ); 

        print("access: $accessTokenUser"); //TODO: eliminar

        jsonResponse = jsonDecode(response.body);
        print(jsonResponse);
        if (jsonResponse['statusCode'] == 201) {
          user = User(
            id: jsonResponse['data']['0']['id'],
            rifCompany: jsonResponse['data']['0']['rifCompany'] == null? '' : jsonResponse['data']['0']['rifCompany'],
            nameCompany: jsonResponse['data']['0']['nameCompany'] == null? '' : jsonResponse['data']['0']['nameCompany'],
            addressCompany: jsonResponse['data']['0']['addressCompany'] == null? '' : jsonResponse['data']['0']['addressCompany'],
            phoneCompany: jsonResponse['data']['0']['phoneCompany'] == null? '' : jsonResponse['data']['0']['phoneCompany'],
            email: jsonResponse['data']['0']['email'],
            name: jsonResponse['data']['0']['name'],
            address: jsonResponse['data']['0']['address'],
            phone: jsonResponse['data']['0']['phone'],
            coin: jsonResponse['data']['0']['coin'],
          );

          dataUser = user;

          if(await dbctpaga.existUser() == 0)
            dbctpaga.addNewUser(user);
          else
            dbctpaga.updateUser(user);

          if(jsonResponse['data']['banks'] != null){

            for (var item in jsonResponse['data']['banks']) {
              if(item['coin'] == 'USD'){
                bankUserUSD = Bank(
                  coin: item['coin'],
                  country: item['country'],
                  accountName: item['accountName'],
                  accountNumber: item['accountNumber'],
                  route: item['route'],
                  swift: item['swift'],
                  address: item['address'],
                  bankName: item['bankName'],
                  accountType: item['accountType'],
                ); 

                dbctpaga.createOrUpdateBankUser(bankUserUSD);
                bankUser[0] = bankUserUSD;

              }else{
                bankUserBs = Bank(
                  coin: item['coin'],
                  accountName: item['accountName'],
                  accountNumber: item['accountNumber'],
                  idCard: item['idCard'],
                  bankName: item['bankName'],
                  accountType: item['accountType'],
                ); 

                dbctpaga.createOrUpdateBankUser(bankUserBs);
                bankUser[1] = bankUserBs;
              }
            }
          }
          
          dataBanksUser = bankUser;

          if(jsonResponse['data']['pictures'] != null){
            for (var item in jsonResponse['data']['pictures']) {
              pictureUser = Picture(
                id: item['id'],
                description: item['description'],
                url: item['url'],
              );
              
              dbctpaga.createOrUpdatePicturesUser(pictureUser);
              listPicturesUser.add(pictureUser);
            }
          }

          dataPicturesUser = listPicturesUser; 

          if(status){
            Navigator.pushReplacement(context, SlideLeftRoute(page: MainPage()));
          }
        }else{
          removeSession(context);
        }
      }
    } on SocketException catch (_) {
      if(accessTokenUser != null){
        dataUser = await dbctpaga.getUser();
        dataBanksUser = await dbctpaga.getBanksUser();
        dataPicturesUser = await dbctpaga.getPicturesUser();

      }

      if(status){
        Navigator.pushReplacement(context, SlideLeftRoute(page: MainPage()));
      }
    }
  }

  removeSession(BuildContext context)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("access_token");
    accessTokenUser = null;
    dataUser = null;
    dataBanksUser = null;
    dataPicturesUser = null;
    Navigator.pushReplacement(context, SlideLeftRoute(page: LoginPage()));
  }

}