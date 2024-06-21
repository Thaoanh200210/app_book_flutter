import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/auth_token.dart';
import 'dart:convert';
import '../models/book.dart';
import 'firebase_service.dart';

class BooksService extends FirebaseService {
  BooksService([AuthToken? authToken]) : super(authToken);

  Future<List<Book>> fetchBooks({bool filteredByUser = false}) async {
    final List<Book> books = [];
    try {
      final filters =
          filteredByUser ? 'orderBy = "creatorId"&equalTo = "$userId"' : '';

      final booksMap = await httpFetch(
        '$databaseUrl/books.json?auth=$token&$filters',
      ) as Map<String, dynamic>?;

      final userFavoritesMap = await httpFetch(
        '$databaseUrl/userFavorites/$userId.json?auth=$token',
      ) as Map<String, dynamic>?;

      booksMap?.forEach((bookId, book) {
        final isFavorite = (userFavoritesMap == null)
            ? false
            : (userFavoritesMap[bookId] ?? false);
        books.add(
          Book.fromJson({
            'id': bookId,
            ...book,
          }).copyWith(isFavorite: isFavorite),
        );
      });
      return books;
    } catch (e) {
      print(e);
      return books;
    }
  }



  Future<List<Book>> searchBooksByName(String name) async {
    final List<Book> searchResults = [];
    try {
      final booksMap = await httpFetch('$databaseUrl/books.json?auth=$token')
          as Map<String, dynamic>?;

      if (booksMap != null) {
        booksMap.forEach((bookId, book) {
          final Book currentBook = Book.fromJson({
            'id': bookId,
            ...book,
          });
          if (currentBook.title.toLowerCase().contains(name.toLowerCase())) {
            searchResults.add(currentBook);
          }
        });
      }
    } catch (e) {
      print(e);
    }
    return searchResults;
  }

  Future<Book?> addBook(Book book) async {
    try {
      final newBook = await httpFetch(
        '$databaseUrl/books.json?auth=$token',
        method: HttpMethod.post,
        body: jsonEncode(
          book.toJson()
            ..addAll({
              'creatorId': userId,
            }),
        ),
      ) as Map<String, dynamic>?;
      return book.copyWith(
        id: newBook!['name'],
      );
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<bool> updateBook(Book book) async {
    try {
      await httpFetch(
        '$databaseUrl/books/${book.id}.json?auth=$token',
        method: HttpMethod.patch,
        body: jsonEncode(book.toJson()),
      );
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> deleteBook(String id) async {
    try {
      await httpFetch(
        '$databaseUrl/books/$id.json?auth=$token',
        method: HttpMethod.delete,
      );
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> saveFavoriteStatus(Book book) async {
    try {
      await httpFetch(
        '$databaseUrl/userFavorites/$userId/${book.id}.json?auth=$token',
        method: HttpMethod.put,
        body: jsonEncode(book.isFavorite),
      );
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
