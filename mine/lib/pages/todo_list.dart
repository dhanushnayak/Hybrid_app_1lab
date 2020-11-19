import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mine/models/todo.dart';
import 'package:mine/models/dbhelper1.dart';
import 'package:mine/pages/todo_detail.dart';
import 'package:sqflite/sqflite.dart';
import 'package:mine/pages/user_list.dart';

import 'package:intl/intl.dart';

DatabaseHelper databaseHelper = DatabaseHelper();
final Future<Database> dbFuture = databaseHelper.initializeDatabase();
int _total = 0;

// ignore: must_be_immutable
class TodoList extends StatefulWidget {
  var user;
  TodoList({this.user});

  @override
  State<StatefulWidget> createState() {
    return TodoListState();
  }
}

class TodoListState extends State<TodoList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Todo> todoList;
  int count = 0;
  var selected;
  @override
  Widget build(BuildContext context) {
    if (todoList == null) {
      todoList = List<Todo>();
      updateListView();
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
                                usn: widget.user,
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
                                user: widget.user,
                              )
                          //UserList(
                          //usn: widget.user,
                          //),
                          ))
                    },
                  )
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
              "Notes",
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
              navigateToDetail(Todo('', '', widget.user, ''), 'Add Note');
            },
            tooltip: 'Add Note',
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
              backgroundColor:
                  Color.alphaBlend(Colors.transparent, Colors.amberAccent),
              child: Text(getFirstLetter(this.todoList[position].title),
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            title: Text(this.todoList[position].title,
                style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(this.todoList[position].usn),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  child: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onTap: () {
                    _delete(context, todoList[position]);
                  },
                ),
              ],
            ),
            onTap: () {
              debugPrint("ListTile Tapped");
              navigateToDetail(this.todoList[position], 'Edit Note');
            },
          ),
        );
      },
    );
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  getFirstLetter(String title) {
    return title.substring(0, 2);
  }

  void _delete(BuildContext context, Todo todo) async {
    int result = await databaseHelper.deleteTodo(todo.id);
    if (result != 0) {
      _showSnackBar(context, 'Todo Deleted Successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void navigateToDetail(Todo todo, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return TodoDetail(todo, title);
    }));

    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Todo>> todoListFuture =
          databaseHelper.getTodoList(widget.user);
      todoListFuture.then((todoList) {
        setState(() {
          this.todoList = todoList;

          this.count = todoList.length;
        });
      });
    });
  }
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
    content: Text("Number of Notes " + count1.toString()),
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
