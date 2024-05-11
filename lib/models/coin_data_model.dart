class CoinDataModel {
  final int id;
  final String? name;
  final String? symbol;
  final String? category;
  final String? description;
  final String? logo;



  CoinDataModel({
    required this.id,
     this.name,
     this.symbol,
     this.category,
     this.description,
     this.logo

  });

  factory CoinDataModel.fromJson(Map<String, dynamic> json) {


    return CoinDataModel(
      id: json['id'],
      name: json['name'],
      symbol: json['symbol'],
      category: json['category'],
      description: json['description'],
      logo: json['logo'],


    );
  }
}
