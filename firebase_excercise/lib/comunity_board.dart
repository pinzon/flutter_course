import 'package:flutter/material.dart';
import 'package:firebase_excercise/model/board.dart';
import 'package:firebase_database/firebase_database.dart';
import "package:firebase_database/ui/firebase_animated_list.dart";

final FirebaseDatabase database = FirebaseDatabase.instance;

class Community extends StatefulWidget {
  @override
  _CommunityState createState() => _CommunityState();
}

class _CommunityState extends State<Community> {
  final FirebaseDatabase database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  DatabaseReference databaseReference;
  List<Board> boardMessages = List();
  Board board;

  @override
  void initState() {
    super.initState();
    board = Board("", "");
    databaseReference = database.reference().child("community_board");
    databaseReference.onChildAdded.listen(_onEntryAdded);
  }

  void _onEntryAdded(Event event) {
    setState(() {
      boardMessages.add(Board.fromSnapshot(event.snapshot));
    });
  }

  void handleSubmit() {
    FormState form = formKey.currentState;
    if (form.validate()) {
      form.save();
      form.reset();
      databaseReference.push().set(board.toJson());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text("Community"),
        centerTitle: true,
      ),
      body: new Column(
        children: <Widget>[
          Flexible(
            flex: 0,
            child: Form(
              key: formKey,
              child: Flex(
                direction: Axis.vertical,
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.subject),
                    title: TextFormField(
                      initialValue: "",
                      onSaved: (value) => board.subject = value,
                      validator: (value) => value == "" ? value : null,
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.message),
                    title: TextFormField(
                      initialValue: "",
                      onSaved: (value) => board.body = value,
                      validator: (value) => value == "" ? value : null,
                    ),
                  ),
                  FlatButton(
                    child: Text(
                      "Post",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.redAccent,
                    onPressed: () {
                      handleSubmit();
                    },
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: FirebaseAnimatedList(
              query: databaseReference,
              itemBuilder: (BuildContext context, DataSnapshot snapshot,
                  Animation<double> animation, int index) {
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(backgroundColor: Colors.redAccent,),
                    title: Text(boardMessages[index].subject),
                    subtitle: Text(boardMessages[index].body),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
