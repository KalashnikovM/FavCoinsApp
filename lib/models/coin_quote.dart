
class CoinQuote {
  final String id;
  // final String name;
  // final String symbol;
  final String price;
  final String volume24h;
  final String volumeChange24h;
  final String percentChange1h;
  final String percentChange24h;
  final String percentChange7d;
  final String percentChange30d;
  final String percentChange60d;
  final String percentChange90d;
  final String marketCap;
  final String marketCapDominance;
  final String fullyDilutedMarketCap;
  final DateTime lastUpdated;

  CoinQuote({
    required this.id,
    // required this.name,
    // required this.symbol,
    required this.price,
    required this.volume24h,
    required this.volumeChange24h,
    required this.percentChange1h,
    required this.percentChange24h,
    required this.percentChange7d,
    required this.percentChange30d,
    required this.percentChange60d,
    required this.percentChange90d,
    required this.marketCap,
    required this.marketCapDominance,
    required this.fullyDilutedMarketCap,
    required this.lastUpdated,
  });

  factory CoinQuote.fromJson(String id, Map<String, dynamic> json) {
    return CoinQuote(
      id: id,
      // name: json['name'],
      // symbol: json['symbol'],
      price: convert(json['price'].toDouble(),),
      volume24h: convert(json['volume_24h'].toDouble(),),
      volumeChange24h: convert(json['volume_change_24h'].toDouble(),),
      percentChange1h: convert(json['percent_change_1h'].toDouble(),),
      percentChange24h: convert(json['percent_change_24h'].toDouble(),),
      percentChange7d: convert(json['percent_change_7d'].toDouble(),),
      percentChange30d: convert(json['percent_change_30d'].toDouble(),),
      percentChange60d: convert(json['percent_change_60d'].toDouble(),),
      percentChange90d: convert(json['percent_change_90d'].toDouble(),),
      marketCap: convert(json['market_cap'].toDouble(),),
      marketCapDominance: convert(json['market_cap_dominance'].toDouble(),),
      fullyDilutedMarketCap: json['fully_diluted_market_cap'].toString(),
      lastUpdated: DateTime.parse(json['last_updated']),
    );
  }
  
}


String convert(double number) {
  String numberString = number.toString();
  int decimalIndex = numberString.indexOf('.');
  int zeroCount = 0;
  if (decimalIndex == -1) {
    return number.toString();
  }
  for (int i = decimalIndex + 1; i < numberString.length; i++) {
    if (numberString[i] == '0') {
      zeroCount++;
    } else {
      break;
    }
  }
  zeroCount = zeroCount + 2;
  return "${number.toStringAsFixed(zeroCount)} \$";
}