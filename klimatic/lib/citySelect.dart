import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'util/store.dart';

class City extends StatefulWidget {
  City({Key key}) : super(key: key);

  @override
  _CityState createState() => _CityState();
}

class _CityState extends State<City> {
  TextEditingController _cityController = new TextEditingController();

  void goBackToWeather(BuildContext context){
    if (_cityController.text.isNotEmpty){
      Navigator.pop(context,{
        'city' : _cityController.text
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select city"),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            TextField(
              controller: _cityController,
              decoration:
                  InputDecoration(hintText: "City", icon: Icon(Icons.map)),
            ),
            ListTile(
              title: FlatButton(
                onPressed: () => goBackToWeather(context),
                child: Text("Search"),
                color: Colors.red,
                textColor: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
