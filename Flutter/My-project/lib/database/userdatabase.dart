import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const String _dbName = "user_database.db";
  static const String _tableName = "users";
  static const int _dbVersion = 1;

  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        firstName TEXT NOT NULL,
        lastName TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        number TEXT NOT NULL UNIQUE,
        dob TEXT NOT NULL,
        age INTEGER NOT NULL,
        city TEXT NOT NULL,
        gender INTEGER NOT NULL,
        hobbies TEXT NOT NULL,
        password TEXT NOT NULL,
        confirmPassword TEXT NOT NULL,
        isLiked INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }

  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    user['hobbies'] = jsonEncode(user['hobbies']);

    try {
      return await db.insert(_tableName, user);
    } catch (e) {
      print("Database insert error: $e");
      return -1;
    }
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> users = await db.query('users');
    return List<Map<String, dynamic>>.from(users);
  }

  Future<int> updateUser(int id, Map<String, dynamic> user) async {
    final db = await database;
    try {
      user['hobbies'] = jsonEncode(user['hobbies']);
      int result = await db.update(
        _tableName,
        user,
        where: 'id = ?',
        whereArgs: [id],
      );
      print("Database update result: $result");
      return result;
    } catch (e) {
      print("Database update error: $e");
      return 0;
    }
  }


  Future<int> deleteUser(int id) async {
    final db = await database;
    return await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<Map<String, dynamic>?> getUserById(int id) async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (results.isNotEmpty) {
      results[0]['hobbies'] = jsonDecode(results[0]['hobbies']);
      return results.first;
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> searchUsers(String query) async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.query(
      _tableName,
      where: 'firstName LIKE ? OR lastName LIKE ? OR city LIKE ? OR email LIKE ? OR number LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%', '%$query%', '%$query%'],
    );

    for (var user in results) {
      user['hobbies'] = jsonDecode(user['hobbies']);
    }

    return results;
  }

  Future<int> updateUserLikeStatus(int id, int isLiked) async {
    final db = await database;
    return await db.update(
      _tableName,
      {'isLiked': isLiked},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

}
