import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _userController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
	String _welcome = "Welcome";

  void _erase() {
    setState(() {
      _userController.clear();
      _passwordController.clear();
    });
  }

  void _showWelcome() {
    setState(() {
      if (_userController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
		    _welcome = "Welcome " + _userController.text;
	  }else {
		  _welcome = "Form incomplete ";
	  }


    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Login"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      backgroundColor: Colors.blueGrey,
      body: new Container(
        alignment: Alignment.topCenter,
        child: new ListView(
          children: <Widget>[
            new Image.asset(
              'assets/user.png',
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
                    controller: _userController,
                    decoration: new InputDecoration(
                        hintText: 'Username / Email Address',
                        icon: new Icon(Icons.person)),
                  ),
                  new TextField(
                    controller: _passwordController,
					obscureText: true,
                    decoration: new InputDecoration(
                      hintText: 'Password',
                      icon: new Icon(Icons.lock),
                    ),
                  ),
                  new Padding(
                    padding: new EdgeInsets.all(10.5),
                  ),
                  new Center(
                    child: new Row(
                      children: <Widget>[
                        new Container(
                          margin: const EdgeInsets.only(left: 38.0),
                          child: new RaisedButton(
                            onPressed: _showWelcome,
                            child: Text(
                              'Login',
                              style: new TextStyle(color: Colors.white),
                            ),
                            color: Colors.orange.shade500,
                          ),
                        ),
                        new Container(
                            margin: const EdgeInsets.only(left: 150.0),
                            child: new RaisedButton(
                              onPressed: _erase,
                              child: Text(
                                'Clear',
                                style: new TextStyle(color: Colors.white),
                              ),
                              color: Colors.orange.shade500,
                            ))
                      ],
                    ),
                  )
                ],
              ),
            ),

            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Padding(padding: EdgeInsets.only(top: 100.0)),
                new Text(_welcome,
                    style: new TextStyle(
                        fontSize: 25.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w500))
              ],
            ) //Form ends here
          ],
        ),
      ),
    );
  }
}
