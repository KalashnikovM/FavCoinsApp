


import 'dart:async';
import 'dart:convert';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:crypto_tracker/data/currency_repository/currency_repository.dart';
import 'package:crypto_tracker/data/user_repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../constants.dart';
import '../models/main_coin_model.dart';
import '../services/appwrite_service.dart';
import 'package:flutter_udid/flutter_udid.dart';
class FavoritesRepository extends ChangeNotifier {


final db = di<ApiClient>().database;
final realtime = di<ApiClient>().realtime;


late RealtimeSubscription favoritesSubscription;
StreamSubscription<dynamic>? favoritesStreamSubscription;
List<MainCoinModel> favoritesList = [];
late Document userDoc;
List<String> idsList = [];

Map<String, String> error = {};
FavoritesRepository() {
  error[DateTime.now().toLocal().toString()] = "FavoritesRepository.init";

  startFavoritesStream();
  updateFavoritesList();
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





Future<void> addToFavorites(String id) async {
  String device = await FlutterUdid.udid;
  debugPrint('Start addToFavorites');
  idsList.contains(id)
  ? null
  : idsList.add(id);
  var userId = di<UserRepository>().user?.$id;

  if ( userId != null) {
    try {
      debugPrint('updateDocument');
      debugPrint('udid: $userId');

      userDoc = await db.updateDocument(
        databaseId: databaseId,
        collectionId: userCollection,
        documentId: userId,
        data: {"device": device, "favorites_ids": idsList,},
      );

      debugPrint(
          'Document updated. favorites_ids: ${userDoc.data['favorites_ids']}');
      debugPrint('Document updated. device: ${userDoc.data['device']}');
    } on AppwriteException catch (e) {
      if (e.code == 404 &&
          e.message == "Document with the requested ID could not be found.") {
        debugPrint('Document not found: ${e.message}');
        try {
          debugPrint('createDocument');
          userDoc = await db.createDocument(
            databaseId: databaseId,
            collectionId: userCollection,
            documentId: userId,
            data: {"device": device, "favorites_ids": idsList,},
            permissions: [
              Permission.write(Role.user(userId)),
              Permission.read(Role.user(userId)),
              Permission.update(Role.user(userId)),
            ],
          );
          debugPrint('Document created: ${userDoc.data}');
        } on AppwriteException catch (e) {
          debugPrint('Error creating document: ${e.message}');
        }
      } else {
        debugPrint('AppwriteException: ${e.message}');
      }
    } catch (e) {
      debugPrint('Error addToFavorites: $e');
    }
  }
}






updateFavoritesList () async {
  debugPrint('Start updateFavoritesList();');
  getUserProfile();
  List<MainCoinModel> temp = [];
  for (String id in idsList) {

    try {
      Document doc = await db.getDocument(
          databaseId: databaseId,
          collectionId: coinDataCollection,
          documentId: id);
      MainCoinModel mainModel = await di<CurrencyRepository>().parseData(
          doc.data);
      temp.add(mainModel);
      debugPrint('Document added to favorites()doc.data; ${doc.data}');
    } catch (e) {
      debugPrint('Error updateFavoritesList: $e');
    }
  }
  if(temp.isNotEmpty)
  {favoritesList = temp;}
  notifyListeners();

}




Future getUserProfile() async {
  debugPrint('Start getUserProfile();');
  var userId = di<UserRepository>().user?.$id;

  if ( userId != null) {
    try {
      userDoc = await db.getDocument(
        databaseId: databaseId,
        collectionId: userCollection,
        documentId: userId,
      );
      debugPrint('userDoc.data; ${userDoc.data['favorites_ids']}');
      debugPrint('userDoc.data runtimeType; ${userDoc.data['favorites_ids']
          .runtimeType}');

      List<dynamic> parsedList = userDoc.data['favorites_ids'];
      idsList = parsedList.map((e) => e.toString()).toList();
    } on AppwriteException catch (e) {
      debugPrint('Error fetching user profile: ${e.message}');
      rethrow;
    }
    notifyListeners();

  }

}



Future<void> startFavoritesStream() async {
  error[DateTime.now().toLocal().toString()] = "Ok";

  debugPrint('startFavoritesStream');
  favoritesStreamSubscription?.cancel();

  favoritesSubscription = realtime.subscribe([
    'databases.$databaseId.collections.$userCollection.documents'
  ]);

  favoritesStreamSubscription = favoritesSubscription.stream.listen((response) async {
    debugPrint("favoritesStreamSubscription response.payload: ${response.payload}");
  });

  favoritesStreamSubscription?.onData((data) async {
    debugPrint('New event from favoritesStreamSubscription: ${DateTime.now().toIso8601String()}');
    // debugPrint(data.runtimeType.toString());

    // MainCoinModel mainModel = await parseData(data.payload);
    // top100ModelsList = top100ModelsList.map((model) {
    //   return model.id == mainModel.id ? mainModel : model;
    // }).toList();
    updateFavoritesList();
  });





  favoritesStreamSubscription?.onDone(() {
    favoritesStreamSubscription?.cancel();
    error[DateTime.now().toLocal().toString()] = "favoritesStreamSubscription onDone";
    notifyListeners();
    debugPrint('favoritesStreamSubscriptionDone');
    debugPrint('restart: favoritesStreamSubscription()');
    startFavoritesStream();
  });


  favoritesStreamSubscription?.onError((handleError) {
    debugPrint('favoritesStreamSubscription handleError \n $handleError');
    error[DateTime.now().toLocal().toString()] = "favoritesStreamSubscription handleError: $handleError";
    notifyListeners();

  });

}









































}