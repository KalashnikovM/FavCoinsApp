class FavoriteCoinModel {
  final String id;
  final Map<String, dynamic> transactions;
  final double? totalCoinVal;
  final double? totalPayedVal;


  FavoriteCoinModel( {
    required this.id,
    required this.transactions,
    this.totalCoinVal,
    this.totalPayedVal,

  });

  factory FavoriteCoinModel.fromJson(String id, transactions,) {
    return FavoriteCoinModel(
      id: id,
      transactions: transactions,
      totalCoinVal: 0,
      totalPayedVal: 0,

    );
  }







}