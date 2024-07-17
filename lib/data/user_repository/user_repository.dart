import 'dart:convert';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:crypto_tracker/data/currency_repository/favorites_repository/favorites_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:watch_it/watch_it.dart';
import '../../constants.dart';
import '../../models/favorite_model.dart';
import '../../services/appwrite_service.dart';
import '../../services/messaging_service.dart';
import '../../services/parse_data_service.dart';


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
  List<String> ids = [];
   List<FavoriteCoinModel> favList = [];
  List<dynamic> alertsList = [];

  String get userId  => _user.$id;
  String get fcmToken => di<LocalNotification>().fcmToken;


  UserRepository() {
    _checkUser();

  }










  _checkUser() async {
    debugPrint('start checkUser()');

    try {
      _user = await _account.get();
      debugPrint('user.email ${_user.email}');
      status = UserStatus.login;
      await getUserProfile();
      notifyListeners();

    } on AppwriteException catch (e) {
      // if(e.code == 401)
      //   {
      //     status = UserStatus.guest;
      //     debugPrint('checkUser(); UserStatus.guest');
      //     notifyListeners();
      //   }
      debugPrint('Error checkUser: $e');
      status = UserStatus.guest;
      notifyListeners();
    }
    debugPrint('status(); $status');

  }


  Future getUserProfile() async {
    debugPrint('Start getUserProfile();');
    Document? userDoc;
    debugPrint('_user?.id: ${_user.$id}');




    try {
      userDoc = await _db.getDocument(
        databaseId: databaseId,
        collectionId: userCollection,
        documentId: userId,
      );
      debugPrint('favorites: ${userDoc.data['favorites']}');
      debugPrint('Alerts: ${userDoc.data['Alerts']}');

      debugPrint('@@@@@@ getDocument');

    } on AppwriteException catch (e) {
      if(e.message == "Document with the requested ID could not be found.") {
        await _updateUserProfile();
      }
      debugPrint('Error fetching user profile: ${e.message}\nuserId: $userId');

    }

    if(userDoc != null) {
      debugPrint('@@@@@@ parseData(userDoc)');
      var res = await parseUserData(userDoc);
      favList = res.favList;
      alertsList = res.alertsList;
      di<FavoritesRepository>().updateFavoritesList(res.ids);
      debugPrint('@@@@@@ favList $favList');
      debugPrint('@@@@@@ alertsList $alertsList');
      notifyListeners();

    }
  }



  Future<void> _updateUserProfile() async {
    debugPrint('start _updateUserProfile()');

    List<String> favorites = [];
    List<String> alerts = [];
    late Document userDoc;
    String id = (await _account.get()).$id;

    debugPrint('_user?.id: ${_user.$id}');
    debugPrint('_user?.id: $userId');
    debugPrint('Start _updateUserProfile();');

    for (var favModel in favList) {
      favorites.add(json.encode({favModel.id: favModel.transactions}));
    }
    debugPrint(favorites.toString());
    try {
      userDoc = await _db.updateDocument(
        databaseId: databaseId,
        collectionId: userCollection,
        documentId: id,
        data: {
          "favorites": favorites,
          "device": fcmToken,
          "Alerts": alertsList,

        },
      );
      var res = await parseUserData(userDoc);
      favList = res.favList;
      alertsList = res.alertsList;
      di<FavoritesRepository>().updateFavoritesList(res.ids);
      notifyListeners();
      debugPrint('@@@@@@ favList $favList');
      debugPrint('@@@@@@ alertsList $alertsList');

    } on AppwriteException catch (e) {
      debugPrint('Error updating user profile: ${e.message}');
      if(e.message == "Document with the requested ID could not be found.") {
        debugPrint('@@@@@@ create Document');

        userDoc = await _db.createDocument(
          databaseId: databaseId,
          collectionId: userCollection,
          documentId: id,
          data: {
            "Alerts": alerts,
            "favorites": [],
            "device": fcmToken,
          },
        );
        var res = await parseUserData(userDoc);
        favList = res.favList;
        alertsList = res.alertsList;
        di<FavoritesRepository>().updateFavoritesList(res.ids);
        notifyListeners();
        debugPrint('@@@@@@ favList $favList');
        debugPrint('@@@@@@ alertsList $alertsList');
      }
    }

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
    notifyListeners();


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



  addAlert({required id, required upperTargetPrice, required lowerTargetPrice}) {
    debugPrint('start addAlert()');
    alertsList[id] = {'upperTargetPrice': upperTargetPrice, 'lowerTargetPrice': lowerTargetPrice};
    _updateUserProfile();
  }



  removeAlert(String id) {
    debugPrint('start removeAlert()');
    alertsList.remove(id);
    _updateUserProfile();

  }




}



