import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import '../../constants.dart';
import '../../services/appwrite_service.dart';
import '../../services/messaging_service.dart';
import '../currency_repository/favorites_repository/favorites_repository.dart';
import 'package:uuid/uuid.dart';


enum UserStatus {
  guest,
  updating,
  login,
  error,
}

class UserRepository extends ChangeNotifier {
  UserStatus status = UserStatus.guest;

  Account get _account => di<ApiClient>().account;
  String _userId = '';
  String error = '';

  String get userId => _userId;

  String get fcmToken => di<LocalNotification>().fcmToken;

  UserRepository() {
    _checkUser();
  }

  // Update the user ID
  void updateUserId(String newUserId) {
    _userId = newUserId;
    notifyListeners();
  }

  // Check if the user is logged in
  Future<void> _checkUser() async {
    debugPrint('Checking user...');
    try {
      var user = await _account.get();
      await _account.getSession(sessionId: 'current');
      updateUserId(user.$id);
      status = UserStatus.login;
      di<FavoritesRepository>().onUserChanged();
    } on AppwriteException catch (e) {
      error = e.message.toString();
      updateUserId('');
      status = UserStatus.guest;
    }
    notifyListeners();
  }

  // Delete a user
  Future<bool> deleteUserProfile() async {
    try {
      final response = await di<ApiClient>()
          .functions
          .createExecution(functionId: deleteUserFunctionId, body: userId);
      debugPrint('Function executed: ${response.$id}');
      await _checkUser();
      return true;
    } catch (error) {
      debugPrint('Error executing function: $error');
      return false;
    }
  }

  // Register a new user
  Future<bool> registerUser({
    required String email,
    required String password,
  }) async {
    String newId = const Uuid().v4();
    debugPrint('Registering user...$newId');
    try {
      await _account.create(
        userId: newId, // Automatically generate a unique ID
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
    try {await _account.deleteSession(sessionId: 'current');}
    catch (e) { debugPrint('Logging out user...error: $e');
    }
    di<FavoritesRepository>().clearState();
    await _checkUser();
  }

  updateUserProfile({required String email, required String password}) async {
    debugPrint('UpdateUserProfile data...');

    try {
      await _account.updatePassword(password: password);

      await _account.updateEmail(email: email, password: password);

      debugPrint('UpdateUserProfile data...updated');
    } catch (e) {
      debugPrint('UpdateUserProfile data...error: $e');
    }
  }
}
