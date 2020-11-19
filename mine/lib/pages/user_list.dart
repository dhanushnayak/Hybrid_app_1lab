import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:mine/models/user.dart';
import 'package:mine/models/dbhelper.dart';
import 'package:mine/pages/todo_list.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

LoginHelper databaseHelper = LoginHelper();
final Future<Database> dbFuture = databaseHelper.initializeDatabase();
int _total = 0;

class UserList extends StatefulWidget {
  var usn;
  UserList({this.usn});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return UserListState();
  }
}

class UserListState extends State<UserList> {
  final Future<Database> dbFuture = databaseHelper.initializeDatabase();
  List<User> userlist;
  int count = 0;
  var selected;
  @override
  Widget build(BuildContext context) {
    if (userlist == null) {
      userlist = List<User>();
      updateListView(widget.usn.toString());
    }
    return WillPopScope(
        onWillPop: () {
          moveToLastScreen();
        },
        child: Scaffold(
          drawer: Container(
            width: 250,
            child: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  Container(
                    height: 50,
                  ),
                  ListTile(
                      dense: true,
                      autofocus: true,
                      leading: SizedBox(
                          height: 600.0,
                          width: 200.0, // fixed width and height
                          child: Image.asset(
                            "assets/images/user.jpg",
                          ))),
                  Container(
                    height: 50,
                  ),
                  ListTile(
                    leading: new IconButton(
                      icon: Icon(Icons.person),
                      onPressed: () {
                        setState(() {
                          selected = 'second';
                        });
                      },
                    ),
                    autofocus: true,
                    dense: true,
                    title: Text("Users",
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: "sans-serif",
                          color:
                              selected == 'second' ? Colors.grey : Colors.black,
                        )),
                    onTap: () => {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => UserList(
                                usn: widget.usn,
                              )))
                    },
                  ),
                  ListTile(
                    leading: new IconButton(
                      icon: Icon(Icons.work),
                      onPressed: () {
                        setState(() {
                          selected = 'second';
                        });
                      },
                    ),
                    autofocus: true,
                    dense: true,
                    title: Text("TO-DO",
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: "sans-serif",
                          color:
                              selected == 'second' ? Colors.grey : Colors.black,
                        )),
                    onTap: () => {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => TodoList(
                                user: widget.usn,
                              )
                          //UserList(
                          //usn: widget.user,
                          //),
                          ))
                    },
                  ),
                ],
              ),
            ),
          ),
          appBar: AppBar(
            leading: Builder(
              builder: (context) => IconButton(
                icon: new Icon(
                  Icons.menu,
                  color: Colors.grey,
                ),
                onPressed: () => Scaffold.of(context).openDrawer(),
                tooltip: "Menu",
              ),
            ),
            title: Text(
              "Users",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            backgroundColor: Colors.white,
            shadowColor: Colors.grey,
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.notifications,
                  color: Colors.grey,
                ),
                onPressed: () {
                  showAlertDialog(context, count);
                },
              )
            ],
          ),
          body: getTodoListView(),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.grey,
            onPressed: () {
              debugPrint('FAB clicked');
              _onAlertWithCustomContentPressed(context);
            },
            tooltip: 'Add User',
            child: Icon(Icons.add),
          ),
        ));
  }

  ListView getTodoListView() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
                backgroundImage: AssetImage('assets/images/user.jpg')),
            title: Text(this.userlist[position].usn,
                style: TextStyle(fontWeight: FontWeight.bold)),
            //subtitle: Text(this.userlist[position].usn),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  child: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onTap: () {
                    _delete(context, userlist[position], widget.usn.toString());
                    print("Done $position");
                  },
                ),
              ],
            ),
            onTap: () {
              debugPrint("ListTile Tapped");
            },
          ),
        );
      },
    );
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  showAlertDialog(BuildContext context, count) async {
    // Create button
    var count1 = count;

    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog

    AlertDialog alert = AlertDialog(
      title: Text("RowCount"),
      content: Text("Number of Users " + count1.toString()),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _delete(BuildContext context, User todo, String user) async {
    print(todo.usn);
    int result = await databaseHelper.deleteTodo(todo.id);
    print(todo.id);
    if (result != 0) {
      _showSnackBar(context, 'User Deleted Successfully');
      updateListView(user);
    }
  }

  void updateListView(user) {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<User>> todoListFuture = databaseHelper.getUsers(user);
      todoListFuture.then((todoList) {
        setState(() {
          this.userlist = todoList;

          this.count = todoList.length;
        });
      });
    });
  }
}

void _showSnackBar(BuildContext context, String message) {
  final snackBar = SnackBar(content: Text(message));
  Scaffold.of(context).showSnackBar(snackBar);
}

void insertnode(String user) {
  if (user.contains("@") && user.contains(".com")) {
    databaseHelper.insertUser(User(user, '12345'));
  }
}

_onAlertWithCustomContentPressed(context) {
  final user = TextEditingController();
  final password = TextEditingController();
  Alert(
      context: context,
      title: "Add user",
      content: Column(
        children: <Widget>[
          TextField(
            controller: user,
            decoration: InputDecoration(
              icon: Icon(Icons.account_circle),
              labelText: 'Username',
            ),
          ),
          TextField(
            controller: password,
            obscureText: true,
            decoration: InputDecoration(
              icon: Icon(Icons.lock),
              labelText: 'Password',
              hintText: "default(eg : 12345)",
            ),
          ),
        ],
      ),
      buttons: [
        DialogButton(
          onPressed: () => {
            insertnode(user.text),
            Navigator.pop(context),
          },
          child: Text(
            "ADD",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        )
      ]).show();
}
