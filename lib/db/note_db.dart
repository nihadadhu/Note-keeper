import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:note_keeper/model/note.dart';

class Databasehelper {
  static const _databaseName = 'notes.db';
  static const _databaseVersion = 1;

  static const tableNote = 'note_table';

  static const columnId = 'id';
  static const columnTitle = 'title';
  static const columnDes = 'description';
  static const columnPrio = 'priority';
  static const columnDate = 'date';

  Databasehelper._privateConstructor(); //private constructor

  static final Databasehelper instance =
      Databasehelper._privateConstructor(); //singleton instance

  static Database? _database;

  //getter for database
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  //function to initialize database

  Future<Database> _initDatabase() async {
    final dpPath = await getDatabasesPath();
    final path = join(dpPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _oncreate,
    );
  }

  //function to create table
  Future _oncreate(Database db, int version) async {
    await db.execute('''
   CREATE TABLE $tableNote(
   $columnId  INTEGER PRIMARY KEY AUTOINCREMENT,
   $columnTitle   TEXT NOT NULL,
   $columnDes TEXT,
  $columnPrio INTEGER,
  $columnDate TEXT
   )
''');
  }

  // insert data
  Future<int> insertNote(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(tableNote, row);
  }

  //read all data
  Future<List<NoteModel>> getNotes() async {
  final db = await database;
  final maps = await db.query(tableNote, orderBy: '$columnPrio ASC');

  return maps.map((map) => NoteModel.fromMap(map)).toList();
}


  //update data
  Future<int> updateNote(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row['id'];
    return await db.update(tableNote, row, where: '$columnId = ?', whereArgs: [id]);
  }

  //delete data
  Future<int> deleteNote(int id) async {
    Database db = await instance.database;
    return await db.delete(tableNote, where: '$columnId = ?', whereArgs: [id]);
  }
}
