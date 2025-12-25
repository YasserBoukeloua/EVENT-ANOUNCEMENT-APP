import 'package:sqflite/sqflite.dart';

import 'db_base.dart';

class DBEventsTable extends DBBaseTable {
  @override
  var db_table = 'events';
  
  static String sql_code = '''
    CREATE TABLE events (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT,
      description TEXT,
      date TEXT,
      location TEXT,
      category TEXT,
      publisher TEXT,
      is_free INTEGER DEFAULT 1,
      photo_path TEXT,
      created_at TEXT
    )
  ''';
}
