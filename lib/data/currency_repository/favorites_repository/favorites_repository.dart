import 'dart:convert';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import '../../../constants.dart';
import '../../../models/favorite_model.dart';
import '../../../models/main_coin_model.dart';
import '../../../services/appwrite_service.dart';
import '../../../services/parse_data_service.dart';
import '../../user_repository/user_repository.dart';

enum FavoritesRepositoryStatus {
  init,
  updated,
  updating,
  error,
}






class FavoritesRepository extends ChangeNotifier {
  List<MainCoinModel> favoritesList = [];
  List<String> ids = [];
  List<FavoriteCoinModel> favList = [];
  List<dynamic> alertsList = [];

  final _db = di<ApiClient>().database;
  UserRepository userRepository = di<UserRepository>();

  Map<String, String> favoritesRepositoryError = {};

  get clearFav => favoritesList.clear();

  FavoritesRepository() {
    debugPrint('init FavoritesRepository();');
  }

  Future<void> getUserProfile() async {
    debugPrint('Start getUserProfile();');
    Document? userDoc;
    debugPrint('_user?.id: ${userRepository.userId}');

    try {
      userDoc = await _db.getDocument(
        databaseId: databaseId,
        collectionId: userCollection,
        documentId: userRepository.userId,
      );
      debugPrint('favorites: ${userDoc.data['favorites']}');
      debugPrint('Alerts: ${userDoc.data['Alerts']}');
      debugPrint('@@@@@@ getDocument');
    } on AppwriteException catch (e) {
      if (e.message == "Document with the requested ID could not be found.") {
        await _updateUserProfile();
      }
      debugPrint('Error fetching user profile: ${e.message}\nuserId: ${userRepository.userId}');
    }

    if (userDoc != null) {
      debugPrint('@@@@@@ parseData(userDoc)');
      var res = await parseUserData(userDoc);
      favList = res.favList;
      alertsList = res.alertsList;
      updateFavoritesList(res.ids);
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
    debugPrint('_user?.id: ${userRepository.userId}');
    debugPrint('Start _updateUserProfile();');

    for (var favModel in favList) {
      favorites.add(json.encode({favModel.id: favModel.transactions}));
    }
    debugPrint(favorites.toString());
    try {
      userDoc = await _db.updateDocument(
        databaseId: databaseId,
        collectionId: userCollection,
        documentId: userRepository.userId,
        data: {
          "favorites": favorites,
          "device": userRepository.fcmToken,
          "Alerts": alertsList,
        },
      );
      var res = await parseUserData(userDoc);
      favList = res.favList;
      alertsList = res.alertsList;
      updateFavoritesList(res.ids);
      notifyListeners();
      debugPrint('@@@@@@ favList $favList');
      debugPrint('@@@@@@ alertsList $alertsList');
    } on AppwriteException catch (e) {
      debugPrint('Error updating user profile: ${e.message}');
      if (e.message == "Document with the requested ID could not be found.") {
        debugPrint('@@@@@@ create Document');

        userDoc = await _db.createDocument(
          databaseId: databaseId,
          collectionId: userCollection,
          documentId: userRepository.userId,
          data: {
            "Alerts": alerts,
            "favorites": [],
            "device": userRepository.fcmToken,
          },
        );
        var res = await parseUserData(userDoc);
        favList = res.favList;
        alertsList = res.alertsList;
        updateFavoritesList(res.ids);
        notifyListeners();
        debugPrint('@@@@@@ favList $favList');
        debugPrint('@@@@@@ alertsList $alertsList');
      }
    }
  }

  Future<void> updateFavoritesList(List<String> ids) async {
    debugPrint('Start updateFavoritesList();');
    List<MainCoinModel> temp = [];
    for (String id in ids) {
      try {
        Document doc = await _db.getDocument(
          databaseId: databaseId,
          collectionId: coinDataCollection,
          documentId: id,
        );
        MainCoinModel mainModel = await ParsingService().parseDataToMainCoinModel(doc.data);
        temp.add(mainModel);
        debugPrint('Document added to favorites()doc.data; ${doc.data}');
      } catch (e) {
        debugPrint('Error updateFavoritesList: $e');
        favoritesRepositoryError[DateTime.now().toLocal().toString()] = e.toString();
      }
    }
    if (temp.isNotEmpty) {
      favoritesList = temp;
    }
    notifyListeners();
  }

  Future<void> addToFavorites({
    required String value,
    required String price,
    required String id,
  }) async {
    debugPrint('start addToFavorites(); id $id');

    favList.add(
      FavoriteCoinModel(
        id: id,
        transactions: {price: value},
      ),
    );
    await _updateUserProfile();
    notifyListeners();
  }

  Future<void> removeFromFavorites(String id) async {
    debugPrint('start removeFromFavorites(); id $id');

    List<FavoriteCoinModel> toRemove = [];

    for (var v in favList) {
      debugPrint('value: $v}');
      if (v.id == id) {
        toRemove.add(v);
      }
    }
    favList.removeWhere((e) => toRemove.contains(e));
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

  void addAlert({
    required String id,
    required String upperTargetPrice,
    required String lowerTargetPrice,
  }) {
    debugPrint('start addAlert()');
      var a = {id: {
        'upperTargetPrice': upperTargetPrice,
        'lowerTargetPrice': lowerTargetPrice,
      }};
    alertsList.add(jsonEncode(a));
    _updateUserProfile();
  }

  void removeAlert(String id) {
    debugPrint('start removeAlert()');
    alertsList.remove(id);
    _updateUserProfile();
  }
}