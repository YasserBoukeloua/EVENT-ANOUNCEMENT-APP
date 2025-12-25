import 'package:sqflite/sqflite.dart';

import 'db_base.dart';

class DBUsersTable extends DBBaseTable {
  @override
  var db_table = 'users';
  
  static String sql_code = '''
    CREATE TABLE users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      email TEXT UNIQUE,
      username TEXT UNIQUE,
      password TEXT,
      name TEXT,
      lastname TEXT,
      date_of_birth TEXT,
      is_certified INTEGER DEFAULT 0,
      photo TEXT,
      created_at TEXT
    )
  ''';
}
