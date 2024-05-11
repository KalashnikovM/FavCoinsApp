
class CoinQuote {
  final String id;
  // final String name;
  // final String symbol;
  final double price;
  final double volume24h;
  final double volumeChange24h;
  final double percentChange1h;
  final double percentChange24h;
  final double percentChange7d;
  final double percentChange30d;
  final double percentChange60d;
  final double percentChange90d;
  final double marketCap;
  final double marketCapDominance;
  final double fullyDilutedMarketCap;
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
      price: json['price'],
      volume24h: json['volume_24h'],
      volumeChange24h: json['volume_change_24h'],
      percentChange1h: json['percent_change_1h'],
      percentChange24h: json['percent_change_24h'],
      percentChange7d: json['percent_change_7d'],
      percentChange30d: json['percent_change_30d'],
      percentChange60d: json['percent_change_60d'],
      percentChange90d: json['percent_change_90d'],
      marketCap: json['market_cap'],
      marketCapDominance: json['market_cap_dominance'],
      fullyDilutedMarketCap: json['fully_diluted_market_cap'],
      lastUpdated: DateTime.parse(json['last_updated']),
    );
  }
}