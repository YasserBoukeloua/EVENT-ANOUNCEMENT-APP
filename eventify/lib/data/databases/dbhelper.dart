import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'db_users.dart';
import 'db_events.dart';
import 'db_favorites.dart';
import 'db_comments.dart';
import 'db_repost.dart';
import 'db_notifications.dart';

class DBHelper {
  static const _database_name = "EventifyDB.db";
  static const _database_version = 7;
  static Database? database;

  static List<String> sql_codes = [
    DBUsersTable.sql_code,
    DBEventsTable.sql_code,
    DBFavoritesTable.sql_code,
    DBCommentsTable.sql_code,
    DBRepostsTable.sql_code,
    DBRepostsTable.sql_repost_likes,
    DBRepostsTable.sql_repost_comments,
    DBNotificationsTable.sql_code,
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
        if (oldVersion < 2) {
          db.execute(DBCommentsTable.sql_code);
        }
        if (oldVersion < 3) {
          db.execute(DBRepostsTable.sql_code);
        }
        if (oldVersion < 4) {
          db.execute(DBRepostsTable.sql_repost_likes);
        }
        if (oldVersion < 5) {
          db.execute(DBRepostsTable.sql_repost_comments);
        }
        if (oldVersion < 6) {
          db.execute('ALTER TABLE events ADD COLUMN registration_link TEXT');
        }
        if (oldVersion < 7) {
          db.execute(DBNotificationsTable.sql_code);
        }
      },
    );
    return database!;
  }
}
