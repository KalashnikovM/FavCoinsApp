import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import '../../../constants.dart';
import '../../../models/main_coin_model.dart';
import '../../../services/appwrite_service.dart';
import '../../../services/parse_data_service.dart';




enum FavoritesRepositoryStatus {
  init,
  updated,
  updating,
  error,
}



class FavoritesRepository extends ChangeNotifier {
  List<MainCoinModel> favoritesList = [];
  final db = di<ApiClient>().database;
  Map<String, String> favoritesRepositoryError = {};

  get clearFav => favoritesList.clear();

  FavoritesRepository() {
    debugPrint('init FavoritesRepository();');

    favoritesRepositoryError[DateTime.now().toLocal().toString()] = "FavoritesRepository.init";
    updateFavoritesList([]);
  }

  Future<void> updateFavoritesList(List<String> ids) async {
    debugPrint('Start updateFavoritesList();');
    List<MainCoinModel> temp = [];
    for (String id in ids) {
      try {
        Document doc = await db.getDocument(
            databaseId: databaseId,
            collectionId: coinDataCollection,
            documentId: id);
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
}



