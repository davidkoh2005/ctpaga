import 'package:ctpaga/models/bank.dart';
import 'package:ctpaga/models/picture.dart';
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

    var db = await openDatabase(path, version: 3, onCreate: onCreateFunc);

    return db;
  }


  void onCreateFunc (Database db, int version) async{
    //create table
    await db.execute('CREATE TABLE users (id INTEGER PRIMARY KEY AUTOINCREMENT, email Text, name VARCHAR(100), address Text, phone VARCHAR(20), rifCompany VARCHAR(15), nameCompany Text, addressCompany Text, phoneCompany VARCHAR(20), coin INTEGER )');
    await db.execute('CREATE TABLE banks (id INTEGER PRIMARY KEY AUTOINCREMENT, coin VARCHAR(3), country VARCHAR(10), accountName VARCHAR(100), accountNumber VARCHAR(50), idCard VARCHAR(50), route VARCHAR(9), swift VARCHAR(20), address Text, bankName VARCHAR(100), accountType VARCHAR(1))');
    await db.execute('CREATE TABLE pictures (id INTEGER PRIMARY KEY AUTOINCREMENT, description VARCHAR(30), url Text )');
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
        rifCompany :  list[i]['rifCompany'],
        nameCompany : list[i]['nameCompany'],
        addressCompany : list[i]['addressCompany'],
        phoneCompany : list[i]['phoneCompany'],
        coin : list[i]['coin'],
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
    String query = 'INSERT INTO users (email , name, address, phone, rifCompany , nameCompany , addressCompany , phoneCompany, coin) VALUES (\'${user.email}\',\'${user.name}\',\'${user.address}\',\'${user.phone}\',\'${user.rifCompany}\',\'${user.nameCompany}\',\'${user.addressCompany}\',\'${user.phoneCompany}\',\'${user.coin}\')';
    await dbConnection.transaction((transaction) async{
      return await transaction.rawInsert(query);
    });
  }

  void createOrUpdateUser (User user) async{
    var dbConnection = await db;
    String query = 'INSERT INTO users (id, email , name, address, phone, rifCompany , nameCompany , addressCompany , phoneCompany, coin) VALUES ((SELECT id  FROM users WHERE email = \'${user.email}\'), \'${user.email}\',\'${user.name}\',\'${user.address}\',\'${user.phone}\',\'${user.rifCompany}\',\'${user.nameCompany}\',\'${user.addressCompany}\',\'${user.phoneCompany}\',\'${user.coin}\')';
    await dbConnection.transaction((transaction) async{
      return await transaction.rawInsert(query);
    });
  }

  // Update User
  void updateUser (User user) async{
    var dbConnection = await db;
    String query = 'UPDATE users SET email=\'${user.email}\', name=\'${user.name}\', address=\'${user.address}\', phone=\'${user.phone}\', rifCompany=\'${user.rifCompany}\', nameCompany=\'${user.nameCompany}\', addressCompany=\'${user.addressCompany}\', phoneCompany=\'${user.phoneCompany}\', coin=\'${user.coin}\' WHERE id=1';
    await dbConnection.transaction((transaction) async{
      return await transaction.rawQuery(query);
    });
  }

  // Delete User
  void deleteUser (User user) async{
    var dbConnection = await db;
    String query = 'DELETE FROM users  WHERE idUsers=${user.id}';
    await dbConnection.transaction((transaction) async{
      return await transaction.rawQuery(query);
    });
  }

  // Get User
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

  // Create or update User
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
      );

      listPicturesUser.add(pictureUser);

    }

    return listPicturesUser;
  }

  // Create or update User
  void createOrUpdatePicturesUser (Picture picture) async{
    var dbConnection = await db;

    String query = 'INSERT OR REPLACE INTO pictures (id, description, url) VALUES ( (SELECT id FROM pictures WHERE description = \'${picture.description}\'), \'${picture.description}\',\'${picture.url}\')';
    await dbConnection.transaction((transaction) async{
      return await transaction.rawInsert(query);
    });
  }


}

