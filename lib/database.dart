import 'package:ctpaga/models/bank.dart';
import 'package:ctpaga/models/categories.dart';
import 'package:ctpaga/models/commerce.dart';
import 'package:ctpaga/models/picture.dart';
import 'package:ctpaga/models/product.dart';
import 'package:ctpaga/models/service.dart';
import 'package:ctpaga/models/user.dart';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io'as io;
import 'dart:async';


class DBctpaga{

  static Database dbInstance;

  Future<Database> get db async{
    if(dbInstance == null)
      dbInstance = await initDB();

    return dbInstance;
  }

  initDB() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "ctpaga.db");

    var db = await openDatabase(path, version: 5, 
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
    await db.execute('CREATE TABLE IF NOT EXISTS commerces (id INTEGER PRIMARY KEY AUTOINCREMENT, rif VARCHAR(15), name Text, address Text, phone VARCHAR(20) )');
    await db.execute('CREATE TABLE IF NOT EXISTS categories (id INTEGER, name VARCHAR(50), commerce_id INTEGER, type INTEGER)');
    await db.execute('CREATE TABLE IF NOT EXISTS products (id INTEGER, commerce_id INTEGER, url text, name Text, price VARCHAR(50), coin INTEGER, description text, categories VARCHAR(50), publish INTEGER, stock INTEGER, postPurchase INTEGER)');
    await db.execute('CREATE TABLE IF NOT EXISTS services (id INTEGER, commerce_id INTEGER, url text, name Text, price VARCHAR(50), coin INTEGER, description text, categories VARCHAR(50), publish INTEGER, postPurchase INTEGER)');
  }

  /*
    CRUD FUNCTION
  */

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
        print("entro USD");
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
      );

      listCommercesUser.add(commerceUser);

    }

    return listCommercesUser;
  }

  // Create or update commerces
  void createOrUpdateCommercesUser (Commerce commerce) async{
    var dbConnection = await db;

    String query = 'INSERT OR REPLACE INTO commerces (id, rif, name, address, phone) VALUES ( (SELECT id FROM commerces WHERE rif = \'${commerce.rif}\'), \'${commerce.rif}\', \'${commerce.name}\',\'${commerce.address}\',\'${commerce.phone}\')';
    await dbConnection.transaction((transaction) async{
      return await transaction.rawInsert(query);
    });
  }

  // Get Categories User
  Future <List<dynamic>> getCategories() async{
    List listCategories = new List();
    listCategories = [];
    var dbConnection = await db;

    List<Map> list = await dbConnection.rawQuery('SELECT * FROM categories');
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
        postPurchase : list[i]['postPurchase'] == 1 ? true : false,
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
      String query = 'INSERT INTO products (id, commerce_id, url, name, price, coin, description, categories, publish, stock, postPurchase) VALUES ( \'${product.id}\', \'${product.commerce_id}\', \'${product.url}\',\'${product.name}\',\'${product.price}\',\'${product.coin}\',\'${product.description}\',\'${product.categories}\',\'${product.publish?1:0}\',\'${product.stock}\',\'${product.postPurchase?1:0}\')';
      await dbConnection.transaction((transaction) async{
        return await transaction.rawInsert(query);
    });
    }else{
      String query = 'UPDATE products SET commerce_id=\'${product.commerce_id}\', url=\'${product.url}\', name=\'${product.name}\', price=\'${product.price}\', coin=\'${product.coin}\', description=\'${product.description}\', categories=\'${product.categories}\', publish=\'${product.publish?1:0}\', stock=\'${product.stock}\', postPurchase=\'${product.postPurchase?1:0}\' WHERE id= \'${product.id}\'';
      await dbConnection.transaction((transaction) async{
        return await transaction.rawInsert(query);
      });
    }
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
        postPurchase : list[i]['postPurchase'] == 1 ? true : false,
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
      String query = 'INSERT INTO services (id, commerce_id, url, name, price, coin, description, categories, publish, postPurchase) VALUES ( \'${service.id}\', \'${service.commerce_id}\', \'${service.url}\',\'${service.name}\',\'${service.price}\',\'${service.coin}\',\'${service.description}\',\'${service.categories}\',\'${service.publish?1:0}\',\'${service.postPurchase?1:0}\')';
      await dbConnection.transaction((transaction) async{
        return await transaction.rawInsert(query);
    });
    }else{
      String query = 'UPDATE services SET commerce_id=\'${service.commerce_id}\', url=\'${service.url}\', name=\'${service.name}\', price=\'${service.price}\', coin=\'${service.coin}\', description=\'${service.description}\', categories=\'${service.categories}\', publish=\'${service.publish?1:0}\', postPurchase=\'${service.postPurchase?1:0}\' WHERE id= \'${service.id}\'';
      await dbConnection.transaction((transaction) async{
        return await transaction.rawInsert(query);
      });
    }
  }

}

