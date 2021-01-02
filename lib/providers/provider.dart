import 'package:ctpaga/animation/slideRoute.dart';
import 'package:ctpaga/models/categories.dart';
import 'package:ctpaga/models/discounts.dart';
import 'package:ctpaga/models/shipping.dart';
import 'package:ctpaga/models/commerce.dart';
import 'package:ctpaga/models/picture.dart';
import 'package:ctpaga/models/product.dart';
import 'package:ctpaga/models/service.dart';
import 'package:ctpaga/models/balance.dart';
import 'package:ctpaga/models/user.dart';
import 'package:ctpaga/models/bank.dart';
import 'package:ctpaga/models/rate.dart';
import 'package:ctpaga/models/paid.dart';
import 'package:ctpaga/views/loginPage.dart';
import 'package:ctpaga/views/mainMenuBar.dart';
import 'package:ctpaga/database.dart';
import 'package:ctpaga/env.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:io';


class MyProvider with ChangeNotifier {
  //call function BD    
  var dbctpaga = DBctpaga();

  String _accessToken;
  String get accessTokenUser =>_accessToken; 
  
  set accessTokenUser(String newToken) {
    _accessToken = newToken; 
    notifyListeners(); 
  }

  bool _statusButtonMenu;
  bool get statusButtonMenu =>_statusButtonMenu; 
  
  set statusButtonMenu(bool newStatus) {
    _statusButtonMenu = newStatus; 
    notifyListeners(); 
  }

  int _clickButtonMenu;
  int get clickButtonMenu =>_clickButtonMenu; 
  
  set clickButtonMenu(int newClick) {
    _clickButtonMenu = newClick; 
    notifyListeners(); 
  }

  bool _statusRemoveShopping;
  bool get statusRemoveShopping =>_statusRemoveShopping; 
  
  set statusRemoveShopping(bool newShopping) {
    _statusRemoveShopping = newShopping; 
    notifyListeners(); 
  }

  int _positionModify;
  int get positionModify =>_positionModify; 
  
  set positionModify(int newPosition) {
    _positionModify = newPosition; 
    notifyListeners(); 
  }

  int _typePositionModify;
  int get typePositionModify =>_typePositionModify; 
  
  set typePositionModify(int newTypePosition) {
    _typePositionModify = newTypePosition; 
    notifyListeners(); 
  }

  String _codUrl;
  String get codeUrl =>_codUrl; 
  
