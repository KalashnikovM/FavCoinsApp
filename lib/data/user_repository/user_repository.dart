import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:crypto_tracker/data/currency_repository/favorites_repository/favorites_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:watch_it/watch_it.dart';
import '../../services/appwrite_service.dart';
import '../../services/messaging_service.dart';

enum UserStatus {
  guest,
  updating,
  login,
  error,
}

class UserRepository extends ChangeNotifier {
  UserStatus status = UserStatus.guest;
  final _account = di<ApiClient>().account;
  late User _user;
  late Session _session;
  String error = '';

  String get userId => _user.$id;
  String get fcmToken => di<LocalNotification>().fcmToken;

  UserRepository() {
    _checkUser();
  }







  Future<void> _checkUser() async {
    debugPrint('start checkUser()');

    try {
      _user = await _account.get();
      debugPrint('user.email ${_user.email}');
      status = UserStatus.login;
      di<FavoritesRepository>().getUserProfile();
      notifyListeners();
    } on AppwriteException catch (e) {
      debugPrint('Error checkUser: $e');
      status = UserStatus.guest;
      notifyListeners();
    }
    debugPrint('status(); $status');
  }






  Future<bool> registerUser({
    required String email,
    required String password,
  }) async {
    debugPrint('start registerUser()');
    debugPrint('fcmToken: $fcmToken');
    try {
      await _account.create(
        userId: 'unique()', // Automatically generate a unique ID
        email: email,
        password: password,
      );
      await loginUser(
        email: email,
        password: password,
      );
      status = UserStatus.login;
      notifyListeners();
      return true;
    } on AppwriteException catch (e) {
      status = UserStatus.error;
      debugPrint('Error registering user: ${e.message}');
      notifyListeners();
      return false;
    }
  }

  Future<bool> loginUser({
    required String email,
    required String password,
  }) async {
    debugPrint('start loginUser()');

    try {
      _session = await _account.createEmailSession(
        email: email,
        password: password,
      );
      debugPrint('session.userId: ${_session.userId}');

      await _checkUser();

      return true;
    } on AppwriteException catch (e) {
      debugPrint('Error logging in user: ${e.message}');
      status = UserStatus.error;
      error = e.message ?? 'Login error. Check fields';
      return false;
    }
  }

  Future<void> logoutUser() async {
    debugPrint('start logoutUser()');

    try {
      await _account.deleteSession(sessionId: 'current');
      di<FavoritesRepository>().clearFav;
      _checkUser();
    } on AppwriteException catch (e) {
      debugPrint('Error logging out user: ${e.message}');
    }
  }
}