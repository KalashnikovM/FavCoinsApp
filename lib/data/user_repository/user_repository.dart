
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:watch_it/watch_it.dart';

import '../../constants.dart';
import '../../services/appwrite_service.dart';


enum UserStatus {
  guest,
  updating,
  login,
  error,
}

class UserRepository extends ChangeNotifier {

  UserStatus status = UserStatus.guest;
  final _account = di<ApiClient>().account;
  final _db = di<ApiClient>().database;
  User? user;
  late Session session;

  UserRepository() {


    checkUser();


  }

  checkUser() async {
    debugPrint('start checkUser()');

    try {
      user = await _account.get(
      );
      status = UserStatus.login;
      debugPrint('user.status ${user?.status}');
      debugPrint('user.name} ${user?.name}');
      debugPrint('user.email ${user?.email}');
      debugPrint('user.emailVerification ${user?.emailVerification}');
      notifyListeners();


    } on AppwriteException catch (e) {
      debugPrint('Error registering user: $e');

      loginUser(email: 'test@test.test', password: 'Qw!@34er');
      status = UserStatus.error;
      rethrow;
    }
  }



  Future<bool> registerUser({

  required String email,
    required String password,

  }) async {
    debugPrint('start registerUser()');

    try {
       user = await _account.create(
        userId: 'unique()', // Automatically generate a unique ID
        email: email,
        password: password,
      );
       status = UserStatus.login;
       notifyListeners();
       return true;
    } on AppwriteException catch (e) {
      status = UserStatus.error;
      debugPrint('Error registering user: ${e.message}');
      rethrow;
    }
  }




  Future<bool> loginUser({
    required String email,
    required String password,
  }) async {
    debugPrint('start loginUser()');

    try {
       session = await _account.createEmailSession(
        email: email,
        password: password,
      );
       status = UserStatus.login;
       notifyListeners();

       return true;
    } on AppwriteException catch (e) {
      debugPrint('Error logging in user: ${e.message}');
      rethrow;
    }
  }


  Future<void> updateUserProfile({
    required String userId,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _db.updateDocument(
        databaseId: databaseId,
        collectionId: userCollection,
        documentId: userId,
        data: data,
      );
    } on AppwriteException catch (e) {
      debugPrint('Error updating user profile: ${e.message}');
      rethrow;
    }
  }

  // Future<Document> getUserProfile(String userId) async {
  //   try {
  //     final document = await _db.getDocument(
  //       databaseId: databaseId,
  //       collectionId: userCollection,
  //       documentId: userId,
  //     );
  //     return document;
  //   } on AppwriteException catch (e) {
  //     debugPrint('Error fetching user profile: ${e.message}');
  //     rethrow;
  //   }
  // }


  Future<void> logoutUser() async {
    try {
      await _account.deleteSession(sessionId: 'current');
      status = UserStatus.guest;

    } on AppwriteException catch (e) {
      debugPrint('Error logging out user: ${e.message}');
      rethrow;
    }
    notifyListeners();

  }


}