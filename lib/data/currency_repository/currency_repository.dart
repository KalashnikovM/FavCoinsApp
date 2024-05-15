import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
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

class CurrencyRepository extends ChangeNotifier {
  final List<MainCoinModel> mainCoinModelList = [];
  List<MainCoinModel> top100ModelsList = [];

  final db = di<ApiClient>().database;
  final realtime = di<ApiClient>().realtime;

  // late RealtimeSubscription appCollectionSubscription;
  // StreamSubscription<dynamic>? appCollectionStreamSubscription;

  late RealtimeSubscription top100Subscription;
  StreamSubscription<dynamic>? top100StreamSubscription;

  bool testStream = false;

  CurrencyRepository() {
    // Initialize.
   // startAppCollectionsStream();
    getLastCurrencyRateList();
    startTop100Stream();
  }

  Future<void> sendTestData(String data) async {
    debugPrint('sendTestData \n data $data');
    testStream = false;

    try {
      await db.updateDocument(
        databaseId: databaseId,
        collectionId: mainCollection,
        documentId: mainDocumentId,
        data: {"checkField": data},
      );
    } catch (e) {
      debugPrint('Error sending test data: $e');
    }
  }


  Future<void> getLastCurrencyRateList() async {
    debugPrint('getLastCurrencyRateList');

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
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching last currency rate list: $e');
    }
  }

  Future<void> startTop100Stream() async {
    debugPrint('startTop100Stream');

    top100Subscription = realtime.subscribe([
      'databases.$databaseId.collections.$coinDataCollection.documents'
    ]);

    top100StreamSubscription = top100Subscription.stream.listen((response) async {
      debugPrint("top100StreamSubscription response.payload: ${response.payload}");
    });
    testStream = true;

    top100StreamSubscription?.onDone(() {
      testStream = false;
      top100StreamSubscription?.cancel();
      notifyListeners();
      debugPrint('Top100 Stream Subscription Done');
    });

    top100StreamSubscription?.onData((data) async {
      final Map<String, dynamic> result = data.payload;
      debugPrint('New event from top100StreamSubscription: ${DateTime.now().toIso8601String()}');
      var logoString = result["Logo"];
      final CoinDataModel coinData = CoinDataModel.fromJson(json.decode(result['Data']), logoString);
      final Map<String, dynamic> cq = json.decode(result["Quote"]);
      final CoinQuote coinQuote = CoinQuote.fromJson(coinData.id.toString(), cq["USD"]);
      final MainCoinModel newModel = MainCoinModel.fromJson(coinData.id.toString(), coinData, coinQuote);

      top100ModelsList = top100ModelsList.map((model) {
        return model.id == newModel.id ? newModel : model;
      }).toList();

      notifyListeners();
    });
  }

  networkImageToBytes(String imageUrl) async {
    debugPrint('networkImageToBytes');

    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      debugPrint(response.bodyBytes.runtimeType.toString());
    } else {
      throw Exception('Failed to load image');
    }
  }


  @override
  void dispose() {
    // appCollectionStreamSubscription?.cancel();
    top100StreamSubscription?.cancel();
    super.dispose();
  }
}




// Future<void> startAppCollectionsStream() async {
//   debugPrint('startAppCollectionsStream');
//   final String checkData = DateTime.timestamp().toString();
//   debugPrint("#################checkData: $checkData");
//
//   appCollectionSubscription = realtime.subscribe([
//     'databases.$databaseId.collections.$mainCollection.documents.$mainDocumentId'
//   ]);
//
//   appCollectionStreamSubscription = appCollectionSubscription.stream.listen((response) async {
//     debugPrint("response.payload: ${response.payload.toString()}");
//   });
//
//   appCollectionStreamSubscription?.onDone(() {
//     debugPrint('App Collection Subscription Done');
//   });
//
//   testStream ? null : await sendTestData(checkData);
//
//   appCollectionStreamSubscription?.onData((data) async {
//     if (data is RealtimeMessage) {
//       debugPrint('data.payload ${data.payload}');
//       if (data.payload["checkField"] == checkData) {
//         testStream = true;
//       }
//       debugPrint("testStream - $testStream");
//       debugPrint("response.payload[mainCollectionAttribute]: ${data.payload[mainCollectionAttribute]}");
//       // Optionally handle the updated data
//       // getLastCurrencyRateList(data.payload[mainCollectionAttribute]);
//     } else {
//       debugPrint('Unhandled data type: ${data.runtimeType}');
//     }
//   });
// }
