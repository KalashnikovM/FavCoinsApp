import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:appwrite/models.dart';
import '../models/coin_data_model.dart';
import '../models/coin_quote.dart';
import '../models/favorite_model.dart';
import '../models/main_coin_model.dart';

class ParsedUserData {
  final List<FavoriteCoinModel> favList;
  final List<dynamic> alertsList;
  final List<String> ids;

  ParsedUserData(this.favList, this.alertsList, this.ids);
}



// Function to parse user data from a Document
Future<ParsedUserData> parseUserData(Document userDoc) async {
  debugPrint('Start parseData();');
  List<FavoriteCoinModel> favList = [];
  List<dynamic> alertsList = [];
  List<String> ids = [];

  try {
    List<dynamic> favorites = userDoc.data['favorites'];
    for (var value in favorites) {
      Map<String, dynamic> decodedValue = jsonDecode(value);

      decodedValue.forEach((key, value) {
        ids.add(key);
        value.forEach((k, v) {
          debugPrint('k: $k');
          debugPrint('v: $v');
        });

        favList.add(FavoriteCoinModel.fromJson(key, value));
      });
    }
    debugPrint('favList: $favList');
    debugPrint('userDoc.data[Alerts]: ${userDoc.data['Alerts']}');
    List<dynamic> alerts = userDoc.data['Alerts'];
    alertsList.addAll(alerts);
    debugPrint('alerts: $alerts \nalerts.runtimeType: ${alerts.runtimeType}');
    debugPrint('alertsList: $alertsList');
  } catch (e) {
    debugPrint('Error parsing data: $e');
  }

  return ParsedUserData(favList, alertsList, ids);
}



// Service class for parsing data
class ParsingService {
  Future<MainCoinModel> parseDataToMainCoinModel(
      Map<String, dynamic> data) async {
    final CoinDataModel coinData =
        CoinDataModel.fromJson(json.decode(data['Data']), data["Logo"]);
    final Map<String, dynamic> lastData = json.decode(data['Quote']);
    final CoinQuote coinQuote =
        CoinQuote.fromJson(coinData.id.toString(), lastData["USD"]);
    final MainCoinModel mainCoinModel =
        MainCoinModel.fromJson(coinData.id.toString(), coinData, coinQuote);
    return mainCoinModel;
  }
}
