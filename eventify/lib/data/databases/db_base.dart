import 'package:sqflite/sqflite.dart';

import 'dbhelper.dart';

class DBBaseTable {
  var db_table = 'TABLE_NAME_MUST_OVERRIDE';

  Future<bool> insertRecord(Map<String, dynamic> data) async {
    try {
      final database = await DBHelper.getDatabase();
      await database.insert(
        db_table,
        data,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return true;
    } catch (e, stacktrace) {
      print('$e --> $stacktrace');
    }
    return false;
  }

  Future<List<Map<String, dynamic>>> getRecords() async {
    try {
      final database = await DBHelper.getDatabase();
      var data = await database.rawQuery(
        "SELECT * FROM $db_table ORDER BY id DESC",
      );
      return data;
    } catch (e, stacktrace) {
      print('$e --> $stacktrace');
    }
    return [];
  }

  Future<Map<String, dynamic>?> getRecordById(int id) async {
    try {
      final database = await DBHelper.getDatabase();
      var data = await database.rawQuery(
        "SELECT * FROM $db_table WHERE id = ?",
        [id],
      );
      if (data.isNotEmpty) {
        return data.first;
      }
    } catch (e, stacktrace) {
      print('$e --> $stacktrace');
    }
    return null;
  }

  Future<bool> updateRecord(int id, Map<String, dynamic> data) async {
    try {
      final database = await DBHelper.getDatabase();
      await database.update(
        db_table,
        data,
        where: 'id = ?',
        whereArgs: [id],
      );
      return true;
    } catch (e, stacktrace) {
      print('$e --> $stacktrace');
    }
    return false;
  }

  Future<bool> deleteRecord(int id) async {
    try {
      final database = await DBHelper.getDatabase();
      await database.delete(
        db_table,
        where: 'id = ?',
        whereArgs: [id],
      );
      return true;
    } catch (e, stacktrace) {
      print('$e --> $stacktrace');
    }
    return false;
  }
}
