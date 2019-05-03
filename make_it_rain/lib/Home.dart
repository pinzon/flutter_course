import 'package:flutter/material.dart';
import 'dart:math';

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
	int _counter = 0;
	var rng = new Random();
	TextStyle style = MoneyStyles().simple;
	

	void _getMoney() => {
		setState(() => {
			_counter += rng.nextInt(5000),
			style = (_counter > 10000)? MoneyStyles().rich : MoneyStyles().simple
		})
	};

	 @override
	void initState() {
		super.initState();
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: Text(widget.title),
			),
			body: Center(
				child: Column(
					mainAxisAlignment: MainAxisAlignment.start,
					children: <Widget>[
						Text(
							'Get Rich!!',
							style: new TextStyle(
									fontSize: 50.0,
									fontWeight: FontWeight.w700,
									color: Colors.yellow.shade400),
						),
						new Container(
							margin: EdgeInsets.only(top: 50.0),
							child: Text(
								'\$$_counter',
								style: style,
							),
						),
						new Container(
								margin: EdgeInsets.only(top: 200.0),
								child: new FlatButton(
									color: Colors.yellow.shade400,
									onPressed: () => _getMoney(),
									child: new Text(
										'GIVE ME MONEY',
									)))
					],
				),
			),
		);
	}
}


class MoneyStyles {
	TextStyle simple =  new TextStyle(
		fontSize: 30.0,
		fontWeight: FontWeight.w200,
		color: Colors.grey.shade500);
	
	TextStyle rich =  new TextStyle(
		fontSize: 50.0,
		fontWeight: FontWeight.w700,
		color: Colors.yellow.shade400);
}
