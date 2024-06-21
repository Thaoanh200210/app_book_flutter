import '../../models/book.dart';
import '../../models/auth_token.dart';
import 'package:flutter/foundation.dart';
import '../../models/cart_item.dart';
import '../../services/books_service.dart';

class BooksManager with ChangeNotifier {
  List<Book> _items = [];

  int get itemCount {
    return _items.length;
  }

  List<Book> get items {
    return [..._items];
  }

  List<Book> get favoriteItems {
    return _items.where((item) => item.isFavorite).toList();
  }

  Book? findById(String id) {
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (error) {
      return null;
    }
  }

  final BooksService _booksService;
  BooksManager([AuthToken? authToken])
      : _booksService = BooksService(authToken);

  set authToken(AuthToken? authToken) {
    _booksService.authToken = authToken;
  }

  Future<void> fetchBooks() async {
    _items = await _booksService.fetchBooks();
    notifyListeners();
  }

  Future<void> fetchUserBooks() async {
    _items = await _booksService.fetchBooks(
      filteredByUser: true,
    );
    notifyListeners();
  }

  Future<void> addBook(Book book) async {
    final newBook = await _booksService.addBook(book);
    if (newBook != null) {
      _items.add(newBook);
      notifyListeners();
    }
  }

  Future<List<Book>> searchBooksByName(String name) async {
    try {
      return await _booksService.searchBooksByName(name);
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<void> updateBook(Book book) async {
    final index = _items.indexWhere((item) => item.id == book.id);
    if (index >= 0) {
      if (await _booksService.updateBook(book)) {
        _items[index] = book;
        notifyListeners();
      }
    }
  }

  Future<void> deleteBook(String id) async {
    final index = _items.indexWhere((item) => item.id == id);
    Book? existingBook = _items[index];
    _items.removeAt(index);
    notifyListeners();

    if (!await _booksService.deleteBook(id)) {
      _items.insert(index, existingBook);
      notifyListeners();
    }
  }

  Future<void> toggleFavoriteStatus(Book book) async {
    final saveStatus = book.isFavorite;
    book.isFavorite = !saveStatus;

    if (!await _booksService.saveFavoriteStatus(book)) {
      book.isFavorite = saveStatus;
    }
  }

  String? checkingStock(List<CartItem> cart) {
    for (var item in cart) {
      final book = _items.firstWhere((element) => element.id == item.id);
      if (book.quantity < item.quantity) {
        return book.title;
      }
    }

    return null;
  }
  Future<void> updateStore(List<CartItem> cart) async {
    await Future.wait(
      [
        for (var item in cart) updateQuantity(item.id!, item.quantity),
      ],
    ).catchError((error) {
      print('Error: $error');
    });
  }
  Future<void> updateQuantity(String id, int quantity) async {
    final index = _items.indexWhere((item) => item.id == id);

    if (index >= 0) {
      Book existingProduct =
      _items[index].copyWith(quantity: _items[index].quantity - quantity);
      if (!await _booksService.updateBook(existingProduct)) {
        _items[index] = existingProduct;
        notifyListeners();
      }
    }
  }
  // void addBook(Book book) {
  //   _items.add(
  //     book.copyWith(
  //       id: 'p${DateTime.now().toIso8601String()}',
  //     ),
  //   );
  //   notifyListeners();
  // }

  // void updateBook(Book book) {
  //   final index = _items.indexWhere((item) => item.id == book.id);
  //   if (index >= 0) {
  //     _items[index] = book;
  //     notifyListeners();
  //   }
  // }

  // void toggleFavoriteStatus(Book book) {
  //   final saveStatus = book.isFavorite;
  //   book.isFavorite = !saveStatus;
  // }

  // void deleteBook(String id) {
  //   final index = _items.indexWhere((item) => item.id == id);
  //   _items.removeAt(index);
  //   notifyListeners();
  // }
}
