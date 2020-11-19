import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:mine/models/dbhelper.dart';
import 'package:mine/models/user.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:mine/pages/LoginScreen.dart';
import 'package:mine/pages/Dashboard.dart';
import 'package:mine/pages/todo_list.dart';

var user;

void main() {
  runApp(MyApp());
  LoginHelper _loginHelper = new LoginHelper();
  _loginHelper.initializeDatabase().then((value) => print("INIT CHECK"));
}

class MyApp extends StatelessWidget {
  var users = {};
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: LoginScreen(
        users: users,
      ),

      //TodoList(),
    );
  }
}

// ignore: must_be_immutable
