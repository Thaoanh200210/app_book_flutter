import 'dart:convert';

import 'package:myshop/models/auth_token.dart';
import 'package:myshop/models/user.dart';
import 'package:myshop/services/firebase_service.dart';

class UserService extends FirebaseService {
  UserService([AuthToken? authToken]) : super(authToken);

  Future<User?> fetchProfile() async {
    User profile;

    try {
      final userMap =
      await httpFetch('$databaseUrl/users/$userId.json?auth=$token')
      as Map<String, dynamic>?;

      profile = User.fromJson(userMap!);
      print(userMap);
      return profile;
    } catch (error) {
      print(error);

      return null;
    }


  }

  Future<User?> createProfile(String userId, String email, String name,
      String address, String phone) async {
    User profile;

    try {
      final response = await httpFetch(
        '$databaseUrl/users/$userId.json?auth=$token',
        method: HttpMethod.put,
        body: json.encode({
          'email': email,
          'name': name,
          'address': address,
          'phone': phone,
          'isAdmin': false,
        }),
      ) as Map<String, dynamic>?;

      if (response == null) {
        return null;
      }

      profile = User.fromJson(response);

      return profile;
    } catch (error) {
      print(error);

      return null;
    }
  }
}
