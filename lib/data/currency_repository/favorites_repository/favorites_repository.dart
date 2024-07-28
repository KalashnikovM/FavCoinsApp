import 'dart:convert';
import 'package:appwrite/appwrite.dart';
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
  List<FavoriteCoinModel> favUserDataList = [];
  List<dynamic> alertsList = [];

  Databases get _db => di<ApiClient>().database;
  String get userId => di<UserRepository>().userId;
  String get fcmToken => di<UserRepository>().fcmToken;

  FavoritesRepository() {
    di<UserRepository>().addListener(onUserChanged);
    debugPrint('FavoritesRepository initialized.');
  }

  // Clear state when the user changes
  void onUserChanged() {
    clearState();
    getUserProfile();
  }

  // Fetch user profile data
  Future<void> getUserProfile() async {
    debugPrint('Fetching user profile...');
    if (userId.isEmpty) return;

    try {
      var userDoc = await _db.getDocument(
        databaseId: databaseId,
        collectionId: userCollection,
        documentId: userId,
      );

      var res = await parseUserData(userDoc);
      favUserDataList = res.favList;
      alertsList = res.alertsList;
      updateFavoritesList(res.ids);
      notifyListeners();
        } on AppwriteException catch (e) {
      if (e.message == "Document with the requested ID could not be found.") {
        await _updateUserProfile();
      }
      debugPrint('Error fetching user profile: ${e.message}');
    }
  }

  // Update or create user profile
  Future<void> _updateUserProfile() async {
    debugPrint('Updating user profile...');

    if (userId.isEmpty) return;

    List<String> favorites = [];
    for (var favModel in favUserDataList) {
      favorites.add(json.encode({favModel.id: favModel.transactions}));
    }

    try {
      var userDoc = await _db.updateDocument(
        databaseId: databaseId,
        collectionId: userCollection,
        documentId: userId,
        data: {
          "favorites": favorites,
          "device": fcmToken,
          "Alerts": alertsList,
        },
      );

      var res = await parseUserData(userDoc);
      favUserDataList = res.favList;
      alertsList = res.alertsList;
      updateFavoritesList(res.ids);
      notifyListeners();
    } on AppwriteException catch (e) {
      debugPrint('Error updating user profile: ${e.message}');
      if (e.message == "Document with the requested ID could not be found.") {
        var userDoc = await _db.createDocument(
          databaseId: databaseId,
          collectionId: userCollection,
          documentId: userId,
          data: {
            "Alerts": [],
            "favorites": [],
            "device": fcmToken,
          },
        );

        var res = await parseUserData(userDoc);
        favUserDataList = res.favList;
        alertsList = res.alertsList;
        updateFavoritesList(res.ids);
        notifyListeners();
      }
    }
  }

  // Clear all state
  void clearState() {
    favoritesList.clear();
    favUserDataList.clear();
    alertsList.clear();
    notifyListeners();
  }

  // Update the favorites list
  Future<void> updateFavoritesList(List<String> ids) async {
    debugPrint('Updating favorites list...');
    List<MainCoinModel> temp = [];
    for (String id in ids) {
      try {
        var doc = await _db.getDocument(
          databaseId: databaseId,
          collectionId: coinDataCollection,
          documentId: id,
        );
        var mainModel = await ParsingService().parseDataToMainCoinModel(doc.data);
        temp.add(mainModel);
      } catch (e) {
        debugPrint('Error updating favorites list: $e');
      }
    }
    favoritesList = temp;
    notifyListeners();
  }

  // Add to favorites
  Future<void> addToFavorites({
    required String value,
    required String price,
    required String id,
  }) async {
    debugPrint('Adding to favorites...');
    favUserDataList.add(
      FavoriteCoinModel(
        id: id,
        transactions: {price: value},
      ),
    );
    await _updateUserProfile();
    notifyListeners();
  }

  // Remove from favorites
  Future<void> removeFromFavorites(String id) async {
    debugPrint('Removing from favorites...');
    favUserDataList.removeWhere((fav) => fav.id == id);
    await _updateUserProfile();
    notifyListeners();
  }

  // Check if a coin is in favorites
  bool isFavorites(String id) {
    return favUserDataList.any((model) => model.id == id);
  }

  // Add an alert
  void addAlert({
    required String id,
    required String upperTargetPrice,
    required String lowerTargetPrice,
  }) {
    debugPrint('Adding alert...');
    var alert = {
      id: {
        'upperTargetPrice': upperTargetPrice,
        'lowerTargetPrice': lowerTargetPrice,
      }
    };
    alertsList.add(jsonEncode(alert));
    _updateUserProfile();
  }

  // Remove an alert
  void removeAlert(String id) {
    debugPrint('Removing alert...');
    alertsList.removeWhere((alert) => jsonDecode(alert)[id] != null);
    _updateUserProfile();
  }

  @override
  void dispose() {
    di<UserRepository>().removeListener(onUserChanged);
    super.dispose();
  }
}
