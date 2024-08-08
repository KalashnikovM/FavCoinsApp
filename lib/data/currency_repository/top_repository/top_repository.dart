import 'dart:async';
import 'dart:convert';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../../app_env.dart';
import '../../../models/coin_data_model.dart';
import '../../../models/coin_quote.dart';
import '../../../models/main_coin_model.dart';
import '../../../services/appwrite_service.dart';




enum Top100RepositoryStatus {
  init,
  updated,
  updating,
  error,
}




class Top100Repository extends ChangeNotifier {
  List<MainCoinModel> top100ModelsList = [];
  Map<String, String> top100RepositoryError = {};
  final db = di<ApiClient>().database;
  final realtime = di<ApiClient>().realtime;

  late RealtimeSubscription top100Subscription;
  StreamSubscription<dynamic>? top100StreamSubscription;
  Top100RepositoryStatus top100RepositoryStatus = Top100RepositoryStatus.init;
  bool top100Stream = false;

  Top100Repository() {
    debugPrint('init Top100Repository();');

    top100RepositoryError[DateTime.now().toLocal().toString()] = "Top100Repository.init";
    getLastCurrencyRateList();
    initTop100Stream();
  }




  // Function to fetch the last currency rate list
  Future<void> getLastCurrencyRateList() async {
    debugPrint('getLastCurrencyRateList');
    top100RepositoryStatus = Top100RepositoryStatus.updating;
    notifyListeners();

    try {
      final response = await db.listDocuments(
        databaseId: AppEnv.databaseId,
        collectionId: AppEnv.top100Collection,
        queries: [Query.limit(100)],
      );
      final DocumentList docs = response;
      top100ModelsList.clear();
      debugPrint('docs.documents.length: ${docs.documents.length}');
      for (final Document document in docs.documents) {
        MainCoinModel mainModel = await parseData(document.data);
        top100ModelsList.add(mainModel);
      }
      top100RepositoryStatus = Top100RepositoryStatus.updated;
      notifyListeners();
    } catch (e) {
      top100RepositoryStatus = Top100RepositoryStatus.error;
      top100RepositoryError[DateTime.now().toLocal().toString()] = "getLastCurrencyRateList Error: $e";
      debugPrint('Error fetching last currency rate list: $e');
    }
  }




  // Function to initialize the real-time stream for top 100 coins
  Future<void> initTop100Stream() async {
    top100RepositoryError[DateTime.now().toLocal().toString()] = "Ok";
    debugPrint('initTop100Stream');
    top100StreamSubscription?.cancel();

    top100Subscription = realtime.subscribe([
      'databases.${AppEnv.databaseId}.collections.${AppEnv.top100Collection}.documents'
    ]);

    top100StreamSubscription = top100Subscription.stream.listen((response) async {
      debugPrint("top100StreamSubscription response.payload: ${response.payload}");
    });

    top100Stream = true;
    top100StreamSubscription?.onData((data) async {
      MainCoinModel mainModel = await parseData(data.payload);
      top100ModelsList = top100ModelsList.map((model) {
        return model.id == mainModel.id ? mainModel : model;
      }).toList();

      top100Stream = true;
      notifyListeners();
    });

    top100StreamSubscription?.onDone(() {
      top100Stream = false;
      top100StreamSubscription?.cancel();
      top100RepositoryError[DateTime.now().toLocal().toString()] = "Top100 Stream Subscription onDone";
      notifyListeners();
      debugPrint('Top100 Stream Subscription Done');
      debugPrint('restart: startTop100Stream()');
      initTop100Stream();
    });

    top100StreamSubscription?.onError((handleError) {
      debugPrint('Top100 Stream Subscription handleError \n $handleError');
      top100RepositoryError[DateTime.now().toLocal().toString()] = "Top100 Stream Subscription handleError: $handleError";
      top100Stream = false;
      notifyListeners();
    });
  }




  // Function to parse data into a MainCoinModel
  Future<MainCoinModel> parseData(Map<String, dynamic> data) async {
    final CoinDataModel coinData = CoinDataModel.fromJson(json.decode(data['Data']), data["Logo"]);
    final Map<String, dynamic> lastData = json.decode(data['Quote']);
    final CoinQuote coinQuote = CoinQuote.fromJson(coinData.id.toString(), lastData["USD"]);
    final MainCoinModel mainCoinModel = MainCoinModel.fromJson(coinData.id.toString(), coinData, coinQuote);
    return mainCoinModel;
  }

  @override
  void dispose() {
    top100StreamSubscription?.cancel();
    super.dispose();
  }
}