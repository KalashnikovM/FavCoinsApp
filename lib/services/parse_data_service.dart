


import 'dart:convert';

import '../models/coin_data_model.dart';
import '../models/coin_quote.dart';
import '../models/main_coin_model.dart';

class ParsingService {


  Future<MainCoinModel> parseData(Map<String, dynamic> data) async {
    final CoinDataModel coinData = CoinDataModel.fromJson(json.decode(data['Data']), data["Logo"]);
    final Map<String, dynamic> lastData = json.decode(data['Quote']);
    final CoinQuote coinQuote = CoinQuote.fromJson(coinData.id.toString(), lastData["USD"]);
    final MainCoinModel mainCoinModel = MainCoinModel.fromJson(coinData.id.toString(), coinData, coinQuote);
    return mainCoinModel;
  }

}