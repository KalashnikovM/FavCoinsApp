import 'dart:convert';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:crypto_tracker/data/currency_repository/favorites_repository/favorites_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:watch_it/watch_it.dart';
import '../../constants.dart';
import '../../models/favorite_model.dart';
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
  final _db = di<ApiClient>().database;
  late User _user;
  late Session session;
  String error = '';
   List<FavoriteCoinModel> favList = [];
  String get userId  => _user.$id;
  String get fcmToken => di<LocalNotification>().fcmToken;


  UserRepository() {
    _checkUser();

  }




  _checkUser() async {
    debugPrint('start checkUser()');

    try {
      _user = await _account.get(
      );
      debugPrint('user.status ${_user.status}');
      debugPrint('user.name} ${_user.name}');
      debugPrint('user.email ${_user.email}');
      debugPrint('user.emailVerification ${_user.emailVerification}');
      await _updateUserProfile();
      status = UserStatus.login;
      notifyListeners();

    } on AppwriteException catch (e) {
      if(e.code == 401)
        {
          status = UserStatus.guest;
          debugPrint('checkUser(); UserStatus.guest');
          notifyListeners();
        }
      debugPrint('Error checkUser: $e');
      status = UserStatus.guest;
      notifyListeners();

      // rethrow;
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


       //  await _db.createDocument(
       //   databaseId: databaseId,
       //   collectionId: userCollection,
       //   documentId: userId,
       //   data: {
       //     "favorites": [],
       //     "device": fcmToken,
       //   },
       // );
        // _checkUser();
       status = UserStatus.login;
       notifyListeners();
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
       debugPrint('session.userId: ${session.userId}');

       await _checkUser();

       return true;
    } on AppwriteException catch (e) {
      debugPrint('Error logging in user: ${e.message}');
      status = UserStatus.error;
      error = e.message ?? 'Login error. Check fields';
      // rethrow;
      return false;


    }

  }




  // Future getUserProfile() async {
  //   debugPrint('Start getUserProfile();');
  //   Document? userDoc;
  //   debugPrint('_user?.id: ${_user.$id}');
  //
  //
  //
  //
  //   try {
  //     userDoc = await _db.getDocument(
  //       databaseId: databaseId,
  //       collectionId: userCollection,
  //       documentId: userId,
  //     );
  //     debugPrint('favorites: ${userDoc.data['favorites']}');
  //     debugPrint('@@@@@@ getDocument');
  //
  //   } on AppwriteException catch (e) {
  //     if(e.message == "Document with the requested ID could not be found.") {
  //     try {
  //       userDoc = await _db.createDocument(
  //         databaseId: databaseId,
  //         collectionId: userCollection,
  //         documentId: userId,
  //         data: {
  //           "favorites": [],
  //           "device": fcmToken,
  //         },
  //       );
  //       debugPrint('@@@@@@ createDocument');
  //
  //     }
  //     catch (e) {
  //       debugPrint('Error createDocument e.toString(): ${e.toString()}');
  //       debugPrint('Error createDocument e.runtimeType: ${e.runtimeType}');
  //
  //       }
  //     }
  //     debugPrint('Error fetching user profile: ${e.message}');
  //     debugPrint('userId: $userId');
  //
  //   }
  //
  //
  //
  //
  //   if(userDoc != null) {
  //     parseData(userDoc);
  //   }
  // }






  Future<void> _updateUserProfile() async {
     var u = await _account.get();
    debugPrint('_user?.id: ${_user.$id}');
    debugPrint('_user?.id: $userId');
    var userDoc;
    debugPrint('Start _updateUserProfile();');
    List<String> favorites = [];
    for (var favModel in favList) {
      favorites.add(json.encode({favModel.id: favModel.transactions}));
    }
    debugPrint(favorites.toString());
    try {
      userDoc = await _db.updateDocument(
        databaseId: databaseId,
        collectionId: userCollection,
        documentId: u.$id,
        data: {
          "favorites": favorites,
          "device": fcmToken,
        },
      );

    } on AppwriteException catch (e) {
      if(e.message == "Document with the requested ID could not be found.") {
        userDoc = await _db.createDocument(
          databaseId: databaseId,
          collectionId: userCollection,
          documentId: u.$id,
          data: {
            "favorites": [],
            "device": fcmToken,
          },
        );
        debugPrint('@@@@@@ createDocument');
        debugPrint('Error updating user profile: ${e.message}');
        // rethrow;

      }
    }
    parseData(userDoc);

  }





  Future<void> addToFavorites({
    required String value,
    required String price,
    required String id}) async {
    debugPrint('start addToFavorites(); id $id');


    favList.add(
        FavoriteCoinModel(
            id: id,
            transactions: {price: value}));
      await _updateUserProfile();
  }



  Future<void> removeFromFavorites(String id) async {
    debugPrint('start removeFromFavorites(); id $id');

     List<FavoriteCoinModel> toRemove = [];

    for (var v in favList) {
      debugPrint('value: $v}');
      if(v.id == id) {
        toRemove.add(v);
      }

    }
    favList.removeWhere( (e) => toRemove.contains(e));
    await _updateUserProfile();

  }



  Future<void> logoutUser() async {
    debugPrint('start logoutUser()');

    try {
      await _account.deleteSession(sessionId: 'current');
      favList.clear();
      di<FavoritesRepository>().clearFav;
      _checkUser();

    } on AppwriteException catch (e) {
      debugPrint('Error logging out user: ${e.message}');
      // rethrow;
    }

  }




  void parseData(Document userDoc) {
    debugPrint('Start parseData();');

    favList.clear();
    List <String> idsList = [];
    try {
      List<dynamic> favorites = userDoc.data['favorites'];
      debugPrint('Favorites raw data: $favorites');
      for (var value in favorites) {
        Map<String, dynamic> decodedValue = jsonDecode(value);
          decodedValue.forEach((key, value) {
            value.forEach((k, v) {
              debugPrint('k: $k');
              debugPrint('v: $v');
            });
            favList.add(FavoriteCoinModel.fromJson(key, value));
            idsList.add(key);
          });
      }
      debugPrint('favList: $favList');
       di<FavoritesRepository>().updateFavoritesList(idsList);

    } catch (e) {
      debugPrint('Error parsing data: $e');
    }

    notifyListeners();
  }




  bool isFavorites(String id) {
    bool res = false;
    for (FavoriteCoinModel model in favList) {
      if (model.id == id) {
        res = true;
        break;
      }

    }

    return res;
  }




}