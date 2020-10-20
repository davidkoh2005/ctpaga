import 'package:flutter/foundation.dart';

class MyProvider with ChangeNotifier {

  String _accessToken = "";
  String get accessTokenUser =>_accessToken; 
  
  set accessTokenUser(String newToken) {
    _accessToken = newToken; 
    notifyListeners(); 
  }

}