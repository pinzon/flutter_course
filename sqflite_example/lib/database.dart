import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'dart:io';

class DatabaseHelper {
  // TABLE INFO
  final String tableUser = "userTable";
  final String columnId = "id";
  final String columnUsername = "username";
  final String columnPassword = "password";


  // INSTANCE CREATION
  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;
  
  static Database _db;

  // GETTER FOR DB
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  //INITIALIZE DATABESE
  Future<Database> initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "main.db");

    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDb;
  }

  // ON CREATE DB, DO:
  void _onCreate(Database db, int newVersion) async {
    await db.execute(
        "CREATE TABLE $tableUser($columnId INTEGER PRIMARY KEY, $columnUsername TEXT, $columnPassword TEXT )");
  }


  // CRUD

  // INSERTION
  Future<int> saveUser(User user) async {
    var dbClient = await db;
    int res =  await dbClient.insert(tableUser, user.toMap());
    return res;
  }

  // GET ALL USERS
  Future<List> getAllUsers() async {
    var dbClient = await db;
    var res =  await dbClient.rawQuery("SELECT * FROM $tableUser");
    return res.toList();
  }

  // GET COUNT OF ALL USERS
  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue( await dbClient.rawQuery("select count(*) from $tableUser"));
  }

  // GET ONE USER
  Future<User> getUser(int userId) async {
    var dbClient = await db;
    var res =  await dbClient.rawQuery("SELECT * FROM $tableUser where $columnId = $userId");
    return (res.length != 0)? new User.fromMap(res.first) : null;
  }

  // DELETE USER
  Future<int> deleteUser(int id) async {
    var dbClient = await db;
    return await dbClient.delete(tableUser, where : "$columnId = ?", whereArgs: [id]);
  }

  //UPDATE USER
  Future<int> updateUser(User user) async {
    var dbClient = await db;
    return await dbClient.update(tableUser, user.toMap(), where: "$columnId = ?", whereArgs: [user.id]);
  }

  // CLOSE DB
  Future close() async{
    var dbClient =  await db;
    return dbClient.close();
  }


}


class User {
  int _id;
  String _username;
  String _password;

  User(this._username, this._password);

  User.map(dynamic obj){
    this._username = obj['username'];
    this._password = obj['password'];
    this._id = obj['id'];
  }

  String get username => _username;
  String get password => _password;

  set username(String username) => {_username = username};
  set password(String password) => {_password = password};

  int get id => _id;

  Map<String, dynamic> toMap(){
    var map = new Map<String, dynamic>();
    map['username'] = _username;
    map['password'] = _password;
    if(_id != null){
      map['id'] = _id;
    }

    return map;
  }

  User.fromMap(Map<String, dynamic> map){
    this._username = map['username'];
    this._password = map['password'];
    this._id = map['id'];
  }

}
