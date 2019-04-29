import 'package:flutter/material.dart';

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
  int radioValue = 0;
  Map planetMultipliers = {0: 0.06, 1: 0.38, 2: 0.92};
  String message = "welcome";
  final TextEditingController _weightControler = new TextEditingController();

  List<Color> planetColors = [Colors.brown, Colors.red, Colors.green];

  void _handleRadioValue(int value) {
    setState(() {
      radioValue = value;
	  message = _getMessage(_weightControler.text, planetMultipliers[radioValue]);
    });
  }

  void _handleTextChange(String text){
	  setState(() {
		message = _getMessage(text, planetMultipliers[radioValue]);
    });
  }

  String _getMessage(String weight, double multiplier){
	  if (weight.isNotEmpty) {
		double  w = double.parse(weight) * multiplier;
		String wFormated = w.toStringAsFixed(2);
       	return "Your weight would be " + wFormated + 'Kg';
      }

	  return '';
  }

  @override
  void dispose(){
	  _weightControler.dispose();
	  super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text("Weight On Planet X"),
          centerTitle: true,
          backgroundColor: Colors.grey.shade600,
        ),
        body: new Container(
          alignment: Alignment.topCenter,
          child: new ListView(
            padding: const EdgeInsets.all(2.5),
            children: <Widget>[
              new Image.asset(
                'assets/105_planet.png',
                width: 150.0,
                height: 150.0,
              ),
              new Padding(
                padding: EdgeInsets.all(5.0),
              ),
              new Container(
                  margin: const EdgeInsets.all(3.0),
                  child: new Column(
                    children: <Widget>[
                      new TextField(
                        controller: _weightControler,
						onChanged: _handleTextChange,
                        keyboardType: TextInputType.number,
                        decoration: new InputDecoration(
                          labelText: "Your weight on Earth",
                          hintText: "In KG",
                          icon: new Icon(Icons.person),
                        ),
                      ),
                      new Padding(
                        padding: EdgeInsets.all(5.0),
                      ),
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Radio<int>(
                            value: 0,
                            activeColor: Colors.brown,
                            groupValue: radioValue,
                            onChanged: _handleRadioValue,
                          ),
                          new Text('Pluto'),
                          new Radio<int>(
                            value: 1,
                            activeColor: Colors.red,
                            groupValue: radioValue,
                            onChanged: _handleRadioValue,
                          ),
                          new Text('Mars'),
                          new Radio<int>(
                            value: 2,
                            activeColor: Colors.green,
                            groupValue: radioValue,
                            onChanged: _handleRadioValue,
                          ),
                          new Text('Venus'),
                        ],
                      ),

                      // Result text
                      new Container(
                        alignment: Alignment.center,
                        child: new Text(
                          message,
						  textAlign: TextAlign.center,
                          style: new TextStyle(fontSize: 25.0, color: planetColors[radioValue]),
                        ),
                      )
                    ],
                  ))
            ],
          ),
        ));
  }
}
