import 'package:sqflite/sqflite.dart';

import 'db_service.dart';

class AuthStorage {
  Future<Database> get _db async => DbService.instance.database;

  Future<void> register({
    required String username,
    required String password,
  }) async {
    final db = await _db;
    await db.transaction((txn) async {
      await txn.delete('users');
      await txn.insert(
        'users',
        {
          'username': username,
          'password': password,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
  }

  Future<bool> login({
    required String username,
    required String password,
  }) async {
    final db = await _db;
    final result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
      limit: 1,
    );

    final ok = result.isNotEmpty;
    if (ok) {
      await db.insert(
        'session',
        {
          'id': 1,
          'username': username,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    return ok;
  }

  Future<String?> getLoggedInUsername() async {
    final db = await _db;
    final result = await db.query(
      'session',
      columns: ['username'],
      where: 'id = 1',
      limit: 1,
    );
    if (result.isEmpty) return null;
    return result.first['username'] as String?;
  }

  Future<void> clearLoggedInUser() async {
    final db = await _db;
    await db.delete('session', where: 'id = 1');
  }

  Future<String?> getRegisteredUsername() async {
    final db = await _db;
    final result = await db.query(
      'users',
      columns: ['username'],
      limit: 1,
    );
    if (result.isEmpty) return null;
    return result.first['username'] as String?;
  }
}
