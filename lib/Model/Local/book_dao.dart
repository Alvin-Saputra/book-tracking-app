import 'package:book_tracker_app/Model/Local/book.dart';
import 'package:book_tracker_app/Model/Local/book_database.dart';
import 'package:sqflite/sqflite.dart';

class BookDao {
  final BookDatabase _db = BookDatabase.instance;

  Future<List<Book>> getBooksRecentlyAdded() async {
    final bookDB = await _db.database;

    List<Map> bookMaps = await bookDB.query(
      'books',
      where: 'reading_status = ?', // <-- filter kolom
      whereArgs: ['not_started'], // <-- isi parameter
      orderBy: 'id DESC',
      limit: 5,
    );

    List<Book> listBook = List.generate(
      bookMaps.length,
      (index) => Book(
        id: bookMaps[index]['id'],
        title: bookMaps[index]['title'],
        author: bookMaps[index]['author'],
        genre: bookMaps[index]['author'],
        totalPage: bookMaps[index]['total_page'],
        readingStatus: bookMaps[index]['reading_status'],
        addedAt: bookMaps[index]['added_at'],
        imageUrl: bookMaps[index]['image_url'],
      ),
    );

    return listBook;
  }

  Future<List<Book>> getBooksCurrentlyRead() async {
    final bookDB = await _db.database;

    // List<Map<String, dynamic>> bookMaps = await bookDB.query(
    //   'books',
    //   where: 'reading_status = ?', // <-- filter kolom
    //   whereArgs: ['started'], // <-- isi parameter
    //   orderBy: 'id DESC',
    // );

    List<Map<String, dynamic>> bookMaps = await bookDB.rawQuery(
      "SELECT * FROM books WHERE reading_status == 'started' ORDER BY id DESC LIMIT 3",
    );

    List<Book> listBook = List.generate(
      bookMaps.length,
      (index) => Book(
        id: bookMaps[index]['id'],
        title: bookMaps[index]['title'],
        author: bookMaps[index]['author'],
        genre: bookMaps[index]['author'],
        totalPage: bookMaps[index]['total_page'],
        readingStatus: bookMaps[index]['reading_status'],
        addedAt: bookMaps[index]['added_at'],
        imageUrl: bookMaps[index]['image_url'],
      ),
    );

    return listBook;
  }

  Future<List<Book>> getAllBooks() async {
    final bookDB = await _db.database;

    List<Map> bookMaps = await bookDB.query('books', orderBy: 'id DESC');

    List<Book> listBook = List.generate(
      bookMaps.length,
      (index) => Book(
        id: bookMaps[index]['id'],
        title: bookMaps[index]['title'],
        author: bookMaps[index]['author'],
        genre: bookMaps[index]['author'],
        totalPage: bookMaps[index]['total_page'],
        readingStatus: bookMaps[index]['reading_status'],
        addedAt: bookMaps[index]['added_at'],
        imageUrl: bookMaps[index]['image_url'],
      ),
    );

    return listBook;
  }

  Future<int> addTask(Map<String, dynamic> bookMap) async {
    final bookDB = await _db.database;
    return bookDB.insert(
      'books',
      bookMap,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<bool> updateTask(String bookId, Map<String, dynamic> bookMap) async {
    final bookDB = await _db.database;
    int rowsAffected = await bookDB.update(
      'books',
      bookMap,
      where: 'id = ?',
      whereArgs: [bookId],
    );
    return rowsAffected > 0;
  }
}
