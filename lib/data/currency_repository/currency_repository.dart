import 'dart:async';
import 'dart:convert';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:crypto_tracker/models/coin_quote.dart';
import 'package:crypto_tracker/models/coin_data_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:watch_it/watch_it.dart';
import '../../constants.dart';
import '../../models/main_coin_model.dart';
import '../../services/appwrite_service.dart';

class CurrencyRepository extends ChangeNotifier {
  final List<MainCoinModel> mainCoinModelList = [];
  late List<MainCoinModel> testCoinModelList = [];

  var db = di<ApiClient>().database;
  var realtime = di<ApiClient>().realtime;
  late String collectionId;
  late RealtimeSubscription subscription;
  StreamSubscription<dynamic>? _streamSubscription;
  late RealtimeSubscription testSubscription;
  StreamSubscription<dynamic>? _testStreamSubscription;
  bool testStream = false;

  get startTestStream => startTestCollectionStream();

  get startStream => startAppCollectionsStream();
  get getLastRateList => getLastCurrencyRateList();

  Future<void> sendTestData(String data) async {
    debugPrint('sendTestData \n data $data');

    testStream = false;
    db.updateDocument(
      databaseId: databaseId,
      collectionId: mainCollection,
      documentId: mainDocumentId,
      data: {"checkField": data},
    );
  }

  Future<void> startAppCollectionsStream() async {
    debugPrint('startAppCollectionsStream');

    String checkData = DateTime.timestamp().toString();
    debugPrint("#################checkData: $checkData");

    subscription = realtime.subscribe([
      'databases.$databaseId.collections.$mainCollection.documents.$mainDocumentId'
    ]);
    _streamSubscription = subscription.stream.listen((response) async {
      debugPrint("response.payload: ${response.payload.toString()}");
    });

    debugPrint("_acSubscription - start listen!!!!!");

    _streamSubscription?.onDone(() {
      canselSubscription();
      debugPrint('_acSubscription?.onDone');
    });

    testStream ? null : await sendTestData(checkData);

    _streamSubscription?.onData((data) async {
      data.runtimeType == RealtimeMessage
          ? {
              debugPrint('data.payload ${data.payload}'),

              data.payload["checkField"] == checkData
                  ? testStream = true
                  : null,

              debugPrint("testStream - $testStream"),

              debugPrint(
                  "response.payload[mainCollectionAttribute]: ${data.payload[mainCollectionAttribute]}"),

              // getLastCurrencyRateList(data.payload[mainCollectionAttribute]),
            }
          : {
              debugPrint('_acSubscription?.onData $data'),
              debugPrint('data.runtimeType ${data.runtimeType}'),
            };
    });
  }

  void canselSubscription() {
    debugPrint('canselSubscription');
    testStream = false;
    _streamSubscription?.cancel();
    subscription.close;

    _testStreamSubscription?.cancel();
    testSubscription.close;
    notifyListeners();
  }

  getLastCurrencyRateList() async {
    debugPrint('getLastCurrencyRateList');

    try {
      Future result = db.listDocuments(
        databaseId: databaseId,
        collectionId: testStreamCollectionData,
        queries: [
          Query.limit(100),
        ],
      );
      await result.then((response) {
        DocumentList docs = response;

        testCoinModelList.clear();
        debugPrint(
            'docs.documents.length: ${docs.documents.length.toString()}');

        for (Document document in docs.documents) {
          String documentId = document.$id;
          debugPrint('documentId: $documentId');
          CoinDataModel coinData =
              CoinDataModel.fromJson(json.decode(document.data['Data']));
          Map<String, dynamic> lastData = json.decode(document.data['Quote']);
          CoinQuote coinQuote = CoinQuote.fromJson(documentId, lastData["USD"]);
          MainCoinModel mainCoinModel =
              MainCoinModel.fromJson(documentId, coinData, coinQuote);
          testCoinModelList.add(mainCoinModel);
        }
      }).catchError((error) {
        debugPrint(error.toString());
        debugPrint(error.runtimeType.toString());
      });
    } catch (e) {
      // Handle error here
    }

    notifyListeners();
  }

  Future<void> startTestCollectionStream() async {
    debugPrint('startTestCollectionStream');

    testSubscription = realtime.subscribe([
      'databases.$databaseId.collections.$testStreamCollectionData.documents'
    ]);
    _testStreamSubscription = testSubscription.stream.listen((response) async {
      debugPrint(
          "_testStreamSubscription response.payload: ${response.payload.toString()}");
    });

    debugPrint("_testStreamSubscription - start listen!!!!!");

    _testStreamSubscription?.onDone(() {
      _testStreamSubscription?.cancel();
      testSubscription.close;
      debugPrint('_testStreamSubscription?.onDone');
      notifyListeners();
    });

    _testStreamSubscription?.onData((data) async {
      Map<String, dynamic> result = data.payload;
      debugPrint('new ivent from  _testStreamSubscription${DateTime.now()}');

      CoinDataModel coinData =
          CoinDataModel.fromJson(json.decode(result['Data']));
      Map<String, dynamic> cq = json.decode(result["Quote"]);
      CoinQuote coinQuote =
          CoinQuote.fromJson(coinData.id.toString(), cq["USD"]);

      MainCoinModel newModel =
          MainCoinModel.fromJson(coinData.id.toString(), coinData, coinQuote);
      List<MainCoinModel> newList = [];
      for (MainCoinModel model in testCoinModelList) {
        model.id == newModel.id ? newList.add(newModel) : newList.add(model);
      }
      testCoinModelList = newList;

      notifyListeners();
    });
  }
}
