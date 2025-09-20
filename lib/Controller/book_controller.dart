// lib/Controller/book_controller.dart
import 'dart:io';
import 'dart:math';

import 'package:book_tracker_app/Model/remote/book_api_service.dart';
import 'package:flutter/material.dart';
import '../Model/Local/book.dart';
import '../Model/Local/book_dao.dart';

class BookController with ChangeNotifier {
  final BookDao _bookDao;

  BookController(this._bookDao);

  List<Book> _books = [];
  List<Book> get books => _books;

  List<Book> get recentlyAddedBooks {
    var sortedBooks = List<Book>.from(_books)
      ..sort((a, b) => b.id!.compareTo(a.id!));
    return sortedBooks.sublist(0, min(5, sortedBooks.length));
  }

  List<Book> get currentlyReadBooks {
    var filteredBooks = _books
        .where((book) => book.readingStatus == 'started')
        .toList();
    filteredBooks.sort((a, b) => b.id!.compareTo(a.id!));
    return filteredBooks.sublist(0, min(3, filteredBooks.length));
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Mengambil semua buku
  Future<void> fetchBooks([String? userId]) async {
    _setLoading(true);
    _books = await _bookDao.getAllBooks();
    if (_books.isEmpty) {
      if (userId != null) {
        List<Book> booksFromFirebase = await getBooksRemote(userId!);
        if (booksFromFirebase.isNotEmpty) {
          bool isSuccess = await _bookDao.insertListOfBooks(booksFromFirebase);
          if (isSuccess) {
            _books = await _bookDao.getAllBooks();
            notifyListeners();
          }
        } else {
          _setLoading(false);
          return;
        }
      } else {
        _setLoading(false);
        return;
      }
    }
    _setLoading(false);
  }

  Future<bool> deleteAllBooks() async {
   bool isSuccess =  await _bookDao.deleteAllBooks();
   return isSuccess;
  }

  Future<bool> addBook(Map<String, dynamic> bookMap) async {
    _setLoading(true);
    try {
      Map<String, dynamic> dataMap = bookMap;
      String imageUrl = await uploadImage(File(dataMap['image_url']));
      dataMap['image_url'] = imageUrl;

      bool addedToRemote = await addBookRemote(dataMap);
      bool addedToLocal = false;
      if (addedToRemote) {
        addedToLocal = await _bookDao.addBook(dataMap);
      }
      await fetchBooks();
      _setLoading(false);
      return addedToLocal;
    } catch (e) {
      _setLoading(false);
      rethrow;
    }
  }

  // Menghapus buku
  Future<bool> deleteBook(String userId, String bookId) async {
    _setLoading(true);
    try {
      bool isRemoveFromRemote = await deleteBookRemote(userId, bookId);
      bool isremoveFromLocal = false;
      if (isRemoveFromRemote) {
        isremoveFromLocal = await _bookDao.deleteBook(bookId);
      }
      await fetchBooks();
      _setLoading(false);
      return isremoveFromLocal;
    } catch (e) {
      _setLoading(false);
      rethrow;
    }
  }

  // Menghapus buku
  Future<bool> updateBook(
    String userId,
    String bookId,
    Map<String, dynamic> bookMap,
  ) async {
    _setLoading(true);
    try {
      if (bookMap.containsKey('image_url')) {
        Map<String, dynamic> dataMap = bookMap;
        String imageUrl = await uploadImage(File(dataMap['image_url']));
        dataMap['image_url'] = imageUrl;

        bool updatedOnRemote = await updateBookRemote(userId, bookId, dataMap);
        bool updatedOnLocal = false;
        if (updatedOnRemote) {
          updatedOnLocal = await _bookDao.updateBook(bookId, dataMap);
        }
        await fetchBooks();
        _setLoading(false);
        return updatedOnLocal;
      } else {
        bool updatedOnRemote = await updateBookRemote(userId, bookId, bookMap);
        bool updatedOnLocal = false;
        if (updatedOnRemote) {
          updatedOnLocal = await _bookDao.updateBook(bookId, bookMap);
        }
        await fetchBooks();
        _setLoading(false);
        return updatedOnLocal;
      }
    } catch (e) {
      _setLoading(false);
      rethrow;
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
