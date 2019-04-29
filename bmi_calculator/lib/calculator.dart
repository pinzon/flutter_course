import 'package:flutter/material.dart';

class BMICalculatorPage extends StatefulWidget {
  BMICalculatorPage({Key key}) : super(key: key);

  @override
  _BMICalculatorPageState createState() => _BMICalculatorPageState();
}

class _BMICalculatorPageState extends State<BMICalculatorPage> {
  final TextEditingController _weightController = new TextEditingController();
  final TextEditingController _heightController = new TextEditingController();

  Map statusColors = {
    "Underweight": Colors.grey,
    "Healthy": Colors.blue,
    "Overweight": Colors.green,
    "Obesity": Colors.orange,
    "Extreme Obesity": Colors.red
  };

  String _bmi = "";
  String _status = "";

  void _calculate() {
    setState(() {
      _bmi = "";
      _status = "";
    });

    if (_weightController.text.isNotEmpty &&
        _heightController.text.isNotEmpty) {
      double w = double.parse(_weightController.text);
      double h = double.parse(_heightController.text);
      double bmi = w / (h * h);
      String stat = '';

      if (bmi < 19) {
        stat = "Underweight";
      } else if (bmi >= 19 && bmi <= 24.9) {
        stat = "Healthy";
      } else if (bmi >= 25 && bmi <= 29.9) {
        stat = "Overweight";
      } else if (bmi >= 30 && bmi <= 39.9) {
        stat = "Obesity";
      } else {
        stat = "Extreme Obesity";
      }

      setState(() {
        _bmi = 'Your BMI is: ' + bmi.toStringAsFixed(1);
        _status = stat;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("BMICalculator"),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: new Container(
        alignment: Alignment.topCenter,
        child: new ListView(
          children: <Widget>[
            new Image.asset(
              'assets/bmilogo.png',
              width: 90.0,
              height: 90.0,
            ),
            new Container(
              height: 180.0,
              width: 380.0,
              color: Colors.grey.shade100,
              child: new Column(
                children: <Widget>[
                  new TextField(
                    controller: _weightController,
                    decoration: new InputDecoration(
                      hintText: 'Weight in Kg',
                      icon: new Icon(Icons.line_weight),
                    ),
                  ),
                  new TextField(
                    controller: _heightController,
                    decoration: new InputDecoration(
                      hintText: 'Height in Meters',
                      icon: new Icon(Icons.linear_scale),
                    ),
                  ),
                  new Padding(
                    padding: new EdgeInsets.all(10.5),
                  ),
                  new Center(
                    child: new Container(
                      child: new RaisedButton(
                        onPressed: _calculate,
                        child: Text(
                          'Calculate',
                          style: new TextStyle(color: Colors.white),
                        ),
                        color: Colors.pinkAccent.shade200,
                      ),
                    ),
                  )
                ],
              ),
            ),

            new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Padding(padding: EdgeInsets.only(top: 10.0)),
                new Text(_bmi,
                    style: new TextStyle(
                        fontSize: 35.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w500)),
                // new Padding(padding: EdgeInsets.only(top: 25.0)),
                new Text(_status,
                    style: new TextStyle(
                        fontSize: 25.0,
                        // color: Colors.black,
                        color: statusColors[_status],
                        fontWeight: FontWeight.w500))
              ],
            ) //Form ends here
          ],
        ),
      ),
    );
  }
}
