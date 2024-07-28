import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import '../../services/appwrite_service.dart';
import '../../services/messaging_service.dart';
import '../currency_repository/favorites_repository/favorites_repository.dart';

enum UserStatus {
  guest,
  updating,
  login,
  error,
}

class UserRepository extends ChangeNotifier {
  UserStatus status = UserStatus.guest;
   Account get _account  => di<ApiClient>().account;
  String _userId = '';

  String error = '';
  String get userId => _userId;
  String get fcmToken => di<LocalNotification>().fcmToken;

  UserRepository() {
    _checkUser();
  }

  // Update the user ID
  void updateUser(String newUserId) {
    _userId = newUserId;
    notifyListeners();
  }

  // Check if the user is logged in
  Future<void> _checkUser() async {
    debugPrint('Checking user...');
    try {
      var user = await _account.get();
      await _account.getSession(sessionId: 'current');
      updateUser(user.$id);
      status = UserStatus.login;
      di<FavoritesRepository>().onUserChanged();
    } on AppwriteException catch (e) {
      error = e.message.toString();
      updateUser('');
      status = UserStatus.guest;
    }
    notifyListeners();
  }

  // Register a new user
  Future<bool> registerUser({
    required String email,
    required String password,
  }) async {
    debugPrint('Registering user...');
    try {
      await _account.create(
        userId: 'unique()', // Automatically generate a unique ID
        email: email,
        password: password,
      );
      await loginUser(email: email, password: password);
      status = UserStatus.login;
      notifyListeners();
      return true;
    } on AppwriteException catch (e) {
      status = UserStatus.error;
      error = e.message.toString();
      notifyListeners();
      return false;
    }
  }

  // Login a user
  Future<bool> loginUser({
    required String email,
    required String password,
  }) async {
    debugPrint('Logging in user...');
    try {
      await _account.createEmailSession(email: email, password: password);
      await _checkUser();
      return true;
    } on AppwriteException catch (e) {
      error = e.message.toString();
      status = UserStatus.error;
      return false;
    }
  }

  // Logout a user
  Future<void> logoutUser() async {
    debugPrint('Logging out user...');
    await _account.deleteSession(sessionId: 'current');
    di<FavoritesRepository>().clearState();
    _checkUser();
  }
}