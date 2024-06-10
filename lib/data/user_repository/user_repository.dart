
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:crypto_tracker/data/currency_repository/currency_repository.dart';
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
  late String error;
  List<String> idsList = [];




  UserRepository() {


    _checkUser();


  }

  _checkUser() async {
    debugPrint('start checkUser()');

    try {
      user = await _account.get(
      );
      debugPrint('user.status ${user?.status}');
      debugPrint('user.name} ${user?.name}');
      debugPrint('user.email ${user?.email}');
      debugPrint('user.emailVerification ${user?.emailVerification}');
      getUserProfile();
      status = UserStatus.login;
      notifyListeners();

    } on AppwriteException catch (e) {
      if(e.code == 401)
        {
          status = UserStatus.guest;
          debugPrint('checkUser(); UserStatus.guest');

        }
      debugPrint('Error checkUser: $e');
      status = UserStatus.error;
      // rethrow;
    }
  }



  Future<bool> registerUser({

  required String email,
    required String password,

  }) async {
    debugPrint('start registerUser()');

    try {
       var account = await _account.create(
        userId: 'unique()', // Automatically generate a unique ID
        email: email,
        password: password,
      );


       await loginUser(
           email: email,
           password: password);

       await _db.createDocument(
         databaseId: databaseId,
         collectionId: userCollection,
         documentId: account.$id,
         data: {"favorites_ids": idsList,},
         // permissions: [
         //   Permission.write(Role.user(account.$id)),
         //   Permission.read(Role.user(account.$id)),
         //   Permission.update(Role.user(account.$id)),
         // ],
       );

       // status = UserStatus.login;
       // notifyListeners();
       return true;
    } on AppwriteException catch (e) {
      status = UserStatus.error;
      debugPrint('Error registering user: ${e.message}');
      notifyListeners();
      return false;

      // rethrow;
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
       // status = UserStatus.login;
       await _checkUser();

       // notifyListeners();

       return true;
    } on AppwriteException catch (e) {
      debugPrint('Error logging in user: ${e.message}');
      status = UserStatus.error;
      error = e.message ?? 'Login error. Check fields';
      // rethrow;
      return false;


    }

  }



  Future getUserProfile() async {
    debugPrint('Start getUserProfile();');
    String? userId = user?.$id;
    Document? userDoc;
    if(userId != null) {
      try {
        userDoc = await _db.getDocument(
          databaseId: databaseId,
          collectionId: userCollection,
          documentId: userId,
        );
        debugPrint('userDoc.data; ${userDoc.data['favorites_ids']}');


      } on AppwriteException catch (e) {
        if(e.message == "Document with the requested ID could not be found.") {

          userDoc = await _db.createDocument(
            databaseId: databaseId,
            collectionId: userCollection,
            documentId: userId,
            data: {"favorites_ids": idsList,},
            // permissions: [
            //   Permission.write(Role.user(account.$id)),
            //   Permission.read(Role.user(account.$id)),
            //   Permission.update(Role.user(account.$id)),
            // ],
          );

        }
        debugPrint('Error fetching user profile: ${e.message}');
        // rethrow;
      }



    }

    if(userDoc != null) {
      parseData(userDoc);
    }
  }




  Future<void> addToFavorites(String id) async {

    idsList.contains(id)
        ? null
        : {idsList.add(id),
      _updateUserProfile()};

  }

  Future<void> removeFromFavorites(String id) async {

    idsList.contains(id)
        ? {idsList.remove(id),
      _updateUserProfile()}
        : null;

  }














    Future<void> _updateUserProfile() async {

    String? userId = user?.$id;
    if(userId != null) {


    try {
      var userDoc = await _db.updateDocument(
        databaseId: databaseId,
        collectionId: userCollection,
        documentId: userId,
        data: {"favorites_ids": idsList,},
      );
      parseData(userDoc);

    } on AppwriteException catch (e) {
      debugPrint('Error updating user profile: ${e.message}');
      // rethrow;
    }

    }
  }




  Future<void> logoutUser() async {
    try {
      await _account.deleteSession(sessionId: 'current');
      status = UserStatus.guest;
      idsList.clear();

    } on AppwriteException catch (e) {
      debugPrint('Error logging out user: ${e.message}');
      // rethrow;
    }
    notifyListeners();

  }




  void parseData(Document userDoc) {
    debugPrint('Start parseData();');

    List<dynamic> parsedList = userDoc.data['favorites_ids'];
    idsList = parsedList.map((e) => e.toString()).toList();
    di<CurrencyRepository>().updateFavoritesList(idsList);

    notifyListeners();

  }




  bool isFavorites(String id) {
    bool res = false;
    for (var model in idsList) {
      if (model == id) {
        res = true;
        break;
      }

    }

    return res;
  }




}