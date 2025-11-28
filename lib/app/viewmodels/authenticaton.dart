import 'package:flutter/material.dart';
import 'package:financial_tracker/app/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';


class LoginViewModel extends ChangeNotifier {
  final AuthService _authService;

  LoginViewModel(this._authService);

  bool isLoading = false;

  Future<User?> signIn() async {
    try {
      isLoading = true;
      notifyListeners();

      final user = await _authService.signInWithGoogle();
      return user;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
