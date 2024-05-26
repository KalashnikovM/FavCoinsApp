

import 'coin_data_model.dart';
import 'coin_quote.dart';

class MainCoinModel {
  final String id;
  final CoinDataModel coinDataModel;
  final CoinQuote coinQuote;


  MainCoinModel({
    required this.id,
    required this.coinDataModel,
    required this.coinQuote,

  });

  factory MainCoinModel.fromJson(String id, coinDataModel, coinQuote) {
    return MainCoinModel(
      id: id,
      coinDataModel: coinDataModel,
      coinQuote: coinQuote,

    );
  }
}






