import 'package:flutter/foundation.dart';
import 'package:myshop/models/auth_token.dart';
import 'package:myshop/models/user.dart';
import 'package:myshop/services/user_service.dart';

class UserManager with ChangeNotifier {
  User? profile;

  final UserService _userService;

  UserManager([AuthToken? authToken]) : _userService = UserService(authToken);

  set authToken(AuthToken? authToken) {
    _userService.authToken = authToken;
  }

  Future<void> fetchProfile() async {
    profile = await _userService.fetchProfile();

    // notifyListeners();
  }

  Future<void> createProfile(String userId, String email, String name,
      String address, String phone) async {
    profile =
    await _userService.createProfile(userId, email, name, address, phone);

    notifyListeners();
  }
}
