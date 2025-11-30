// ignore_for_file: non_constant_identifier_names
import 'package:financial_tracker/app/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:financial_tracker/app/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:financial_tracker/app/models/users_model.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthService _authService;
  final UserService _userService;

  LoginViewModel(this._authService, this._userService);

  bool isLoading = false;

  Future<User?> signIn() async {
    try {
      isLoading = true;
      notifyListeners();

      final user = await _authService.signInWithGoogle();
      final doc = await _userService.userDoc;

      if (!doc.exists) {
        // create the default settings
        final default_settings = UserSettings(
          uid: user?.uid,
          email: user?.email,
          name: user?.displayName,
          profilePhotoUrl: user?.photoURL,
          currency: '₱',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await _userService.createUserRecord(default_settings);
      }

      return user;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
