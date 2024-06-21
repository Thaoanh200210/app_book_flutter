import '../../models/cart_item.dart';
import '../../models/book.dart';
import 'package:flutter/foundation.dart';
import '../../services/carts_service.dart';
import '../../models/auth_token.dart';

class CartManager with ChangeNotifier {
  Map<String, CartItem> _items = {};

  final CartService _cartService;

  CartManager([AuthToken? authToken]) : _cartService = CartService(authToken);

  set authToken(AuthToken? authToken) {
    _cartService.authToken = authToken;
  }

  Future<void> fetchCart() async {
    _items = await _cartService.getCart();
  }

  Future<String?> addItem(Book book, [int quantity = 1]) async {
    if (book.quantity == 0) return 'Sách đã bán hết';
    else if (book.quantity < quantity) return 'Số lượng Sách không đủ';

    final newItem = CartItem(
        id: book.id,
        title: book.title,
        imageUrl: book.imageUrl,
        quantity: quantity,
        price: book.price);

    if (await _cartService.addItem(book.id!, newItem)) {
      _items.putIfAbsent(book.id!, () => newItem);
    }

    notifyListeners();
    return null;
  }

  Future<void> updateItem(String bookId, int quantity) async {
    if (_items.containsKey(bookId)) {
      if (await _cartService.updateItem(bookId, quantity)) {
        _items.update(
          bookId,
          (existingCartItem) => existingCartItem.copyWith(
            quantity: quantity,
          ),
        );
      }
    }
    notifyListeners();
  }

  Future<void> removeItem(String bookId) async {
    if (!_items.containsKey(bookId)) {
      return;
    }
    if (_items[bookId]?.quantity as num > 1) {
      if (await _cartService.updateItem(bookId, _items[bookId]!.quantity - 1)) {
        _items.update(
          bookId,
          (existingCartItem) => existingCartItem.copyWith(
            quantity: existingCartItem.quantity - 1,
          ),
        );
      }
    } else {
      if (await _cartService.removeItem(bookId)) _items.remove(bookId);
    }

    notifyListeners();
  }

  Future<void> clearItem(String bookId) async {
    if (await _cartService.removeItem(bookId)) {
      _items.remove(bookId);
      notifyListeners();
    }
  }

  Future<void> clearAllItem() async {
    if (await _cartService.clearCart()) {
      _items.clear();
      notifyListeners();
    }
  }

  Map<String, DateTime?> statusCheckOut() {
    return {'checkout': DateTime.now(), 'shipping': null, 'received': null};
  }

  int get bookCount {
    return _items.length;
  }

  List<CartItem> get books {
    List<CartItem> list = [];

    for (var key in _items.keys) {
      list.add(_items[key]!.copyWith(id: key));
    }

    return list;
  }

  Iterable<MapEntry<String, CartItem>> get bookEntries {
    return {..._items}.entries;
  }

  int getQuantityInCart(String bookId) {
    return _items[bookId]?.quantity ?? 1;
  }

  int get totalAmount {
    var total = 0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });

    return total;
  }
}
// class CartManager with ChangeNotifier {
//   final Map<String, CartItem> _items = {
//     'p1': CartItem(
//       id: 'c1',
//       title: 'Red Shirt',
//       imageUrl:
//           'http://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
//       price: 29.99,
//       quantity: 2,
//     ),
//   };

//   int get bookCount {
//     return _items.length;
//   }

//   List<CartItem> get books {
//     return _items.values.toList();
//   }

//   Iterable<MapEntry<String, CartItem>> get bookEntries {
//     return {..._items}.entries;
//   }

//   double get totalAmount {
//     var total = 0.0;
//     _items.forEach((key, cartItem) {
//       total += cartItem.price * cartItem.quantity;
//     });
//     return total;
//   }

//   void addItem(Book book) {
//     if (_items.containsKey(book.id)) {
//       _items.update(
//         book.id!,
//         (existingCartItem) => existingCartItem.copyWith(
//           quantity: existingCartItem.quantity + 1,
//         ),
//       );
//     } else {
//       _items.putIfAbsent(
//         book.id!,
//         () => CartItem(
//           id: 'c${DateTime.now().toIso8601String()}',
//           title: book.title,
//           imageUrl: book.imageUrl,
//           price: book.price,
//           quantity: 1,
//         ),
//       );
//     }
//     notifyListeners();
//   }

//   void removeItem(String bookId) {
//     if (!_items.containsKey(bookId)) {
//       return;
//     }
//     if (_items[bookId]?.quantity as num > 1) {
//       _items.update(
//         bookId,
//         (existingCartItem) => existingCartItem.copyWith(
//           quantity: existingCartItem.quantity - 1,
//         ),
//       );
//     } else {
//       _items.remove(bookId);
//     }
//     notifyListeners();
//   }

//   void clearItem(String bookId) {
//     _items.remove(bookId);
//     notifyListeners();
//   }

//   void clearAllItems() {
//     _items.clear();
//     notifyListeners();
//   }
// }