  set codeUrl(String newCode) {
    _codUrl = newCode; 
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

  List _commerces = new List();
  List get dataCommercesUser =>_commerces;

  set dataCommercesUser(List newCommercesUser){
    _commerces = newCommercesUser;
    notifyListeners();
  }

  int _selectCommerce;
  int get selectCommerce =>_selectCommerce; 
  
  set selectCommerce(int newSelectCommerce) {
    _selectCommerce = newSelectCommerce; 
    notifyListeners(); 
  }

  int _selectCoinDeposits;
  int get selectCoinDeposits =>_selectCoinDeposits; 
  
  set selectCoinDeposits(int newSelectCoinDeposits) {
    _selectCoinDeposits = newSelectCoinDeposits; 
    notifyListeners(); 
  }

  List _listVerification = new List();
  List get listVerification =>_listVerification;

  set listVerification(List newListVerification){
    _listVerification = newListVerification;
    notifyListeners();
  }

  List _dataCategories = new List();
  List get dataCategories =>_dataCategories;

  set dataCategories(List newListCategories){
    _dataCategories = newListCategories;
    notifyListeners();
  }

  List _dataCategoriesSelect = new List();
  List get dataCategoriesSelect =>_dataCategoriesSelect;

  set dataCategoriesSelect(List newListCategories){
    _dataCategoriesSelect = newListCategories;
    notifyListeners();
  }

  List _products = new List();
  List get dataProducts =>_products;

  set dataProducts(List newProducts){
    _products = newProducts;
    notifyListeners();
  }

  List _services = new List();
  List get dataServices =>_services;

  set dataServices(List newservice){
    _services = newservice;
    notifyListeners();
  }

  List _productsServicesCategories = new List();
  List get dataProductsServicesCategories =>_productsServicesCategories;

  set dataProductsServicesCategories(List newProductsServices){
    _productsServicesCategories = newProductsServices;
    notifyListeners();
  }

  Product _selectProducts = Product();
  Product get dataSelectProduct =>_selectProducts;

  set dataSelectProduct(Product newProducts){
    _selectProducts = newProducts;
    notifyListeners();
  }

  Service _selectService = Service();
  Service get dataSelectService =>_selectService;

  set dataSelectService(Service newServices){
    _selectService = newServices;
    notifyListeners();
  }

  int _selectProductsServicesInt;
  int get selectProductsServices =>_selectProductsServicesInt; 
  
  set selectProductsServices(int newSelect) {
    _selectProductsServicesInt = newSelect; 
    notifyListeners(); 
  }

  double _statusTrolley;
  double get statusTrolleyAnimation =>_statusTrolley; 
  
  set statusTrolleyAnimation(double newValue) {
    _statusTrolley = newValue; 
    notifyListeners(); 
  }

  bool _statusDolar;
  bool get statusDolar =>_statusDolar; 
  
  set statusDolar(bool newStatus) {
    _statusDolar = newStatus; 
    notifyListeners(); 
  }

  bool _statusBs;
  bool get statusBs =>_statusBs; 
  
  set statusBs(bool newStatus) {
    _statusBs = newStatus; 
    notifyListeners(); 
  }

  bool _statusShipping;
  bool get statusShipping =>_statusShipping; 
  
  set statusShipping(bool newStatus) {
    _statusShipping = newStatus; 
    notifyListeners(); 
  }

  String _descriptionShipping;
  String get descriptionShipping =>_descriptionShipping; 
  
  set descriptionShipping(String newDescription) {
    _descriptionShipping = newDescription; 
    notifyListeners(); 
  }

  List _shipping = new List();
  List get dataShipping =>_shipping;

  set dataShipping(List newShipping){
    _shipping = newShipping;
    notifyListeners();
  }

  List _discount = new List();
  List get dataDiscount =>_discount;

  set dataDiscount(List newDiscount){
    _discount = newDiscount;
    notifyListeners();
  }

  List _rates = new List();
  List get dataRates =>_rates;

  set dataRates(List newRates){
    _rates = newRates;
    notifyListeners();
  }

  List _ratesSelectToday = new List();
  List get dataRatesSelectToday =>_ratesSelectToday;

  set dataRatesSelectToday(List newRates){
    _ratesSelectToday = newRates;
    notifyListeners();
  }

  List _ratesSelectWeek = new List();
  List get dataRatesSelectWeek =>_ratesSelectWeek;

  set dataRatesSelectWeek(List newRates){
    _ratesSelectWeek = newRates;
    notifyListeners();
  }

  List _ratesSelectMonth = new List();
  List get dataRatesSelectMonth =>_ratesSelectMonth;

  set dataRatesSelectMonth(List newRates){
    _ratesSelectMonth = newRates;
    notifyListeners();
  }

  int _selectDate;
  int get selectDateRate =>_selectDate; 
  
  set selectDateRate(int newSelect) {
    _selectDate = newSelect; 
    notifyListeners(); 
  }

  List _listPurchase  = new List();
  List get dataPurchase =>_listPurchase ;

  set dataPurchase(List newPurchase){
    _listPurchase  = newPurchase;
    notifyListeners();
  }

  bool _statusUrl;
  bool get statusUrlCommerce =>_statusUrl; 
  
  set statusUrlCommerce(bool newStatus) {
    _statusUrl = newStatus; 
    notifyListeners(); 
  }

  String _nameClient;
  String get nameClient =>_nameClient; 
  
  set nameClient(String newName) {
    _nameClient = newName; 
    notifyListeners(); 
  }

  String _initialsClient;
  String get initialsClient =>_initialsClient; 
  
  set initialsClient(String newValue) {
    _initialsClient = newValue; 
    notifyListeners(); 
  }

  List<int> _avatarClient;
  List<int> get avatarClient =>_avatarClient; 
  
  set avatarClient(List<int> newAvatar) {
    _avatarClient = newAvatar; 
    notifyListeners(); 
  }

  double _totalSales;
  double get totalSales =>_totalSales; 
  
  set totalSales(double newTotalSales) {
    _totalSales = newTotalSales; 
    notifyListeners(); 
  }

  List _reportSales  = new List();
  List get dataReportSales =>_reportSales ;

  set dataReportSales(List newReport){
    _reportSales  = newReport;
    notifyListeners();
  }

  List _paid = new List();
  List get dataPaids =>_paid;

  set dataPaids(List newPaid){
    _paid = newPaid;
    notifyListeners();
  }

  Paid _selectPaid = Paid();
  Paid get selectPaid =>_selectPaid; 
  
  set selectPaid(Paid newItem) {
    _selectPaid = newItem; 
    notifyListeners(); 
  }
  

  List _balance = new List();
  List get dataBalances =>_balance;

  set dataBalances(List newBalance){
    _balance = newBalance;
    notifyListeners();
  }

  User user = User();
  List banksUser = new List(2);
  Bank bankUserUSD = Bank();
  Bank bankUserBs = Bank();
  Picture pictureUser = Picture();
  List listPicturesUser = new List();
  List listCommerces = new List();

  getDataUser(status, loading, context)async{

    var result, response, jsonResponse;
    listPicturesUser = [];
    listCommerces = [];

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
          await dbctpaga.deleteAll();
          await Future.delayed(Duration(milliseconds: 1000));
          user = User(
            id: jsonResponse['data']['0']['id'],
            email: jsonResponse['data']['0']['email'],
            name: jsonResponse['data']['0']['name'],
            address: jsonResponse['data']['0']['address'],
            phone: jsonResponse['data']['0']['phone'],
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
                banksUser[0] = bankUserUSD;

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
                banksUser[1] = bankUserBs;
              }
            }
          }
          
