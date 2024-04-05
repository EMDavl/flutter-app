import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static Database? _db = null;

  Future<Database> get db async{
    if(_db != null){
      return _db!;
    }
    _db = await initDb();
    return _db!;
  }

  initDb() async{
    WidgetsFlutterBinding.ensureInitialized();
    var db = await openDatabase(
      join(await getDatabasesPath(), 'another-new.db'),
      onCreate: _onCreate,
      version: 2,
      onUpgrade: _onUpgrade,
    );
    return db;
  }

  _onCreate(Database db, int version) async{
    await db.execute(
        'CREATE TABLE IF NOT EXISTS posts(id INTEGER PRIMARY KEY autoincrement, title text not null, text TEXT not null, favorite text default \'false\')');
    await db.execute(
        'CREATE TABLE IF NOT EXISTS medias(id INTEGER PRIMARY KEY autoincrement, link TEXT not null, type TEXT not null, post_id int not null, foreign key (post_id) REFERENCES posts(id))');
  }


  _onUpgrade(Database db, int oldVersion, int newVersion) {
    if (oldVersion < newVersion) {
      db.execute('ALTER TABLE posts ADD COLUMN latitude text');
      db.execute('ALTER TABLE posts ADD COLUMN longitude text');
    }
  }
}