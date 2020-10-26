import 'package:ctpaga/animation/slideRoute.dart';
import 'package:ctpaga/models/user.dart';
import 'package:ctpaga/models/bank.dart';
import 'package:ctpaga/views/mainPage.dart';
import 'package:ctpaga/env.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

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

  List _bank = new List(2);
  List get dataBankUser =>_bank;

  set dataBankUser(List newBankUser){
    _bank = newBankUser;
    notifyListeners();
  }

  User user = User();
  List bankUser = new List(2);
  Bank bankUserUSD = Bank();
  Bank bankUserBs = Bank();

  getDataUser(status, context)async{
    var result, response, jsonResponse;
    try {
      result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        response = await http.post(
          urlApi+"user/",
          headers:{
            'Content-Type': 'application/json',
            'X-Requested-With': 'XMLHttpRequest',
            'authorization': 'Bearer $accessTokenUser',
          },
        ); 

        print("access: $accessTokenUser"); //TODO: eliminar

        jsonResponse = jsonDecode(response.body);

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
            statusProfile: jsonResponse['data']['0']['statusProfile'] == null? false : jsonResponse['data']['0']['statusProfile'] ,
            coin: jsonResponse['data']['0']['coin'],
          );

          dataUser = user;

          if(jsonResponse['data']['banks'] != null){

            for (var item in jsonResponse['data']['banks']) {
              if(item['coin'] == 'USD'){
                bankUserUSD = Bank(
                  country: item['country'],
                  accountName: item['accountName'],
                  accountNumber: item['accountNumber'],
                  route: item['route'],
                  swift: item['swift'],
                  address: item['address'],
                  bankName: item['bankName'],
                  accountType: item['accountType'],
                ); 
                
                bankUser[0] = bankUserUSD;

              }else{
                bankUserBs = Bank(
                  accountName: item['accountName'],
                  accountNumber: item['accountNumber'],
                  idCard: item['idCard'],
                  bankName: item['bankName'],
                  accountType: item['accountType'],
                ); 

                bankUser[1] = bankUserBs;
              }
            }

          }
          
          dataBankUser = bankUser;

          if(status){
            Navigator.pushReplacement(context, SlideLeftRoute(page: MainPage()));
          }
        }  
      }
    } on SocketException catch (_) {
      print("error network");
    }
  }

}