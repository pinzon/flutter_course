import 'package:flutter/material.dart';
import 'database.dart';
import 'dart:async';
import 'dart:math';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Database'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _username = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  DatabaseHelper db = new DatabaseHelper();
  // List<dynamic> _users;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<List<dynamic>> _getUserLists() async {
    return db.getAllUsers();
  }

  Future addUser() async {
    var user = new User(_username.text, _password.text);
    await db.saveUser(user);
    _username.clear();
    _password.clear();
    setState(() {});
  }

  void deleteUser(BuildContext context, int idUser) async {
    await db.deleteUser(idUser);
    final snackBar = SnackBar(
      content: Text('User deleted!'),
      duration: const Duration(seconds: 1),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void updateUser(User user) async {
    user.username = _username.text;
    user.password = _password.text;
    await db.updateUser(user);
    setState(() {});
  }

  Future showNewUserDialog(BuildContext context) {
    _username.clear();
    _password.clear();

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('New User'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: _username,
                  decoration: InputDecoration(hintText: "Username"),
                ),
                TextField(
                  controller: _password,
                  decoration: InputDecoration(hintText: "Password"),
                ),
              ],
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('CANCEL'),
                textColor: Colors.red,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text('ADD'),
                onPressed: () async {
                  await addUser();
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  Future showUpdateUserDialog(BuildContext context, User user) {
    debugPrint(user.toMap().toString());
    _username.text = user.username;
    _password.text = user.password;

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Update User'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: _username,
                  decoration: InputDecoration(hintText: "Username"),
                ),
                TextField(
                  controller: _password,
                  decoration: InputDecoration(hintText: "Password"),
                ),
              ],
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('CANCEL'),
                textColor: Colors.red,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text('UPDATE'),
                onPressed: () async {
                  updateUser(user);
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  Widget usersList(BuildContext context) {
    return FutureBuilder(
      future: _getUserLists(),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          debugPrint('Has data');
          var rng = new Random();
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int position) {
              return new Dismissible(
                key: Key("${rng.nextInt(50000)}"),
                onDismissed: (direction) =>
                    deleteUser(context, snapshot.data[position]['id']),
                background: new Container(
                  padding: const EdgeInsets.all(10),
                  color: Colors.grey.shade500,
                  child: Icon(Icons.delete),
                  alignment: Alignment.centerRight,
                ),
                child: new ListTile(
                  onTap: () => showUpdateUserDialog(
                      context, User.fromMap(snapshot.data[position])),
                  title: Container(
                    padding: EdgeInsets.all(20.0),
                    // color: Colors.black54,
                    child: new Text(
                      snapshot.data[position]['username'],
                      style: new TextStyle(color: Colors.white),
                    ),
                    decoration: new BoxDecoration(
                        color: Colors.black87,
                        borderRadius:
                            new BorderRadius.all(const Radius.circular(10))),
                  ),
                ),
              );
            },
          );
        } else {
          debugPrint("No data yet");
          return new Container();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.grey.shade900,
      ),
      backgroundColor: Colors.grey.shade500,
      body: usersList(context),
      floatingActionButton: new FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
        onPressed: () => {showNewUserDialog(context)},
      ),
    );
  }
}
