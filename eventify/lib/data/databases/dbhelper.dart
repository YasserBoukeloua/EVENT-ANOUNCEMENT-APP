import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'db_users.dart';
import 'db_events.dart';
import 'db_favorites.dart';
import 'db_comments.dart';
import 'db_repost.dart';

class DBHelper {
  static const _database_name = "EventifyDB.db";
  static const _database_version = 4; // CHANGE FROM 3 TO 4
  static Database? database;

  static List<String> sql_codes = [
    DBUsersTable.sql_code,
    DBEventsTable.sql_code,
    DBFavoritesTable.sql_code,
    DBCommentsTable.sql_code,
    DBRepostsTable.sql_code,
    DBRepostsTable.sql_repost_likes, // NEW
  ];

  static Future<Database> getDatabase() async {
    if (database != null) {
      return database!;
    }

    database = await openDatabase(
      join(await getDatabasesPath(), _database_name),
      onCreate: (db, version) {
        for (var sqlCode in sql_codes) {
          db.execute(sqlCode);
        }
      },
      version: _database_version,
      onUpgrade: (db, oldVersion, newVersion) {
        // Add comments table for users upgrading from version 1
        if (oldVersion < 2) {
          db.execute(DBCommentsTable.sql_code);
        }
        // Add reposts table for users upgrading from version 2
        if (oldVersion < 3) {
          db.execute(DBRepostsTable.sql_code);
        }
        // Add repost_likes table for users upgrading from version 3
        if (oldVersion < 4) { // ADD THIS - NEW MIGRATION
          db.execute(DBRepostsTable.sql_repost_likes);
        }
      },
    );
    return database!;
  }
}