import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

class DbService {
  DbService._();

  static final DbService instance = DbService._();

  Database? _database;

  Future<Database> get database async {
    final db = _database;
    if (db != null) return db;
    final created = await _open();
    _database = created;
    return created;
  }

  Future<Database> _open() async {
    final dbPath = await getDatabasesPath();
    final fullPath = path.join(dbPath, 'spaceflight_news.db');
    return openDatabase(
      fullPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT UNIQUE, password TEXT)',
        );
        await db.execute(
          'CREATE TABLE session(id INTEGER PRIMARY KEY CHECK (id = 1), username TEXT)',
        );
      },
    );
  }
}
