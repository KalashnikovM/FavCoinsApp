import 'dart:convert';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../../constants.dart';
import '../../../models/main_coin_model.dart';
import '../../../services/appwrite_service.dart';
import '../../../services/parse_data_service.dart';



enum GlobalListRepositoryStatus {
  init,
  updated,
  updating,
  error,
}




class GlobalListRepository extends ChangeNotifier {
  List<MainCoinModel> mainCoinsList = [];
  GlobalListRepositoryStatus globalListRepositoryStatus = GlobalListRepositoryStatus.init;
  Map<String, String> globalListError = {};
  Map<String, dynamic> coinMapList = {};
  List<MainCoinModel> foundedElementsList = [];
  int current = 0;


   get resList => foundedElementsList.clear();


  final db = di<ApiClient>().database;

  GlobalListRepository() {
    debugPrint('init GlobalListRepository();');

    globalListError[DateTime.now().toLocal().toString()] = "MainCoinsListRepository.init";
    updateMainList();
    _updateCoinMapList();
  }

  Future<void> updateMainList() async {
    debugPrint('updateMainList');

    try {
      globalListRepositoryStatus = GlobalListRepositoryStatus.updating;
      notifyListeners();
      final DocumentList docs = await db.listDocuments(
        databaseId: databaseId,
        collectionId: coinDataCollection,
        queries: [Query.limit(100), Query.offset(0 + mainCoinsList.length)],
      );
      debugPrint('docs.documents.length: ${docs.documents.length}');
      for (final Document document in docs.documents) {
        MainCoinModel mainModel = await ParsingService().parseDataToMainCoinModel(document.data);
        mainCoinsList.add(mainModel);
      }
      globalListRepositoryStatus = GlobalListRepositoryStatus.updated;
      notifyListeners();
    } catch (e) {
      globalListRepositoryStatus = GlobalListRepositoryStatus.error;
      globalListError[DateTime.now().toLocal().toString()] = "updateMainList Error: $e";
      debugPrint('Error fetching main coins list: $e');
      notifyListeners();
    }
  }


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
            MainCoinModel foundedModel = await ParsingService().parseDataToMainCoinModel(response.data);

            foundedElementsList.add(foundedModel);
            debugPrint(foundedModel.id);
            found = true;
          } catch (e) {
            globalListError[DateTime.now().toLocal().toString()] = "getTestList Error: $e";
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
    try {
      final DocumentList docs = await db.listDocuments(
        databaseId: databaseId,
        collectionId: coinMapCollection,
        queries: [
          Query.limit(current),
          Query.offset(0 + coinMapList.length),
        ],

      );
      for (var document in docs.documents) {
        Map<String, dynamic> data = document.data;
        coinMapList[document.$id] = {
          data["Name"]: data["Symbol"]};
      }

      if (current < docs.total) {
        _updateCoinMapList();
      }
    }
    catch (e) {

      debugPrint("error _updateCoinMapList(): $e");

    }

    debugPrint("coinMapList length : ${coinMapList.length}");
    notifyListeners();

  }



}