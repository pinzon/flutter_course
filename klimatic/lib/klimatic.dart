import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'util/store.dart';
import 'citySelect.dart';

class Klimatic extends StatefulWidget {
  @override
  KlimaticHome createState() => new KlimaticHome();
}

class KlimaticHome extends State<Klimatic> {
  String _city = Store().getCity();

  // void showStuff() async {
  //   Map data = await getWeather();
  //   debugPrint(data.toString());
  // }

  Future<void> goToSelectCity(BuildContext context) async {
    Map results = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return new City();
    }));

    if (results != null && results.containsKey("city")) {
      print("Searching for: "+ results['city'].toString());
      setState(() {
        _city = results['city'].toString();
      });
      getWeather();
    }
  }

  Future<Map> getWeather() async {
    String apiKey = Store().getApiKey();
    String city = _city;
    String apiUrl =
        "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric";

    http.Response response = await http.get(apiUrl);
    // debugPrint(response.body);

    Map json = jsonDecode(response.body);

    return json;
  }

  Widget updateTempWidget() {
    return new FutureBuilder(
        future: getWeather(),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
          if (snapshot.hasData && snapshot.data['cod'] == 200 ) {
            Map content = snapshot.data;

            return new Container(
              child: Column(
                children: <Widget>[
                  Text(
                    content['main']['temp'].toString() + "C",
                    style: mainTempStype,
                  ),
                  Text(
                    "MAX: " +
                        content['main']['temp_max'].toString() +
                        "\nMIN: " +
                        content['main']['temp_min'].toString() +
                        "\nHumidity: " +
                        content['main']['humidity'].toString(),
                    style: maxminStyle,
                  ),
                ],
              ),
            );
          } else {
            return Container();
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Klimatic"),
        centerTitle: true,
        backgroundColor: Colors.red,
        actions: <Widget>[
          new IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => goToSelectCity(context),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Stack(
          fit: StackFit.passthrough,
          children: <Widget>[
            new Center(
              child: Image.asset(
                'assets/umbrella.png',
                width: 490.0,
                fit: BoxFit.fill,
              ),
            ),
            new Container(
              child: Text(
                _city.toUpperCase(),
                style: cityTextStyle,
              ),
              alignment: Alignment.topRight,
              margin: const EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 0),
            ),
            new Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 150.0),
              child: Image.asset('assets/light_rain.png'),
            ),
            new Container(
              // alignment: Alignment.center,
              margin: const EdgeInsets.fromLTRB(10.0, 290.0, 0, 0),
              child: updateTempWidget(),
            )
          ],
        ),
      ),
    );
  }
}

TextStyle cityTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 23.0,
    fontWeight: FontWeight.w800,
    fontStyle: FontStyle.italic);

TextStyle mainTempStype = TextStyle(
    color: Colors.white,
    shadows: <Shadow>[
      
    ],
    fontSize: 49.9,
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.normal);

TextStyle maxminStyle = TextStyle(
  color: Colors.grey.shade50,
  fontSize: 20.5,
  fontWeight: FontWeight.w500,
  fontStyle: FontStyle.normal,
);
