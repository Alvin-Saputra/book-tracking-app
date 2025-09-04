import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class BookDatabase {
  static final BookDatabase instance = BookDatabase._init();
  static Database? _database;

  BookDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('book.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE books (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        author TEXT,
        genre TEXT,
        total_page INTEGER,
        progress INTEGER,
        reading_status TEXT,
        added_at TEXT,
        image_url TEXT
      )
    ''');

    // Prepopulate data
    await _prepopulateDB(db);
  }

  Future<void> _prepopulateDB(Database db) async {
    final String jsonString =
        await rootBundle.loadString('assets/data/books.json');
    final List<dynamic> jsonData = jsonDecode(jsonString);

    for (var item in jsonData) {
      await db.insert('books', {
        'title': item['title'],
        'author': item['author'],
        'genre': item['genre'],
        'total_page': item['total_page'],
        'progress': 0,
        'reading_status': item['reading_status'],
        'added_at': item['added_at'],
        'image_url': item['image_url'],
      });
    }
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