          dataBanksUser = banksUser;

          if(jsonResponse['data']['pictures'] != null){
            for (var item in jsonResponse['data']['pictures']) {
              pictureUser = Picture(
                id: item['id'],
                description: item['description'],
                url: item['url'],
                commerce_id: item['commerce_id'] == null? 0 : item['commerce_id'],
              );
              
              dbctpaga.createOrUpdatePicturesUser(pictureUser);
              listPicturesUser.add(pictureUser);
            }
          }

          dataPicturesUser = listPicturesUser;

          if(jsonResponse['data']['commerces'] != null){
            for (var item in jsonResponse['data']['commerces']) {
                Commerce commercesUser = Commerce(
                  id: item['id'],
                  rif: item['rif'] == null? '' : item['rif'],
                  name: item['name'] == null? '' : item['name'],
                  address: item['address'] == null? '' : item['address'],
                  phone: item['phone'] == null? '' : item['phone'],
                  userUrl: item['userUrl'] == null? '' : item['userUrl'],
                ); 

                dbctpaga.createOrUpdateCommercesUser(commercesUser);
                listCommerces.add(commercesUser);
            }

            dataCommercesUser = listCommerces;

            statusUrlCommerce = false;
            if(listCommerces.length != 0){
              if (dataCommercesUser[selectCommerce].userUrl != '')
                statusUrlCommerce = true;
              
              verifyStatusDeposits();
              getListCategories();
              getListProducts();
              getListServices();
              getListShipping();
              getListPaids();
              getListBalances();
            }

          }

          statusDolar = false;
          statusBs = false;
          getListDiscounts();
          getListRates();
          await Future.delayed(Duration(seconds: 3));

          if(loading){
            Navigator.pop(context);
          }

