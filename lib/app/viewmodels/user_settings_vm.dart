import 'package:flutter/material.dart';
import 'package:financial_tracker/app/models/users_model.dart';
import 'package:financial_tracker/app/services/user_service.dart';

class UserSettingsViewModel extends ChangeNotifier {
  final UserService _userService = UserService();

  UserSettings? userSettings;
  bool isLoading = false;

  /// Fetch user info from Firestore
  Future<void> loadUserInfo() async {
    isLoading = true;
    notifyListeners();

    userSettings = await _userService.getUser();

    isLoading = false;
    notifyListeners();
  }

  /// Convenience getters
  String get email => userSettings?.email ?? '';
  String get name => userSettings?.name ?? '';
  String get currency => userSettings?.currency ?? '₱';

  Future<void> editUserName(String newName) async {
    userSettings!.name = newName;
    await _userService.updateUserName(newName);

    notifyListeners();
  }
}
