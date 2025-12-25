import 'package:sqflite/sqflite.dart';

import 'db_base.dart';

class DBFavoritesTable extends DBBaseTable {
  @override
  var db_table = 'favorites';
  
  static String sql_code = '''
    CREATE TABLE favorites (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER,
      event_id INTEGER,
      saved_at TEXT,
      UNIQUE(user_id, event_id)
    )
  ''';
}
