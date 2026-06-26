import 'dart:async';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';

class AppDatabase {
  Database? _database;

  Future<Database> get instance async {
    final database = _database;
    if (database != null) {
      return database;
    }

    final directory = await getApplicationSupportDirectory();
    final path = p.join(directory.path, 'travel_map.sqlite');
    final opened = sqlite3.open(path)
      ..execute('PRAGMA journal_mode = WAL;')
      ..execute('PRAGMA foreign_keys = ON;')
      ..execute('''
        CREATE TABLE IF NOT EXISTS users (
          id INTEGER PRIMARY KEY,
          name TEXT NOT NULL,
          username TEXT NOT NULL,
          email TEXT NOT NULL,
          phone TEXT NOT NULL,
          website TEXT NOT NULL,
          company TEXT NOT NULL,
          city TEXT NOT NULL,
          updated_at INTEGER NOT NULL
        );
      ''')
      ..execute('''
        CREATE TABLE IF NOT EXISTS trips (
          id INTEGER PRIMARY KEY,
          title TEXT NOT NULL,
          owner_user_id INTEGER NOT NULL,
          status TEXT NOT NULL,
          updated_at INTEGER NOT NULL
        );
      ''');

    _database = opened;
    return opened;
  }

  void close() {
    _database?.dispose();
    _database = null;
  }
}
