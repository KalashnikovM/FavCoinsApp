


import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../constants.dart';
import '../services/appwrite_service.dart';

class FavoritesRepository extends ChangeNotifier {


final db = di<ApiClient>().database;
final realtime = di<ApiClient>().realtime;

late RealtimeSubscription favoritesSubscription;
StreamSubscription<dynamic>? favoritesStreamSubscription;



Map<String, String> error = {};
FavoritesRepository() {
  error[DateTime.now().toLocal().toString()] = "FavoritesRepository.init";

  startFavoritesStream();
  // startTestStream();
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
    // MainCoinModel mainModel = await parseData(data.payload);
    // top100ModelsList = top100ModelsList.map((model) {
    //   return model.id == mainModel.id ? mainModel : model;
    // }).toList();

    notifyListeners();
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