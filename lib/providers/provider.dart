import 'package:ctpaga/models/user.dart';
import 'package:ctpaga/models/bank.dart';

import 'package:flutter/foundation.dart';

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

}