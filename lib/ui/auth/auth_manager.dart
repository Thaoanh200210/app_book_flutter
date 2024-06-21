// import 'dart:async';
//
// import 'package:flutter/foundation.dart';
//
// import '../../models/auth_token.dart';
// import '../../services/auth_service.dart';
//
// class AuthManager with ChangeNotifier {
//   AuthToken? _authToken;
//   Timer? _authTimer;
//
//   final AuthService _authService = AuthService();
//
//   bool get isAuth {
//     return authToken != null && authToken!.isValid;
//   }
//
//   AuthToken? get authToken {
//     return _authToken;
//   }
//
//   void _setAuthToken(AuthToken token) {
//     _authToken = token;
//     print(token);
//     _autoLogout();
//     notifyListeners();
//   }
//
//   Future<void> signup(String email, String password) async {
//     _setAuthToken(await _authService.signup(email, password));
//   }
//
//   Future<void> login(String email, String password) async {
//     _setAuthToken(await _authService.login(email, password));
//   }
//
//   Future<bool> tryAutoLogin() async {
//     final savedToken = await _authService.loadSavedAuthToken();
//     if (savedToken == null) {
//       return false;
//     }
//
//     _setAuthToken(savedToken);
//     return true;
//   }
//
//   Future<void> logout() async {
//     _authToken = null;
//     if (_authTimer != null) {
//       _authTimer!.cancel();
//       _authTimer = null;
//     }
//     notifyListeners();
//     _authService.clearSavedAuthToken();
//   }
//
//   void _autoLogout() {
//     if (_authTimer != null) {
//       _authTimer!.cancel();
//     }
//     final timeToExpiry =
//         _authToken!.expiryDate.difference(DateTime.now()).inSeconds;
//     _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
//   }
// }
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:myshop/services/user_service.dart';
import 'package:myshop/ui/user/user_manager.dart';

import '/models/auth_token.dart';
import '../../services/auth_service.dart';

class AuthManager with ChangeNotifier {
  AuthToken? _authToken;
  Timer? _authTimer;

  final AuthService _authService = AuthService();

  bool get isAuth {
    return authToken != null && authToken!.isValid;
  }

  AuthToken? get authToken {
    return _authToken;
  }

  void _setAuthToken(AuthToken token) {
    _authToken = token;
    _autoLogout();
    notifyListeners();
  }

  Future<AuthToken> signup(String email, String password, String name,
      String phone, String address) async {
    AuthToken authToken = await _authService.signup(email, password);

    await UserService(authToken).createProfile(
      authToken.userId,
      email,
      name,
      address,
      phone,
    );

    _setAuthToken(authToken);

    return _authToken!;
  }

  Future<void> login(String email, String password) async {
    final authToken = await _authService.login(email, password);

    await UserManager(authToken).fetchProfile();

    _setAuthToken(authToken);
  }

  Future<bool> tryAutoLogin() async {
    final savedToken = await _authService.loadSavedAuthToken();
    if (savedToken == null) {
      return false;
    }

    _setAuthToken(savedToken);
    return true;
  }

  Future<void> logout() async {
    _authToken = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
    _authService.clearSavedAuthToken();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpiry =
        _authToken!.expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
