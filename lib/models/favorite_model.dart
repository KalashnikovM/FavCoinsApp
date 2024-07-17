class FavoriteCoinModel {
  final String id;
  final Map<String, dynamic> transactions;



  FavoriteCoinModel( {
    required this.id,
    required this.transactions,


  });

  factory FavoriteCoinModel.fromJson(String id, transactions,) {
    return FavoriteCoinModel(
      id: id,
      transactions: transactions,

    );
  }







}