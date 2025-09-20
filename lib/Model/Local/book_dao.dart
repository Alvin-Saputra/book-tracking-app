import 'package:book_tracker_app/Model/Local/book.dart';
import 'package:book_tracker_app/Model/Local/book_database.dart';
import 'package:sqflite/sqflite.dart';

class BookDao {
  final BookDatabase _db = BookDatabase.instance;

  Future<List<Book>> getBooksRecentlyAdded() async {
    final bookDB = await _db.database;

    List<Map> bookMaps = await bookDB.query(
      'books',
      orderBy: 'added_at DESC',
      limit: 5,
    );

    List<Book> listBook = List.generate(
      bookMaps.length,
      (index) => Book(
        id: bookMaps[index]['id'],
        title: bookMaps[index]['title'],
        author: bookMaps[index]['author'],
        genre: bookMaps[index]['genre'],
        totalPage: bookMaps[index]['total_page'],
        readingStatus: bookMaps[index]['reading_status'],
        progress: bookMaps[index]['progress'],
        addedAt: bookMaps[index]['added_at'],
        imageUrl: bookMaps[index]['image_url'],
        userId: bookMaps[index]['user_id'],
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
        genre: bookMaps[index]['genre'],
        totalPage: bookMaps[index]['total_page'],
        readingStatus: bookMaps[index]['reading_status'],
        progress: bookMaps[index]['progress'],
        addedAt: bookMaps[index]['added_at'],
        imageUrl: bookMaps[index]['image_url'],
        userId: bookMaps[index]['user_id'],
      ),
    );

    return listBook;
  }

  Future<List<Book>> getAllBooks() async {
    final bookDB = await _db.database;

    List<Map> bookMaps = await bookDB.query('books', orderBy: 'added_at DESC');

    List<Book> listBook = List.generate(
      bookMaps.length,
      (index) => Book(
        id: bookMaps[index]['id'],
        title: bookMaps[index]['title'],
        author: bookMaps[index]['author'],
        genre: bookMaps[index]['genre'],
        totalPage: bookMaps[index]['total_page'],
        readingStatus: bookMaps[index]['reading_status'],
        progress: bookMaps[index]['progress'],
        addedAt: bookMaps[index]['added_at'],
        imageUrl: bookMaps[index]['image_url'],
        userId: bookMaps[index]['user_id'],
      ),
    );

    return listBook;
  }

  Future<bool> addBook(Map<String, dynamic> bookMap) async {
    final bookDB = await _db.database;
    int rows = await bookDB.insert(
      'books',
      bookMap,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return rows > 0;
  }

  Future<bool> updateBook(String bookId, Map<String, dynamic> bookMap) async {
    final bookDB = await _db.database;
    int rowsAffected = await bookDB.update(
      'books',
      bookMap,
      where: 'id = ?',
      whereArgs: [bookId],
    );
    return rowsAffected > 0;
  }

  Future<bool> deleteBook(String bookId) async {
    final bookDB = await _db.database;
    int rowsAffected = await bookDB.delete(
      'books',
      where: 'id = ?',
      whereArgs: [bookId],
    );
    return rowsAffected > 0;
  }

  Future<bool> deleteAllBooks() async {
  final bookDB = await _db.database;
  try {
    await bookDB.delete('books'); 
    return true;
  } catch (e) {
    print("Error saat delete all books: $e");
    return false;
  }
}

  Future<bool> insertListOfBooks(List<Book> books) async {
    try {
      final bookDB = await _db.database;
      await bookDB.transaction((txn) async {
        Batch batch = txn.batch();
        for (var element in books) {
          Map<String, dynamic> taskMap = {
            'id': element.id,
            'title': element.title,
            'author': element.author,
            'genre': element.genre,
            'total_page': element.totalPage,
            'reading_status': element.readingStatus,
            'progress': element.progress,
            'added_at': element.addedAt,
            'image_url': element.imageUrl,
            'user_id': element.userId,
          };
          batch.insert('books', taskMap);
        }
        await batch.commit(noResult: true);
      });
      return true; // sukses
    } catch (e) {
      print("Error saat batch insert: $e");
      return false; // gagal
    }
  }
}
