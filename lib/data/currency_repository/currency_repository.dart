import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:crypto_tracker/models/coin_quote.dart';
import 'package:crypto_tracker/models/coin_data_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:watch_it/watch_it.dart';
import '../../constants.dart';
import '../../models/main_coin_model.dart';
import '../../services/appwrite_service.dart';


enum CurrencyRepositoryStatus {
  init,
  updated,
  updating,
  error,
}


class CurrencyRepository extends ChangeNotifier {

  List<MainCoinModel> top100ModelsList = [];
  List<MainCoinModel> foundElementsList = [];

  final db = di<ApiClient>().database;
  final realtime = di<ApiClient>().realtime;
  late RealtimeSubscription top100Subscription;
  StreamSubscription<dynamic>? top100StreamSubscription;
  CurrencyRepositoryStatus status = CurrencyRepositoryStatus.init;
  bool testStream = false;
  String error = '';
  CurrencyRepository() {
    getLastCurrencyRateList();
    startTop100Stream();
  }

  get resList => foundElementsList.clear();




  Future<bool> searchCoin (String name) async {
    debugPrint('searchCoin');
    debugPrint(name);
    bool res = false;
    top100ModelsList.isNotEmpty

        ? top100ModelsList.forEach((element) {
        if(element.coinDataModel.symbol == name.toUpperCase()) {
          foundElementsList.add(element);
          res = true;
        }})

        : {res = false,
            foundElementsList = []};
    debugPrint("$res");

    return res;
  }



  Future<void> getLastCurrencyRateList() async {
    debugPrint('getLastCurrencyRateList');
    status = CurrencyRepositoryStatus.updating;
    notifyListeners();

    try {
      final response = await db.listDocuments(
        databaseId: databaseId,
        collectionId: coinDataCollection,
        queries: [Query.limit(100)],
      );

      final DocumentList docs = response;
      top100ModelsList.clear();

      debugPrint('docs.documents.length: ${docs.documents.length}');

      for (final Document document in docs.documents) {
        final CoinDataModel coinData = CoinDataModel.fromJson(json.decode(document.data['Data']), document.data["Logo"]);
        final Map<String, dynamic> lastData = json.decode(document.data['Quote']);
        final CoinQuote coinQuote = CoinQuote.fromJson(document.$id, lastData["USD"]);
        final MainCoinModel mainCoinModel = MainCoinModel.fromJson(document.$id, coinData, coinQuote);
        top100ModelsList.add(mainCoinModel);
      }
      status = CurrencyRepositoryStatus.updated;

      notifyListeners();
    } catch (e) {
      status = CurrencyRepositoryStatus.error;
      error = "getLastCurrencyRateList Error: $e";

      debugPrint('Error fetching last currency rate list: $e');
    }
  }

  Future<void> startTop100Stream() async {
    error = "Ok";
    debugPrint('startTop100Stream');
    top100StreamSubscription?.cancel();

    top100Subscription = realtime.subscribe([
      'databases.$databaseId.collections.$coinDataCollection.documents'
    ]);

    top100StreamSubscription = top100Subscription.stream.listen((response) async {
      debugPrint("top100StreamSubscription response.payload: ${response.payload}");
    });




    testStream = true;
    top100StreamSubscription?.onData((data) async {
      final Map<String, dynamic> result = data.payload;
      debugPrint('New event from top100StreamSubscription: ${DateTime.now().toIso8601String()}');
      var logoString = result["Logo"];
      final CoinDataModel coinData = CoinDataModel.fromJson(json.decode(result['Data']), logoString);
      final Map<String, dynamic> coinQuote = json.decode(result["Quote"]);
      final CoinQuote quote = CoinQuote.fromJson(coinData.id.toString(), coinQuote["USD"]);
      final MainCoinModel newModel = MainCoinModel.fromJson(coinData.id.toString(), coinData, quote);

      top100ModelsList = top100ModelsList.map((model) {
        return model.id == newModel.id ? newModel : model;
      }).toList();
      testStream = true;
      notifyListeners();
    });





    top100StreamSubscription?.onDone(() {
      testStream = false;
      top100StreamSubscription?.cancel();
      error = "Top100 Stream Subscription onDone";

      notifyListeners();

      debugPrint('Top100 Stream Subscription Done');
    });




    top100StreamSubscription?.onError((handleError) {

      debugPrint('Top100 Stream Subscription handleError \n $handleError');
      error = "Top100 Stream Subscription handleError: $handleError";
      testStream = false;
      notifyListeners();



    });








  }



  @override
  void dispose() {
    top100StreamSubscription?.cancel();
    super.dispose();
  }
}
