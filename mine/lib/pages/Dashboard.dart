import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:mine/models/dbhelper.dart';
import 'package:mine/models/user.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:mine/pages/todo_list.dart';
import 'package:mine/pages/user_list.dart';

class DashboardScreen extends StatefulWidget {
  LoginHelper _loginHelper = new LoginHelper();
  final String user;
  DashboardScreen({this.user});

  @override
  _DashboardScreen createState() => _DashboardScreen();
}

class _DashboardScreen extends State<DashboardScreen> {
  var selected;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    {
      var icons = Icons;
      return Scaffold(
        //endDrawerEnableOpenDragGesture: false,
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
                      builder: (context) => //TodoList(
                          //user: widget.user,
                          // )
                          UserList(
                        usn: widget.user,
                      ),
                    ))
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
            "Home",
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
                showAlertDialog(context);
              },
              tooltip: "Number of Records",
            )
          ],
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Container(
                height: 70,
              ),
              Card(
                child: Column(
                  children: <Widget>[
                    Center(
                        child: Image.asset(
                      "assets/images/user.jpg",
                      width: 100,
                      height: 100,
                    )),
                    Container(
                      height: 10,
                    ),
                    Center(
                        child: Row(
                      children: [
                        Container(
                          width: 20,
                        ),
                        Icon(Icons.email),
                        Container(
                          width: 20,
                        ),
                        Text(widget.user, style: TextStyle(fontSize: 20)),
                        Container(
                          height: 100,
                        )
                      ],
                    )),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}

showAlertDialog(BuildContext context) async {
  // Create button
  var count1 = "select section for Notification";

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
