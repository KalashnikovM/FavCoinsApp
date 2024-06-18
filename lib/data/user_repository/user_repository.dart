
import 'dart:convert';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:watch_it/watch_it.dart';
import '../../constants.dart';
import '../../models/favorite_model.dart';
import '../../services/appwrite_service.dart';
import '../currency_repository/currency_repository.dart';


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
  User? _user;
  late Session session;
  late String error;
 List<FavoriteCoinModel> favList = [];
  String? get userId  => _user?.$id;


  UserRepository() {


    _checkUser();


  }

  _checkUser() async {
    debugPrint('start checkUser()');

    try {
      _user = await _account.get(
      );
      debugPrint('user.status ${_user?.status}');
      debugPrint('user.name} ${_user?.name}');
      debugPrint('user.email ${_user?.email}');
      debugPrint('user.emailVerification ${_user?.emailVerification}');
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
    debugPrint('status(); $status');

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
         data: {"favorites_ids": "idsList",}, ///  check!!!!
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
    String? userId = _user?.$id;
    Document? userDoc;
    if(userId != null) {
      try {
        userDoc = await _db.getDocument(
          databaseId: databaseId,
          collectionId: userCollection,
          documentId: userId,
        );
        debugPrint('userDoc.data[favorites]; ${userDoc.data['favorites']}');

      } on AppwriteException catch (e) {
        if(e.message == "Document with the requested ID could not be found.") {

          userDoc = await _db.createDocument(
            databaseId: databaseId,
            collectionId: userCollection,
            documentId: userId,
            data: {"favorites": []},    ///  check!!!!
          );

        }
        debugPrint('Error fetching user profile: ${e.message}');
      }



    }

    if(userDoc != null) {
      parseData(userDoc);
    }
  }






  Future<void> _updateUserProfile() async {
    debugPrint('Start _updateUserProfile();');
    List<String> favorites = [];
    if(userId != null) {
      for (var favModel in favList) {
        favorites.add(json.encode({favModel.id: favModel.transactions}));
      }
      debugPrint(favorites.toString());
      try {
        var userDoc = await _db.updateDocument(
          databaseId: databaseId,
          collectionId: userCollection,
          documentId: userId ?? "",
          data: {"favorites": favorites,
          },
        );
        parseData(userDoc);

      } on AppwriteException catch (e) {
        debugPrint('Error updating user profile: ${e.message}');
        // rethrow;
      }

    }
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

    // for (var v in favList) {
    //   debugPrint('value: $v}');
    //   v.id == id
    //       ? null
    //       : favList.add(
    //       FavoriteCoinModel(
    //           id: id,
    //           transactions: {price: value}));
    // }


      _updateUserProfile();
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
     _updateUserProfile();

  }



  Future<void> logoutUser() async {
    try {
      await _account.deleteSession(sessionId: 'current');
      status = UserStatus.guest;
      // idsList.clear();

    } on AppwriteException catch (e) {
      debugPrint('Error logging out user: ${e.message}');
      // rethrow;
    }
    notifyListeners();

  }




  void parseData(Document userDoc) {
    debugPrint('Start parseData();');

    favList.clear();
    List <String> idsList = [];
    try {
      List<dynamic> favorites = userDoc.data['favorites'];
      debugPrint('Favorites raw data: $favorites');

      for (var value in favorites) {
        var decodedValue = jsonDecode(value);
        debugPrint(' value: $value');
        debugPrint(' value.runtimeType: ${value.runtimeType}');
        debugPrint('Decoded value: $decodedValue');
        debugPrint('Decoded value.runtimeType: ${decodedValue.runtimeType}');

          decodedValue.forEach((key, value) {
            favList.add(FavoriteCoinModel.fromJson(key, value));
            idsList.add(key);
          });
      }
      debugPrint('favList: $favList');
       di<CurrencyRepository>().updateFavoritesList(idsList);

    } catch (e) {
      debugPrint('Error parsing data: $e');
    }

    // notifyListeners();
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