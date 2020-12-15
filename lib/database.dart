import 'package:ctpaga/models/categories.dart';
import 'package:ctpaga/models/discounts.dart';
import 'package:ctpaga/models/commerce.dart';
import 'package:ctpaga/models/shipping.dart';
import 'package:ctpaga/models/picture.dart';
import 'package:ctpaga/models/product.dart';
import 'package:ctpaga/models/service.dart';
import 'package:ctpaga/models/Balance.dart';
import 'package:ctpaga/models/paid.dart';
import 'package:ctpaga/models/rate.dart';
import 'package:ctpaga/models/bank.dart';
import 'package:ctpaga/models/user.dart';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io'as io;
import 'dart:async';


class DBctpaga{

  static Database dbInstance;
  static int versionDB = 10;

  Future<Database> get db async{
    if(dbInstance == null)
      dbInstance = await initDB();

    return dbInstance;
  }

  initDB() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "ctpaga.db");

    var db = await openDatabase(path, version: versionDB, 
      onCreate: onCreateFunc,
      onUpgrade: (db, oldVersion, newVersion) async {
          if (oldVersion != newVersion) {
            onCreateFunc(db, newVersion);
          }
        },
    );

    return db;
  }


  void onCreateFunc (Database db, int version) async{
    //create table
    await db.execute('CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY AUTOINCREMENT, email Text, name VARCHAR(100), address Text, phone VARCHAR(20) )');
    await db.execute('CREATE TABLE IF NOT EXISTS banks (id INTEGER PRIMARY KEY AUTOINCREMENT, coin VARCHAR(3), country VARCHAR(10), accountName VARCHAR(100), accountNumber VARCHAR(50), idCard VARCHAR(50), route VARCHAR(9), swift VARCHAR(20), address Text, bankName VARCHAR(100), accountType VARCHAR(1))');
    await db.execute('CREATE TABLE IF NOT EXISTS pictures (id INTEGER PRIMARY KEY AUTOINCREMENT, description VARCHAR(30), url Text, commerce_id INTEGER )');
    await db.execute('CREATE TABLE IF NOT EXISTS commerces (id INTEGER PRIMARY KEY AUTOINCREMENT, rif VARCHAR(15), name Text, address Text, phone VARCHAR(20), userUrl VARCHAR(20))');
    await db.execute('CREATE TABLE IF NOT EXISTS categories (id INTEGER, name VARCHAR(50), commerce_id INTEGER, type INTEGER)');
    await db.execute('CREATE TABLE IF NOT EXISTS products (id INTEGER, commerce_id INTEGER, url text, name Text, price VARCHAR(50), coin INTEGER, description text, categories VARCHAR(50), publish INTEGER, stock INTEGER, postPurchase text)');
    await db.execute('CREATE TABLE IF NOT EXISTS services (id INTEGER, commerce_id INTEGER, url text, name Text, price VARCHAR(50), coin INTEGER, description text, categories VARCHAR(50), publish INTEGER, postPurchase text)');
    await db.execute('CREATE TABLE IF NOT EXISTS shipping (id INTEGER, price VARCHAR(50), coin INTEGER, description text)');
    await db.execute('CREATE TABLE IF NOT EXISTS discounts (id INTEGER, code VARCHAR(50), percentage INTEGER)');
    await db.execute('CREATE TABLE IF NOT EXISTS rates (id INTEGER, rate VARCHAR(50), created_at VARCHAR(50))');
    await db.execute('CREATE TABLE IF NOT EXISTS paids (id INTEGER, user_id INTEGER, commerce_id INTEGER, codeUrl VARCHAR(10), nameClient VARCHAR(50), total text, coin INTEGER, email text, nameShipping VARCHAR(50), numberShipping VARCHAR(50), addressShipping text, detailsShipping text, selectShipping text, priceShipping text, statusShipping, totalShipping text, percentage INTEGER, nameCompanyPayments VARCHAR(10), date text)');
    await db.execute('CREATE TABLE IF NOT EXISTS balances (id INTEGER, user_id INTEGER, commerce_id INTEGER, coin INTENGER, total text)');
  }

  /*
    CRUD FUNCTION
  */

   // Delete service
  Future deleteAll() async{
    var dbConnection = await db;
    await dbConnection.execute('DROP TABLE IF EXISTS users');
    await dbConnection.execute('DROP TABLE IF EXISTS banks');
    await dbConnection.execute('DROP TABLE IF EXISTS pictures');
    await dbConnection.execute('DROP TABLE IF EXISTS commerces');
    await dbConnection.execute('DROP TABLE IF EXISTS categories');
    await dbConnection.execute('DROP TABLE IF EXISTS products');
    await dbConnection.execute('DROP TABLE IF EXISTS services');
    await dbConnection.execute('DROP TABLE IF EXISTS shipping');
    await dbConnection.execute('DROP TABLE IF EXISTS discounts');
    await dbConnection.execute('DROP TABLE IF EXISTS rates');
    await dbConnection.execute('DROP TABLE IF EXISTS paids');
  
    onCreateFunc(dbConnection, versionDB);

  }

  // Get User
  Future <User> getUser() async{
    var dbConnection = await db;

    List<Map> list = await dbConnection.rawQuery('SELECT * FROM users WHERE id = 1');
    User user = new User();

    for(int i = 0; i< list.length; i++)
    {
      user = User(
        id : list[i]['id'],
        email : list[i]['email'],
        name : list[i]['name'],
        address : list[i]['address'],
        phone : list[i]['phone'],
      );

    }

    return user;
  }

  existUser() async{
    var dbConnection = await db;

    List<Map> list = await dbConnection.rawQuery('SELECT * FROM users WHERE id = 1');
    
    return (list.length);
  }

  // Add New User
  void addNewUser (User user) async{
    var dbConnection = await db;
    String query = 'INSERT INTO users (email , name, address, phone) VALUES (\'${user.email}\',\'${user.name}\',\'${user.address}\',\'${user.phone}\')';
    await dbConnection.transaction((transaction) async{
      return await transaction.rawInsert(query);
    });
  }

  // Update User
  void updateUser (User user) async{
    var dbConnection = await db;
    String query = 'UPDATE users SET email=\'${user.email}\', name=\'${user.name}\', address=\'${user.address}\', phone=\'${user.phone}\' WHERE id=1';
    await dbConnection.transaction((transaction) async{
      return await transaction.rawQuery(query);
    });
  }

  // Delete User
  void deleteUser (User user) async{
    var dbConnection = await db;
    String query = 'DELETE FROM users WHERE idUsers=${user.id}';
    await dbConnection.transaction((transaction) async{
      return await transaction.rawQuery(query);
    });
  }

  // Get Banks User
  Future <List<dynamic>> getBanksUser() async{
    var dbConnection = await db;

    List<Map> list = await dbConnection.rawQuery('SELECT * FROM banks');

    List bankUser = new List(2);
    Bank bankUserUSD = Bank();
    Bank bankUserBs = Bank();

    for(int i = 0; i< list.length; i++)
    {
      if(list[i]['coin'] == 'USD'){
        bankUserUSD = Bank(
          coin : list[i]['coin'],
          country : list[i]['country'],
          accountName : list[i]['accountName'],
          accountNumber : list[i]['accountNumber'],
          route : list[i]['route'],
          swift :  list[i]['swift'],
          address : list[i]['address'],
          bankName : list[i]['bankName'],
          accountType : list[i]['accountType'],
        );
        bankUser[0] = bankUserUSD;
      }else{
        bankUserBs = Bank(
          coin : list[i]['coin'],
          accountName : list[i]['accountName'],
          accountNumber : list[i]['accountNumber'],
          idCard : list[i]['idCard'],
          bankName : list[i]['bankName'],
          accountType : list[i]['accountType'],
        );
        bankUser[1] = bankUserBs;
      }
      
    }

    return bankUser;
  }

  // Create or update banks
  void createOrUpdateBankUser (Bank bank) async{
    var dbConnection = await db;

    String query = 'INSERT OR REPLACE INTO banks (id, coin , country , accountName , accountNumber , idCard , route , swift , address , bankName , accountType) VALUES ( (SELECT id  FROM banks WHERE coin = \'${bank.coin}\'), \'${bank.coin}\',\'${bank.country}\',\'${bank.accountName}\',\'${bank.accountNumber}\',\'${bank.idCard}\',\'${bank.route}\',\'${bank.swift}\',\'${bank.address}\',\'${bank.bankName}\',\'${bank.accountType}\')';
    await dbConnection.transaction((transaction) async{
      return await transaction.rawInsert(query);
    });
  }

  // Get pictures User
  Future <List<dynamic>> getPicturesUser() async{
    List listPicturesUser = new List();
    listPicturesUser = [];
    var dbConnection = await db;

    List<Map> list = await dbConnection.rawQuery('SELECT * FROM pictures');
    Picture pictureUser = new Picture();

    for(int i = 0; i< list.length; i++)
    {
      pictureUser = Picture(
        id : list[i]['id'],
        description : list[i]['description'],
        url : list[i]['url'],
        commerce_id: list[i]['commerce_id'],
      );

      listPicturesUser.add(pictureUser);

    }

    return listPicturesUser;
  }

  // Create or update pictures
  void createOrUpdatePicturesUser (Picture picture) async{
    var dbConnection = await db;

    String query = 'INSERT OR REPLACE INTO pictures (id, description, url, commerce_id) VALUES ( (SELECT id FROM pictures WHERE description = \'${picture.description}\'), \'${picture.description}\',\'${picture.url}\',\'${picture.commerce_id}\')';
    await dbConnection.transaction((transaction) async{
      return await transaction.rawInsert(query);
    });
  }


  // Get Commerces User
  Future <List<dynamic>> getCommercesUser() async{
    List listCommercesUser = new List();
    listCommercesUser = [];
    var dbConnection = await db;

    List<Map> list = await dbConnection.rawQuery('SELECT * FROM commerces');
    Commerce commerceUser = new Commerce();

    for(int i = 0; i< list.length; i++)
    {
      commerceUser = Commerce(
        id : list[i]['id'],
        rif : list[i]['rif'],
        name : list[i]['name'],
        address : list[i]['address'],
        phone : list[i]['phone'],
        userUrl : list[i]['userUrl'],
      );

      listCommercesUser.add(commerceUser);

    }

    return listCommercesUser;
  }

  // Create or update commerces
  void createOrUpdateCommercesUser (Commerce commerce) async{
    var dbConnection = await db;

    String query = 'INSERT OR REPLACE INTO commerces (id, rif, name, address, phone, userUrl) VALUES ( (SELECT id FROM commerces WHERE rif = \'${commerce.rif}\'), \'${commerce.rif}\', \'${commerce.name}\',\'${commerce.address}\',\'${commerce.phone}\',\'${commerce.userUrl}\')';
    await dbConnection.transaction((transaction) async{
      return await transaction.rawInsert(query);
    });
  }

  // Get Categories User
  Future <List<dynamic>> getCategories(type) async{
    List listCategories = new List();
    listCategories = [];
    var dbConnection = await db;

    List<Map> list = await dbConnection.rawQuery('SELECT * FROM categories WHERE type = \'$type\'');
    Categories categories = new Categories();

    for(int i = 0; i< list.length; i++)
    {
      categories = Categories(
        id : list[i]['id'],
        commerce_id : list[i]['commerce_id'],
        name : list[i]['name'],
        type : list[i]['type'],
      );

      listCategories.add(categories);

    }

    return listCategories;
  }

  // Create or update Categories
  void createOrUpdateCategories (Categories categories) async{
    var dbConnection = await db;

    List<Map> list = await dbConnection.rawQuery('SELECT * FROM categories WHERE id = \'${categories.id}\' ');

    if(list.length == 0){
      String query = 'INSERT INTO categories (id, commerce_id, name, type) VALUES ( \'${categories.id}\', \'${categories.commerce_id}\', \'${categories.name}\',\'${categories.type}\')';
      await dbConnection.transaction((transaction) async{
        return await transaction.rawInsert(query);
      });
    }else{
      String query = 'UPDATE categories SET commerce_id=\'${categories.commerce_id}\', name=\'${categories.name}\', type=\'${categories.type}\' WHERE id= \'${categories.id}\'';
      await dbConnection.transaction((transaction) async{
        return await transaction.rawInsert(query);
      });
    }
  }


  // Get Products User
  Future <List<dynamic>> getProducts() async{
    List listProducts = new List();
    listProducts = [];
    var dbConnection = await db;

    List<Map> list = await dbConnection.rawQuery('SELECT * FROM products');
    Product productUser = new Product();

    for(int i = 0; i< list.length; i++)
    {
      productUser = Product(
        id : list[i]['id'],
        commerce_id : list[i]['commerce_id'],
        url : list[i]['url'],
        name : list[i]['name'],
        price : list[i]['price'],
        coin : list[i]['coin'],
        description : list[i]['description'],
        categories : list[i]['categories'],
        publish : list[i]['publish'] == 1 ? true : false,
        stock : list[i]['stock'],
        postPurchase : list[i]['postPurchase'],
      );

      listProducts.add(productUser);

    }

    return listProducts;
  }

  // Create or update Products
  void createOrUpdateProducts (Product product) async{
    var dbConnection = await db;

    List<Map> list = await dbConnection.rawQuery('SELECT * FROM products WHERE id = \'${product.id}\' ');
    
    if(list.length == 0){
      String query = 'INSERT INTO products (id, commerce_id, url, name, price, coin, description, categories, publish, stock, postPurchase) VALUES ( \'${product.id}\', \'${product.commerce_id}\', \'${product.url}\',\'${product.name}\',\'${product.price}\',\'${product.coin}\',\'${product.description}\',\'${product.categories}\',\'${product.publish?1:0}\',\'${product.stock}\',\'${product.postPurchase}\')';
      await dbConnection.transaction((transaction) async{
        return await transaction.rawInsert(query);
    });
    }else{
      String query = 'UPDATE products SET commerce_id=\'${product.commerce_id}\', url=\'${product.url}\', name=\'${product.name}\', price=\'${product.price}\', coin=\'${product.coin}\', description=\'${product.description}\', categories=\'${product.categories}\', publish=\'${product.publish?1:0}\', stock=\'${product.stock}\', postPurchase=\'${product.postPurchase}\' WHERE id= \'${product.id}\'';
      await dbConnection.transaction((transaction) async{
        return await transaction.rawInsert(query);
      });
    }
  }

  // Delete product
  void deleteProduct (int id) async{
    var dbConnection = await db;
    String query = 'DELETE FROM products WHERE id=$id';
    await dbConnection.transaction((transaction) async{
      return await transaction.rawQuery(query);
    });
  }

  // Get Services User
  Future <List<dynamic>> getServices() async{
    List listServices = new List();
    listServices = [];
    var dbConnection = await db;

    List<Map> list = await dbConnection.rawQuery('SELECT * FROM services');
    Service serviceUser = new Service();

    for(int i = 0; i< list.length; i++)
    {
      serviceUser = Service(
        id : list[i]['id'],
        commerce_id : list[i]['commerce_id'],
        url : list[i]['url'],
        name : list[i]['name'],
        price : list[i]['price'],
        coin : list[i]['coin'],
        description : list[i]['description'],
        categories : list[i]['categories'],
        publish : list[i]['publish'] == 1 ? true : false,
        postPurchase : list[i]['postPurchase'],
      );

      listServices.add(serviceUser);

    }

    return listServices;
  }

  // Create or update Services
  void createOrUpdateServices (Service service) async{
    var dbConnection = await db;

    List<Map> list = await dbConnection.rawQuery('SELECT * FROM services WHERE id = \'${service.id}\' ');
    
    if(list.length == 0){
      String query = 'INSERT INTO services (id, commerce_id, url, name, price, coin, description, categories, publish, postPurchase) VALUES ( \'${service.id}\', \'${service.commerce_id}\', \'${service.url}\',\'${service.name}\',\'${service.price}\',\'${service.coin}\',\'${service.description}\',\'${service.categories}\',\'${service.publish?1:0}\',\'${service.postPurchase}\')';
      await dbConnection.transaction((transaction) async{
        return await transaction.rawInsert(query);
    });
    }else{
      String query = 'UPDATE services SET commerce_id=\'${service.commerce_id}\', url=\'${service.url}\', name=\'${service.name}\', price=\'${service.price}\', coin=\'${service.coin}\', description=\'${service.description}\', categories=\'${service.categories}\', publish=\'${service.publish?1:0}\', postPurchase=\'${service.postPurchase}\' WHERE id= \'${service.id}\'';
      await dbConnection.transaction((transaction) async{
        return await transaction.rawInsert(query);
      });
    }
  }

  // Delete service
  void deleteService (int id) async{
    var dbConnection = await db;
    String query = 'DELETE FROM services WHERE id=$id';
    await dbConnection.transaction((transaction) async{
      return await transaction.rawQuery(query);
    });
  }

  // Get Shipping User
  Future <List<dynamic>> getShipping() async{
    List listShipping = new List();
    listShipping = [];
    var dbConnection = await db;

    List<Map> list = await dbConnection.rawQuery('SELECT * FROM shipping');
    Shipping shipping = new Shipping();

    for(int i = 0; i< list.length; i++)
    {
      shipping = Shipping(
        id : list[i]['id'],
        price : list[i]['price'],
        coin : list[i]['coin'],
        description : list[i]['description'],

      );

      listShipping.add(shipping);

    }

    return listShipping;
  }

  // Create or update Shipping
  void createOrUpdateShipping (Shipping shipping) async{
    var dbConnection = await db;

    List<Map> list = await dbConnection.rawQuery('SELECT * FROM shipping WHERE id = \'${shipping.id}\' ');
    
    if(list.length == 0){
      String query = 'INSERT INTO shipping (id, price, coin, description) VALUES ( \'${shipping.id}\', \'${shipping.price}\',\'${shipping.coin}\',\'${shipping.description}\')';
      await dbConnection.transaction((transaction) async{
        return await transaction.rawInsert(query);
    });
    }else{
      String query = 'UPDATE shipping SET price=\'${shipping.price}\', coin=\'${shipping.coin}\', description=\'${shipping.description}\' WHERE id= \'${shipping.id}\'';
      await dbConnection.transaction((transaction) async{
        return await transaction.rawInsert(query);
      });
    }
  }

  // Delete Shipping
  void deleteShipping(int id) async{
    var dbConnection = await db;
    String query = 'DELETE FROM shipping WHERE id=$id';
    await dbConnection.transaction((transaction) async{
      return await transaction.rawQuery(query);
    });
  }


  // Get Discount User
  Future <List<dynamic>> getDiscounts() async{
    List listDiscounts = new List();
    listDiscounts = [];
    var dbConnection = await db;

    List<Map> list = await dbConnection.rawQuery('SELECT * FROM discounts');
    Discounts discounts = new Discounts();

    for(int i = 0; i< list.length; i++)
    {
      discounts = Discounts(
        id : list[i]['id'],
        code : list[i]['code'],
        percentage : list[i]['percentage'],

      );

      listDiscounts.add(discounts);

    }

    return listDiscounts;
  }

  // Create or update Discounts
  void createOrUpdateDiscounts (Discounts discounts) async{
    var dbConnection = await db;

    List<Map> list = await dbConnection.rawQuery('SELECT * FROM discounts WHERE id = \'${discounts.id}\' ');
    
    if(list.length == 0){
      String query = 'INSERT INTO discounts (id, code, percentage) VALUES ( \'${discounts.id}\', \'${discounts.code}\',\'${discounts.percentage}\')';
      await dbConnection.transaction((transaction) async{
        return await transaction.rawInsert(query);
    });
    }else{
      String query = 'UPDATE discounts SET code=\'${discounts.code}\', percentage=\'${discounts.percentage}\' WHERE id= \'${discounts.id}\'';
      await dbConnection.transaction((transaction) async{
        return await transaction.rawInsert(query);
      });
    }
  }

  // Delete Discounts
  void deleteDiscounts(int id) async{
    var dbConnection = await db;
    String query = 'DELETE FROM discounts WHERE id=$id';
    await dbConnection.transaction((transaction) async{
      return await transaction.rawQuery(query);
    });
  }

  // Get Rate
  Future <List<dynamic>> getRates() async{
    List<Rate> listRates = new List();
    listRates = [];
    var dbConnection = await db;

    List<Map> list = await dbConnection.rawQuery('SELECT * FROM rates');
    Rate rate = new Rate();

    for(int i = 0; i< list.length; i++)
    {
      rate = Rate(
        id : list[i]['id'],
        rate : list[i]['rate'],
        date : list[i]['created_at'],
      );

      listRates.add(rate);

    }

    return listRates;
  }

  // Create Rate
  void createRates(Rate rate) async{
    var dbConnection = await db;
    String query = 'INSERT INTO rates (id, rate, created_at) VALUES ( \'${rate.id}\', \'${rate.rate}\', \'${rate.date}\')';
      await dbConnection.transaction((transaction) async{
        return await transaction.rawInsert(query);
      });
  }

  // Get Paids 
  Future <List<dynamic>> getPaids() async{
    List listPaids = new List();
    listPaids = [];
    var dbConnection = await db;

    List<Map> list = await dbConnection.rawQuery('SELECT * FROM paids');
    Paid paid = new Paid();

    for(int i = 0; i< list.length; i++)
    {
      paid = Paid(
        id: list[i]['id'],
        user_id: list[i]['user_id'],
        commerce_id: list[i]['commerce_id'],
        codeUrl: list[i]['codeUrl'],
        nameClient: list[i]['nameClient'],
        total: list[i]['total'],
        coin: list[i]['coin'],
        email: list[i]['email'],
        nameShipping: list[i]['nameShipping'],
        numberShipping: list[i]['numberShipping'],
        addressShipping: list[i]['addressShipping'],
        detailsShipping: list[i]['detailsShipping'],
        selectShipping: list[i]['selectShipping'],
        priceShipping: list[i]['priceShipping'],
        statusShipping: list[i]['statusShipping'],
        totalShipping: list[i]['totalShipping'],
        percentage: list[i]['percentage'],
        nameCompanyPayments: list[i]['nameCompanyPayments'],
        date: list[i]['date'],
      );

      listPaids.add(paid);

    }

    return listPaids;
  }

  // Create or update Paid
  void createOrUpdatePaid (Paid paid) async{
    var dbConnection = await db;

    List<Map> list = await dbConnection.rawQuery('SELECT * FROM paids WHERE id = \'${paid.id}\' ');
    
    if(list.length == 0){
      String query = 'INSERT INTO paids (id, user_id, commerce_id, codeUrl, nameClient, total, coin, email, nameShipping, numberShipping, addressShipping, detailsShipping, selectShipping, priceShipping, statusShipping, totalShipping, percentage, nameCompanyPayments, date) VALUES ( \'${paid.id}\', \'${paid.user_id}\',\'${paid.commerce_id}\',\'${paid.codeUrl}\',\'${paid.nameClient}\',\'${paid.total}\',\'${paid.coin}\',\'${paid.email}\',\'${paid.nameShipping}\',\'${paid.numberShipping}\',\'${paid.addressShipping}\',\'${paid.detailsShipping}\',\'${paid.selectShipping}\',\'${paid.priceShipping}\',\'${paid.statusShipping}\',\'${paid.totalShipping}\',\'${paid.percentage}\',\'${paid.nameCompanyPayments}\',\'${paid.date}\')';
      await dbConnection.transaction((transaction) async{
        return await transaction.rawInsert(query);
    });
    }else{
      String query = 'UPDATE paids SET user_id=\'${paid.user_id}\', commerce_id=\'${paid.commerce_id}\', codeUrl=\'${paid.codeUrl}\', nameClient=\'${paid.nameClient}\', total=\'${paid.total}\', coin=\'${paid.coin}\', email=\'${paid.email}\', nameShipping=\'${paid.nameShipping}\', numberShipping=\'${paid.numberShipping}\', addressShipping=\'${paid.addressShipping}\', detailsShipping=\'${paid.detailsShipping}\', selectShipping=\'${paid.selectShipping}\', priceShipping=\'${paid.priceShipping}\', statusShipping=\'${paid.statusShipping}\', totalShipping=\'${paid.totalShipping}\', percentage=\'${paid.percentage}\', nameCompanyPayments=\'${paid.nameCompanyPayments}\', date=\'${paid.date}\' WHERE id= \'${paid.id}\'';
      await dbConnection.transaction((transaction) async{
        return await transaction.rawInsert(query);
      });
    }
  }

  // Get Balances 
  Future <List<dynamic>> getBalances() async{
    List listBalances = new List();
    listBalances = [];
    var dbConnection = await db;

    List<Map> list = await dbConnection.rawQuery('SELECT * FROM balances');
    Balance balance = new Balance();

    for(int i = 0; i< list.length; i++)
    {
      balance = Balance(
        id: list[i]['id'],
        user_id: list[i]['user_id'],
        commerce_id: list[i]['commerce_id'],
        total: list[i]['total'],
        coin: list[i]['coin'],
      );

      listBalances.add(balance);

    }

    return listBalances;
  }

  // Create or update Balance
  void createOrUpdateBalance (Balance balance) async{
    var dbConnection = await db;

    List<Map> list = await dbConnection.rawQuery('SELECT * FROM balances WHERE id = \'${balance.id}\' ');
    
    if(list.length == 0){
      String query = 'INSERT INTO paids (id, user_id, commerce_id, total, coin) VALUES ( \'${balance.id}\', \'${balance.user_id}\',\'${balance.commerce_id}\',\'${balance.total}\',\'${balance.coin}\')';
      await dbConnection.transaction((transaction) async{
        return await transaction.rawInsert(query);
    });
    }else{
      String query = 'UPDATE paids SET user_id=\'${balance.user_id}\', commerce_id=\'${balance.commerce_id}\', total=\'${balance.total}\', coin=\'${balance.coin}\' WHERE id= \'${balance.id}\'';
      await dbConnection.transaction((transaction) async{
        return await transaction.rawInsert(query);
      });
    }
  }

}

