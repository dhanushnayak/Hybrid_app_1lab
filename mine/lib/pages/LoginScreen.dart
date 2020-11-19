import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:mine/models/dbhelper.dart';
import 'package:mine/models/user.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:mine/pages/todo_list.dart';
import 'package:mine/pages/Dashboard.dart';

class LoginScreen extends StatelessWidget {
  //LoginHelper _loginHelper = new LoginHelper();
  var users;
  LoginHelper _loginHelper = new LoginHelper();
  Duration get loginTime => Duration(milliseconds: 2250);
  LoginScreen({this.users});
  Future<String> _signUp(LoginData data) {
    // _loginHelper.initializeDatabase().then((value) => print("INIT CHECK"));
    return Future.delayed(loginTime).then((_) {
      try {
        _loginHelper.insertUser(User(data.name, data.password));
        users[data.name] = data.password;
        return null;
      } catch (e) {
        print("ERRRORR : $e");
        return "User will be activated";
      }
    });
  }

  Future<String> _authUser(LoginData data) {
    print('Name: ${data.name}, Password: ${data.password}');

    var user = _loginHelper.loginprocess(User(data.name, data.password));
    user.then((value) => {users[value['usn']] = value['password']});
    //list.forEach((customer) => users[customer.usn] = customer.password);
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(data.name)) {
        return 'Please Retry with correct Email and Password';
      }
      if (users[data.name] != data.password) {
        return 'Password does not match';
      }
      return null;
    });
  }

  Future<String> _recoverPassword(String name) {
    print('Name: $name');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(name)) {
        return 'Username not exists';
      }
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'LOGIN',
      theme: LoginTheme(primaryColor: Colors.blueAccent),
      onLogin: _authUser,
      onSignup: _signUp,
      messages: LoginMessages(
        confirmPasswordError: "Password Mismatched",
        signupButton: 'REGISTER',
      ),
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => DashboardScreen(
                  user: users.keys.elementAt(0).toString(),
                )));
      },
      onRecoverPassword: _recoverPassword,
    );
  }
}
//Navigator.of(context).pushReplacement(MaterialPageRoute(
//builder: (context) => DashboardScreen(
//user: users.keys.elementAt(0).toString(),
//)));
