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
  List<MainCoinModel> mainCoinsList = [];
  Map<String, dynamic> coinMapList = {};


  final db = di<ApiClient>().database;
  final realtime = di<ApiClient>().realtime;
  final functions = di<ApiClient>().functions;

  late RealtimeSubscription top100Subscription;
  StreamSubscription<dynamic>? top100StreamSubscription;
  CurrencyRepositoryStatus top100PageStatus = CurrencyRepositoryStatus.init;
  CurrencyRepositoryStatus mainListPageStatus = CurrencyRepositoryStatus.init;


  bool top100Stream = false;
  bool testStream = false;

  int current = 0;



  get test => _updateCoinMapList();

  get trigger => updateMainList();


  Map<String, String> error = {};
  CurrencyRepository() {
    error[DateTime.now().toLocal().toString()] = "CurrencyRepository.init";

    getLastCurrencyRateList();
    updateMainList();
    startTop100Stream();
    _updateCoinMapList();
    // startTestStream();
  }

  get resList => foundElementsList.clear();



  Future<bool> searchByPartialNameAndSymbol(String searchString) async {
    debugPrint("start searchByPartialNameAndSymbol().searchString# $searchString");
    bool found = false;

    for (var id in coinMapList.keys) {
      var coinData = coinMapList[id];

      for (var name in coinData.keys) {
        var symbol = coinData[name];

        if (name == searchString || symbol == searchString) {
          try {
            Document response = await db.getDocument(
              databaseId: databaseId,
              collectionId: coinDataCollection,
              documentId: id,
            );
            MainCoinModel foundedModel = await parseData(response.data);

            foundElementsList.add(foundedModel);
            debugPrint(foundedModel.id);
            found = true;
          } catch (e) {
            error[DateTime.now().toLocal().toString()] = "getTestList Error: $e";
            debugPrint('Error fetching last currency rate list: $e');
          }
        }
      }
    }

    debugPrint('found: $found');
    return found;
  }





    _updateCoinMapList () async {
      debugPrint("start _updateCoinMapList()");
      current += 2000;
      final DocumentList docs = await db.listDocuments(
        databaseId: databaseId,
        collectionId: coinMapCollection,
        queries: [
          Query.limit(current),
           Query.offset(0+coinMapList.length),
        ],

      );
      for (var document in docs.documents) {
        Map<String, dynamic> data = document.data;
        coinMapList[document.$id] = {
          data["Name"]: data["Symbol"]};
      }

      if(current < docs.total){
        _updateCoinMapList();
      }

      debugPrint("coinMapList length : ${coinMapList.length}");
      notifyListeners();

    }








   searchCoin (String name) {
    debugPrint('searchCoin');
    debugPrint(name);
    bool res = false;
    top100ModelsList.isNotEmpty

        ? top100ModelsList.forEach((element) {
        if(element.coinDataModel?.symbol == name.toUpperCase()) {
          foundElementsList.add(element);
          res = true;
        }})

        : {res = false,
            foundElementsList = []};
    debugPrint("$res");

    return res;
  }









Future<bool> getFunc(String symbol) async{
  bool res = false;

  debugPrint('result functions.createExecution();');
  Execution result = await functions.createExecution(
    functionId: '65f96862ad619d34eadf',
      body: symbol,
  );

  if(result.responseStatusCode == 200)
       {
    Map<String, dynamic> body = jsonDecode(result.responseBody);
    final Map<String, dynamic> bodyBata = body['data'];
    var data = bodyBata[symbol.toUpperCase()];
           debugPrint('${data.runtimeType}\data: $data');
        for(var item in data) {
          debugPrint('quote: ${item["quote"]}');

          try {

            final response = await db.getDocument(
              databaseId: databaseId,
              collectionId: coinDataCollection,
              documentId: item["id"].toString(),
            );
            final Document doc = response;
            MainCoinModel mainModel = await parseData(doc.data);


            foundElementsList.add(mainModel);
            debugPrint(mainModel.id);
            res = true;
          } catch (e) {
            res = false;
            error[DateTime.now().toLocal().toString()] = "getTestList Error: $e";
            debugPrint('Error fetching last currency rate list: $e');
          }}}
        else {
    debugPrint('result responseStatusCode() ${result.responseStatusCode}');
    res = false;

  }

  debugPrint('result status() ${result.status}');
        return res;

}




  Future<void> updateMainList() async {
    debugPrint('updateMainList');


    try {
      mainListPageStatus = CurrencyRepositoryStatus.updating;
      notifyListeners();
      final DocumentList docs = await db.listDocuments(
        databaseId: databaseId,
        collectionId: coinDataCollection,
        queries: [Query.limit(100), Query.offset(0+mainCoinsList.length)],
      );
      debugPrint('docs.documents.length: ${docs.documents.length}');
      for (final Document document in docs.documents) {
        MainCoinModel mainModel = await parseData(document.data);
        mainCoinsList.add(mainModel);
      }
      mainListPageStatus = CurrencyRepositoryStatus.updated;
      notifyListeners();
    } catch (e) {
      mainListPageStatus = CurrencyRepositoryStatus.error;
      error[DateTime.now().toLocal().toString()] = "getTestList Error: $e";
      debugPrint('Error fetching last currency rate list: $e');
      notifyListeners();

    }
  }


  Future<void> getLastCurrencyRateList() async {
    debugPrint('getLastCurrencyRateList');
    top100PageStatus = CurrencyRepositoryStatus.updating;
    notifyListeners();

    try {
      final response = await db.listDocuments(
        databaseId: databaseId,
        collectionId: top100coinDataCollection,
        queries: [Query.limit(100)],
      );
      final DocumentList docs = response;
      top100ModelsList.clear();
      debugPrint('docs.documents.length: ${docs.documents.length}');
      for (final Document document in docs.documents) {
        MainCoinModel mainModel = await parseData(document.data);
        top100ModelsList.add(mainModel);
      }
      top100PageStatus = CurrencyRepositoryStatus.updated;
      notifyListeners();
    } catch (e) {
      top100PageStatus = CurrencyRepositoryStatus.error;
      error[DateTime.now().toLocal().toString()] = "getLastCurrencyRateList Error: $e";
      debugPrint('Error fetching last currency rate list: $e');
    }
  }

  Future<void> startTop100Stream() async {
    error[DateTime.now().toLocal().toString()] = "Ok";

    debugPrint('startTop100Stream');
    top100StreamSubscription?.cancel();

    top100Subscription = realtime.subscribe([
      'databases.$databaseId.collections.$top100coinDataCollection.documents'
    ]);

    top100StreamSubscription = top100Subscription.stream.listen((response) async {
      debugPrint("top100StreamSubscription response.payload: ${response.payload}");
    });

    top100Stream = true;
    top100StreamSubscription?.onData((data) async {
      // debugPrint('New event from top100StreamSubscription: ${DateTime.now().toIso8601String()}');
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
      error[DateTime.now().toLocal().toString()] = "Top100 Stream Subscription onDone";
      notifyListeners();
      debugPrint('Top100 Stream Subscription Done');
      debugPrint('restart: startTop100Stream()');
      startTop100Stream();
    });


    top100StreamSubscription?.onError((handleError) {
      debugPrint('Top100 Stream Subscription handleError \n $handleError');
      error[DateTime.now().toLocal().toString()] = "Top100 Stream Subscription handleError: $handleError";
      top100Stream = false;
      notifyListeners();

    });

  }




  Future<MainCoinModel>parseData(Map<String, dynamic> data) async {
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
