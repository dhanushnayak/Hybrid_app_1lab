import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'dart:async';
import "package:path_provider/path_provider.dart";
import "package:mine/models/user.dart";

final String tablename = 'login';
final String colId = 'id';
final String columnusn = 'usn';
final String columnpassword = 'password';

class LoginHelper {
  static Database _database;
  static LoginHelper _loginHelper;
  LoginHelper._createInstance();
  factory LoginHelper() {
    if (_loginHelper == null) {
      _loginHelper = LoginHelper._createInstance();
    }
    return _loginHelper;
  }
  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory dir = await getApplicationDocumentsDirectory();
    var path = dir.path + "User.db";
    print(path);
    var database = await openDatabase(path, version: 1, onCreate: _createDb);
    return database;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $tablename($colId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,$columnusn TEXT UNIQUE NOT NULL,$columnpassword TEXT NOT NULL)');
  }

  Future<List<User>> getUsers(String user) async {
    List<User> _users = [];
    var db = await this.database;
    var result = await db
        .rawQuery('SELECT * FROM $tablename WHERE $columnusn != "$user"');
    result.forEach((element) {
      var user = User.fromMap(element);
      _users.add(user);
    });
    return _users;
  }

  Future<Map> loginprocess(User user) async {
    var _users;
    var db = await this.database;
    var usn = user.usn;
    var password = user.password;
    List<Map> res = await db.rawQuery(
        'SELECT * FROM $tablename WHERE $columnusn=? and $columnpassword=?',
        ['$usn', '$password']);
    print("$res, $usn ,$password");
    res.forEach((element) {
      var user = User.fromMap(element);

      _users = user.toMap();
    });
    print("_USER passed : $_users");
    return _users;
  }

  Future<int> updateUser(User todo) async {
    var db = await this.database;
    var result = await db.update(tablename, todo.toMap(),
        where: '$colId= ?', whereArgs: [todo.id]);
    return result;
  }

  Future<int> deleteTodo(int id) async {
    var db = await this.database;
    int result =
        await db.rawDelete('DELETE FROM $tablename WHERE $colId = $id');
    return result;
  }

  Future<int> insertUser(User user) async {
    var db = await this.database;
    var res = await db.insert(tablename, user.toMap());
    print("Result = $res");
  }
}
