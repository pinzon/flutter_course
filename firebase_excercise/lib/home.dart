import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

final FirebaseDatabase database = FirebaseDatabase.instance;

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  void initState() {
    // TODO: implement initState
    database.reference().child("message").once().then((DataSnapshot snapshot){
        Map<dynamic,dynamic> list = snapshot.value;

        print("Values from db: ${list.values.toString()}");

      });

    super.initState();
  }

  void _incrementCounter() {
    database.reference().child("message").set({"firstname": "test"});

    setState(() {
      database.reference().child("message").once().then((DataSnapshot snapshot){
        Map<dynamic,dynamic> list = snapshot.value;

        print("Values from db: ${list.values.toString()}");

      });
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