          if(status){
            Navigator.pushReplacement(context, SlideLeftRoute(page: MainMenuBar()));
          }
        }else{
          removeSession(context, true);
        }
      }
    } on SocketException catch (_) {
      if(accessTokenUser != null){
        dataUser = await dbctpaga.getUser();
        dataBanksUser = await dbctpaga.getBanksUser();
        dataPicturesUser = await dbctpaga.getPicturesUser();
        dataCommercesUser = await dbctpaga.getCommercesUser();
        dataCategories = await dbctpaga.getCategories(selectProductsServices);
        verifyStatusDeposits();
        dataBalances = await dbctpaga.getBalances();
        dataProducts = await dbctpaga.getProducts();
        dataServices = await dbctpaga.getServices();
        dataShipping = await dbctpaga.getShipping();
        dataDiscount = await dbctpaga.getDiscounts();
        dataRates = await dbctpaga.getRates();
        getRatesDate();
        dataPaids = await dbctpaga.getPaids();
      }

      if(status){
        Navigator.pushReplacement(context, SlideLeftRoute(page: MainMenuBar()));
      }
    }
  }

  verifyStatusDeposits(){
    _listVerification = [];

    if(selectCoinDeposits == null)
      selectCoinDeposits = 1;

    if (dataBanksUser[selectCoinDeposits] != null ){
      _listVerification.add("Bank");
    }

    for (var item in dataPicturesUser) {
      if(item.description == 'Identification' && item.commerce_id == dataCommercesUser[selectCommerce].id){
        _listVerification.add("Identification");
      }else if(item.description == 'Selfie'){
          _listVerification.add("Selfie");
      }else if(item.description == 'RIF' && item.commerce_id == dataCommercesUser[selectCommerce].id){
        _listVerification.add("RIF"); 
      }
    }

    listVerification = _listVerification;
  }

  Categories category = Categories();
  List _listCategories = new List();

  getListCategories()async{
    var result, response, jsonResponse;
    _listCategories = [];
    try
    {
      result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        response = await http.post(
          urlApi+"showCategories",
          headers:{
            'Content-Type': 'application/json',
            'X-Requested-With': 'XMLHttpRequest',
            'authorization': 'Bearer $accessTokenUser',
          },
          body: jsonEncode({
            "commerce_id": dataCommercesUser[selectCommerce].id.toString(),
          }),
        ); 

        jsonResponse = jsonDecode(response.body);
        print(jsonResponse);
        if (jsonResponse['statusCode'] == 201) {
          for (var item in jsonResponse['data']) {
            if(selectProductsServices == item['type']){
              category = Categories(
                id: item['id'],
                name: item['name'],
                commerce_id: item['commerce_id'],
                type: item['type'],
              );

              _listCategories.add(category);
              dbctpaga.createOrUpdateCategories(category);
            }
          }
          dataCategories = _listCategories;
        } 
      }
    } on SocketException catch (_) {
      if(accessTokenUser != null){
        dataCategories = await dbctpaga.getCategories(selectProductsServices);
      }
    }
  }

  Product product = Product();
  List _listProducts = new List();

  getListProducts()async{
    var result, response, jsonResponse;
    _listProducts = [];
    try
    {
      result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        response = await http.post(
          urlApi+"showProducts",
          headers:{
            'Content-Type': 'application/json',
            'X-Requested-With': 'XMLHttpRequest',
            'authorization': 'Bearer $accessTokenUser',
          },
          body: jsonEncode({
            "commerce_id": dataCommercesUser[selectCommerce].id.toString(),
          }),
        ); 
        jsonResponse = jsonDecode(response.body);
        print(jsonResponse);
        if (jsonResponse['statusCode'] == 201) {
          for (var item in jsonResponse['data']) {
            product = Product(
              id: item['id'],
              commerce_id : item['commerce_id'],
              url : item['url'],
              name : item['name'],
              price : item['price'],
              coin : item['coin'],
              description : item['description'],
              categories : item['categories'],
              publish : item['publish'],
              stock : item['stock'],
              postPurchase : item['postPurchase'] == null? '' : item['postPurchase'],
            );
            _listProducts.add(product);
            dbctpaga.createOrUpdateProducts(product);

            if(item['coin'] == 0)
              statusDolar = true;
            else if(item['coin'] == 1)
              statusBs = true;

          } 
          dataProducts = _listProducts;
        } 
      }
    } on SocketException catch (_) {
      if(accessTokenUser != null){
        dataProducts = await dbctpaga.getProducts();
      }

    }
  }

  Service service = Service();
  List _listService = new List();

  getListServices()async{
    var result, response, jsonResponse;
    _listService = [];
    try
    {
      result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        response = await http.post(
          urlApi+"showServices",
          headers:{
            'Content-Type': 'application/json',
            'X-Requested-With': 'XMLHttpRequest',
            'authorization': 'Bearer $accessTokenUser',
          },
          body: jsonEncode({
            "commerce_id": dataCommercesUser[selectCommerce].id.toString(),
          }),
        ); 

        jsonResponse = jsonDecode(response.body);
        print(jsonResponse);
        if (jsonResponse['statusCode'] == 201) {
          for (var item in jsonResponse['data']) {
            service = Service(
              id: item['id'],
              commerce_id : item['commerce_id'],
              url : item['url'],
              name : item['name'],
              price : item['price'],
              coin : item['coin'],
              description : item['description'],
              categories : item['categories'],
              publish : item['publish'],
              postPurchase : item['postPurchase'] == null? '' : item['postPurchase'],
            );
            _listService.add(service);
            dbctpaga.createOrUpdateServices(service);

            if(item['coin'] == 0)
              statusDolar = true;
            else if(item['coin'] == 1)
              statusBs = true;
          }
          dataServices = _listService;
        } 
      }
    } on SocketException catch (_) {
      if(accessTokenUser != null){
        dataServices = await dbctpaga.getServices();
      }

    }
  }

  Shipping shipping = Shipping();
  List _listShipping = new List();

  getListShipping()async{
    var result, response, jsonResponse;
    _listShipping = [];
    try
    {
      result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        response = await http.post(
          urlApi+"showShipping",
          headers:{
            'Content-Type': 'application/json',
            'X-Requested-With': 'XMLHttpRequest',
            'authorization': 'Bearer $accessTokenUser',
          },
        ); 

        jsonResponse = jsonDecode(response.body);
        print(jsonResponse);
        if (jsonResponse['statusCode'] == 201) {
          for (var item in jsonResponse['data']) {
            shipping = Shipping(
              id: item['id'],
              price : item['price'],
              coin : item['coin'],
              description : item['description'],
            );
            _listShipping.add(shipping);
            dbctpaga.createOrUpdateShipping(shipping);
          }
          dataShipping = _listShipping;
        } 
      }
    } on SocketException catch (_) {
      if(accessTokenUser != null){
        dataShipping = await dbctpaga.getShipping();
      }

    }
  }

  Discounts discounts = Discounts();
  List _listDiscounts = new List();

  getListDiscounts()async{
    var result, response, jsonResponse;
    _listDiscounts = [];
    try
    {
      result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        response = await http.post(
          urlApi+"showDiscounts",
          headers:{
            'Content-Type': 'application/json',
            'X-Requested-With': 'XMLHttpRequest',
            'authorization': 'Bearer $accessTokenUser',
          },
        ); 

        jsonResponse = jsonDecode(response.body);
        print(jsonResponse);
        if (jsonResponse['statusCode'] == 201) {
          for (var item in jsonResponse['data']) {
            discounts = Discounts(
              id: item['id'],
              code : item['code'],
              percentage : item['percentage'],
            );
            _listDiscounts.add(discounts);
            dbctpaga.createOrUpdateDiscounts(discounts);
          }
          dataDiscount = _listDiscounts;
        } 
      }
    } on SocketException catch (_) {
      if(accessTokenUser != null){
        dataDiscount = await dbctpaga.getDiscounts();
      }

    }
  }

  Rate rate = Rate();
  List _listRates = new List();
  List _listRatesToday = new List();
  List _listRatesWeek = new List();
  List _listRatesMonth = new List();

  getListRates()async{
    List<String> weekDay = <String> ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    var formatterDay = new DateFormat('EEEE');
    DateTime _dateNow = DateTime.now(), _today, _firstDay, _lastDay;
    var result, response, jsonResponse;
    _listRates = [];
    _listRatesToday = [];
    _listRatesWeek = [];
    _listRatesMonth = [];
    dataRatesSelectToday = null;
    dataRatesSelectMonth = null;
    dataRatesSelectWeek = null;

    _today = DateTime(_dateNow.year, _dateNow.month, _dateNow.day);
    int indexWeekDay =  weekDay.indexOf(formatterDay.format(_dateNow));
    _firstDay = DateTime(_dateNow.year, _dateNow.month, _dateNow.day-indexWeekDay);
    _lastDay = DateTime(_dateNow.year, _dateNow.month, _dateNow.day+(6-indexWeekDay));
    

    try
    {
      result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        response = await http.post(
          urlApi+"showRates",
          headers:{
            'Content-Type': 'application/json',
            'X-Requested-With': 'XMLHttpRequest',
            'authorization': 'Bearer $accessTokenUser',
          },
        ); 

        jsonResponse = jsonDecode(response.body);
        print(jsonResponse);
        if (jsonResponse['statusCode'] == 201) {
          for (var item in jsonResponse['data']) {
            rate = Rate(
              id: item['id'],
              rate: item['rate'],
              date: item['date'],
            );

            DateTime dateRate = DateTime.parse(item['date']);

            if(dateRate.day == _today.day && dateRate.month == _today.month && dateRate.year == _today.year){
              _listRatesToday.add(rate);
            }

            if(_firstDay.isBefore(dateRate) && _lastDay.isAfter(dateRate)){
              _listRatesWeek.add(rate);
            }

            if(dateRate.month == _today.month){
              _listRatesMonth.add(rate);
            }

            _listRates.add(rate);
            dbctpaga.createRates(rate);
          }
          dataRates = _listRates;
          dataRatesSelectToday = _listRatesToday;
          dataRatesSelectWeek = _listRatesWeek;
          dataRatesSelectMonth = _listRatesMonth;
        } 
      }
    } on SocketException catch (_) {
      if(accessTokenUser != null){
        dataRates = await dbctpaga.getRates();
      }
    }
  }

  getRatesDate(){
    List<String> weekDay = <String> ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    var formatterDay = new DateFormat('EEEE');
    DateTime _dateNow = DateTime.now(), _today, _firstDay, _lastDay;
    _listRates = [];
    _listRatesToday = [];
    _listRatesWeek = [];
    _listRatesMonth = [];
    dataRatesSelectToday = null;
    dataRatesSelectMonth = null;
    dataRatesSelectWeek = null;
    _today = DateTime(_dateNow.year, _dateNow.month, _dateNow.day);
    int indexWeekDay =  weekDay.indexOf(formatterDay.format(_dateNow));
    _firstDay = DateTime(_dateNow.year, _dateNow.month, _dateNow.day-indexWeekDay);
    _lastDay = DateTime(_dateNow.year, _dateNow.month, _dateNow.day+(6-indexWeekDay));

    for (var item in dataRates) {
      rate = Rate(
        id: item.id,
        rate: item.rate,
        date: item.date,
      );

      DateTime dateRate = DateTime.parse(item.date);

      if(dateRate.day == _today.day && dateRate.month == _today.month && dateRate.year == _today.year){
        _listRatesToday.add(rate);
      }

      if(_firstDay.isBefore(dateRate) && _lastDay.isAfter(dateRate)){
        _listRatesWeek.add(rate);
      }

      if(dateRate.month == _today.month){
        _listRatesMonth.add(rate);
      }

    }
      dataRatesSelectToday = _listRatesToday;
      dataRatesSelectWeek = _listRatesWeek;
      dataRatesSelectMonth = _listRatesMonth;
  }


  Paid paids = Paid();
  List _listPaids = new List();

  getListPaids()async{
    var result, response, jsonResponse;
    _listPaids = [];
    try
    {
      result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        response = await http.post(
          urlApi+"showPaids",
          headers:{
            'Content-Type': 'application/json',
            'X-Requested-With': 'XMLHttpRequest',
            'authorization': 'Bearer $accessTokenUser',
          },
          body: jsonEncode({
            "commerce_id": dataCommercesUser[selectCommerce].id.toString(),
          }),
        ); 

        jsonResponse = jsonDecode(response.body);
        print(jsonResponse);
        if (jsonResponse['statusCode'] == 201) {
          for (var item in jsonResponse['data']) {
            paids = Paid(
              id: item['id'],
              user_id: item['user_id'],
              commerce_id: item['commerce_id'],
              codeUrl: item['codeUrl'],
              nameClient: item['nameClient'],
              total: item['total'],
              coin: item['coin'],
              email: item['email'],
              nameShipping: item['nameShipping']== null? '' : item['nameShipping'],
              numberShipping: item['numberShipping']== null? '' : item['numberShipping'],
              addressShipping: item['addressShipping']== null? '' : item['addressShipping'],
              detailsShipping: item['detailsShipping']== null? '' : item['detailsShipping'],
              selectShipping: item['selectShipping']== null? '' : item['selectShipping'],
              priceShipping: item['priceShipping']== null? '0' : item['priceShipping'],
              statusShipping: item['statusShipping'],
              percentage: item['percentage'],
              nameCompanyPayments: item['nameCompanyPayments'],
              date: item['date'],
            );
            _listPaids.add(paids);
            dbctpaga.createOrUpdatePaid(paids);
          }
          dataPaids = _listPaids;
        } 
      }
    } on SocketException catch (_) {
      if(accessTokenUser != null){
        dataPaids = await dbctpaga.getPaids();
      }

    }
  }

  Balance balance = Balance();
  List _listBalances = new List();

  getListBalances()async{
    var result, response, jsonResponse;
    _listBalances = [];
    try
    {
      result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        response = await http.post(
          urlApi+"showBalances",
          headers:{
            'Content-Type': 'application/json',
            'X-Requested-With': 'XMLHttpRequest',
            'authorization': 'Bearer $accessTokenUser',
          },
          body: jsonEncode({
            "commerce_id": dataCommercesUser[selectCommerce].id.toString(),
          }),
        ); 

        jsonResponse = jsonDecode(response.body);
        print(jsonResponse);
        if (jsonResponse['statusCode'] == 201) {
          for (var item in jsonResponse['data']) {
            balance = Balance(
              id: item['id'],
              user_id: item['user_id'],
              commerce_id: item['commerce_id'],
              coin: item['coin'],
              total: item['total'],
            );
            _listBalances.add(balance);
            dbctpaga.createOrUpdateBalance(balance);
          }
          dataBalances = _listBalances;
        } 
      }
    } on SocketException catch (_) {
      dataBalances = await dbctpaga.getBalances();
    }
  }


  removeSession(BuildContext context, status)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("access_token");
    prefs.remove('selectCommerce');
    prefs.remove('statusShipping');
    prefs.remove('descriptionShipping');
    accessTokenUser = null;
    dataUser = null;
    dataBanksUser = [];
    dataPicturesUser = [];
    dataCategoriesSelect=[];
    dataCategories = [];
    dataProducts = [];
    dataServices = [];
    dataProductsServicesCategories = [];
    dbctpaga.deleteAll();
    dataPurchase = [];

    if(status)
      Navigator.pushReplacement(context, SlideLeftRoute(page: LoginPage()));
  }

}