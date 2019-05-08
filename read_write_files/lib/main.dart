import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'dart:io';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _messageController = new TextEditingController();

  Future<String> get _localPath async {
    final directory =
        await getApplicationDocumentsDirectory(); //home /directory
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return new File('$path/test.txt');
  }

  Future<File> writeData(String message) async {
    final file = await _localFile;
    return file.writeAsString('$message');
  }

  Future<String> readData() async {
    try {
      final file = await _localFile;
      String data = await file.readAsString();
      return data;
    } catch (e) {
      debugPrint(e.toString());
      return '';
    }
  }

  void _saveText() async {
    String toastMessage = "No text to save";

    if (_messageController.text.isNotEmpty){
      await writeData(_messageController.text);
      toastMessage = "Text saved!";
    }

    Fluttertoast.showToast( 
        msg: toastMessage,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void _setDataOnFiel() async{
    _messageController.text = await readData();
  }

  @override
  void initState() {
    // TODO: implement initState
    _setDataOnFiel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Read / Write Files"),
          backgroundColor: Colors.green,
          centerTitle: true,
        ),
        body: ListView(
          children: <Widget>[
            TextField(
              controller: _messageController,
              keyboardType: TextInputType.multiline,
              maxLines: 10,
              decoration: InputDecoration(labelText: "Message"),
            ),
            RaisedButton(
              onPressed: _saveText,
              child: Text("Save"),
              color: Colors.green,
              textColor: Colors.white,
            )
          ],
        ));
  }
}
