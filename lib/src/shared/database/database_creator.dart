import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Database db;

class DatabaseCreator {
  static const String predictionTable = 'predictionTable';
  static const String description = 'description';
  static const String id = 'id';
  static const String placeId = 'placeId';
  static const String reference = 'reference';
  static const String phoneNumber = 'phoneNumber';
  static const String name = 'name';
  static const String latitude = 'latitude';
  static const String longitude = 'longitude';
  static const String position = 'position';


  static void databaseLog(String functionName, String sql,
      [List<Map<String, dynamic>> selectQueryResult,
      int insertAndUpdateQueryResult]) {
    print(functionName);
    print(sql);
    if (selectQueryResult != null) {
      print('selecteQuery result is empty => ${selectQueryResult}');
    } else if (insertAndUpdateQueryResult != null) {
      print(insertAndUpdateQueryResult);
    }
  }

  Future<void> createPredictionTable(Database db) async {
    final preditcionSql = '''CREATE TABLE $predictionTable
    (
      $id TEXT PRIMARY KEY,
      $description TEXT,
      $placeId TEXT,
      $reference TEXT,
      $phoneNumber TEXT,
      $name TEXT,
      $latitude TEXT,
      $longitude TEXT
    )
    ''';

    await db.execute(preditcionSql);
  }

  Future<String> getDatabasePath(String dbName) async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, dbName);

    if (await Directory(dirname(path)).exists()) {
      //await deleteDatabase(path)
    } else {
      await Directory(dirname(path)).create(recursive: true);
    }
    return path;
  }

  Future<void> initDatabase() async {
    final path = await getDatabasePath('prediction_db');
    db = await openDatabase(path, version: 2, onCreate: onCreate);
    print(db);
  }

  Future<void> onCreate(Database db, int version) async  {
    await createPredictionTable(db);
  }
}
