import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:instagram_story_animation/models/person.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper with ChangeNotifier{
  static DatabaseHelper _databaseHelper;
  static Database _database;

  DatabaseHelper._namedConstructor();
  static String _dbFileName = "animationWork.db";
  static int _dbVersion = 1;
  static String _personTableName = "person";

  factory DatabaseHelper() {
    // Singleton Design Structure  - For multiple use of a single Object
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._namedConstructor();
      return _databaseHelper;
    } else {
      return _databaseHelper;
    }
  }

  Future<Database> _getDatabase() async {
    // Singleton Design Structure  - For multiple use of a single Object
    if (_database == null) {
      _database = await _initializeDatabase();
      return _database;
    } else {
      return _database;
    }
  }

  _initializeDatabase() async {
    var databasePath = await getDatabasesPath();
    var path = join(databasePath, _dbFileName);
    bool exists = await databaseExists(path);
    if (!exists) {
      // exists == false
      try {
        print("Trying to create a new database cause it doesn\'t exist.");
        await Directory(dirname(path)).create(recursive: true);
      } catch (error) {
        print('Database could not be created at path $path');
        print("Error is : $error");
      }

      ByteData data = await rootBundle.load(join("assets", _dbFileName));
      List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Database exists.");
    }

    return await openDatabase(path, version: _dbVersion, readOnly: false);
  }


  Future<List<Map<String, dynamic>>> getPersonTable() async {
    var db = await _getDatabase();
    var result = db.query(_personTableName,orderBy: "personID DESC");
    return result;
  }


  Future<List<Person>> getAllPersonsList() async {
    List<Map<String, dynamic>> listOfMapsOfPersonFromDatabase = await getPersonTable();
    var allPersonObjectsList = List<Person>();
    for (Map personMap in listOfMapsOfPersonFromDatabase) {
      allPersonObjectsList.add(Person.fromMap(personMap));
    }
    return allPersonObjectsList;
  }

  // ADD Person to DB

  Future<int> addPersonToPersonTableAtDb(Person person) async {
    var db = await _getDatabase();
    var result = await db.insert(_personTableName, person.personToMap());
    notifyListeners();
    return result;
  }

  // UPDATE Person at DB

  Future<int> updatePersonAtDb(Person personToUpdate) async {
    var db = await _getDatabase();
    var result = await db.update(_personTableName, personToUpdate.personToMap(),
        where: "personID = ?", whereArgs: [personToUpdate.personID]);
    notifyListeners();
    return result;
  }

  // DELETE Person from DB

  Future<int> deletePersonFromDb(int personID) async {
    var db = await _getDatabase();
    var result = db
        .delete(_personTableName, where: "personID = ?", whereArgs: [personID]);
    notifyListeners();
    return result;
  }
}
