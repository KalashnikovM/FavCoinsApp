import 'dart:typed_data';

class CoinDataModel {
  final int id;
  final String? name;
  final String? symbol;
  final String? category;
  final String? description;
  final Uint8List? logo;




  CoinDataModel({
    required this.id,
     this.name,
     this.symbol,
     this.category,
     this.description,
     this.logo,

  });

  factory CoinDataModel.fromJson(Map<String, dynamic> json, logo) {

    List<int> intList = logo.whereType<int>().toList();
    Uint8List logoData = Uint8List.fromList(intList);

    return CoinDataModel(
      id: json['id'],
      name: json['name'],
      symbol: json['symbol'],
      category: json['category'],
      description: json['description'],
      logo: logoData,


    );
  }
}
