// lib/Controller/book_controller.dart

import 'dart:math';

import 'package:flutter/material.dart';
import '../Model/Local/book.dart';
import '../Model/Local/book_dao.dart';

class BookController with ChangeNotifier {
  final BookDao _bookDao;

  BookController(this._bookDao);

  List<Book> _books = [];
  List<Book> get books => _books;


  // ✅ GETTER BARU UNTUK BUKU YANG BARU DITAMBAHKAN
  List<Book> get recentlyAddedBooks {
    // Diasumsikan buku baru memiliki ID yang lebih tinggi
    var sortedBooks = List<Book>.from(_books)..sort((a, b) => b.id!.compareTo(a.id!));
    // Ambil 5 buku teratas, atau kurang jika total buku kurang dari 5
    return sortedBooks.sublist(0, min(5, sortedBooks.length));
  }

  // ✅ GETTER BARU UNTUK BUKU YANG SEDANG DIBACA
  List<Book> get currentlyReadBooks {
    var filteredBooks = _books.where((book) => book.readingStatus == 'started').toList();
    // Urutkan berdasarkan yang terbaru juga
    filteredBooks.sort((a, b) => b.id!.compareTo(a.id!));
    // Ambil 3 buku teratas, atau kurang jika hasilnya kurang dari 3
    return filteredBooks.sublist(0, min(3, filteredBooks.length));
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Mengambil semua buku
  Future<void> fetchBooks() async {
    _setLoading(true);
    _books = await _bookDao.getAllBooks();
    _setLoading(false);
  }

  // Menambah buku
  Future<int> addBook(Map<String, dynamic> bookMap) async {
    int row = await _bookDao.addBook(bookMap);
    await fetchBooks(); // Muat ulang daftar buku setelah menambah
    return row;
  }

  // Menghapus buku
  Future<bool> deleteBook(int id) async {
    bool isSuccess = await _bookDao.deleteBook(id);
    await fetchBooks(); // Muat ulang daftar buku setelah menghapus
    return isSuccess;
  }

    // Menghapus buku
  Future<bool> updateBook(int id, Map<String, dynamic> bookMap) async {
    bool isSuccess = await _bookDao.updateBook(id, bookMap);
    await fetchBooks(); // Muat ulang daftar buku setelah menghapus
    return isSuccess;
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners(); // Memberi tahu listener (UI) bahwa ada perubahan
  }
}