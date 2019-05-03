import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class JsonPage extends StatefulWidget {
  @override
  _JsonPageState createState() => _JsonPageState();
}

class _JsonPageState extends State<JsonPage> {
  List posts = [];

  @override
  void initState() {
    getAndPrint();
    super.initState();
  }

  void _cleanPosts() {
    setState(() {
      posts = [];
    });
  }

  void _showAlert(BuildContext context, int index) {
    var alert = AlertDialog(
      title: Text("Alerta"),
      content: Text("Estas a punto de borrar este item?"),
      actions: <Widget>[
        RaisedButton(
          child: Text(
            "Si",
            style: TextStyle(color: Colors.white),
          ),
          color: Colors.red,
          onPressed: () {
            setState(() {
              posts.removeAt(index);
            });
            Navigator.pop(context);
          },
        ),
        FlatButton(
            child: Text("Cancelar"), onPressed: () => {Navigator.pop(context)})
      ],
    );

    showDialog(context: context, builder: (context) => alert);
  }

  Future<List> _getJson() async {
    String apiUrl = 'https://jsonplaceholder.typicode.com/posts';
    http.Response response = await http.get(apiUrl);
    return jsonDecode(response.body);
  }

  Future<void> getAndPrint() async {
    var postsFound = await _getJson();
    setState(() {
      posts = postsFound;
      debugPrint('Got posts: ' + posts.length.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('JSON Parser example'),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: Center(
          child: RefreshIndicator(
        child: ListView.builder(
            padding: const EdgeInsets.all(14.0),
            itemBuilder: (BuildContext context, int position) {
              return Column(children: <Widget>[
                Dismissible(
                  key: Key("${posts[position]['id']}"),
                  secondaryBackground: Container(
                    color: Colors.red,
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 50.0,
                    ),
                    alignment: Alignment.centerRight,
                  ),
                  background: Container(
                    color: Colors.green,
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 50.0,
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                  onDismissed: (direction) {
                    setState(() {
                      posts.removeAt(position);
                    });
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      child:
                          Text("${posts[position]['title'][0].toUpperCase()}"),
                    ),
                    title: Text("${posts[position]['title']}"),
                    subtitle: Text("${posts[position]['body']}"),
                    onTap: () => _showAlert(context, position),
                  ),
                ),
                Divider()
              ]);
            },
            itemCount: posts.length),
        onRefresh: getAndPrint,
      )),
      floatingActionButton: new FloatingActionButton(
        child: Icon(Icons.delete),
        backgroundColor: Colors.red,
        onPressed: _cleanPosts,
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
