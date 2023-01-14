class CryptoToken {
  final String name;
  final String symbol;
  final String slug;
  final double rank;
  final bool is_active;
  final double? circulating_supply;
  final double? total_supply;
  final double? max_supply;
  final DateTime? date_added;
  final double? num_market_pairs;
  final double? cmc_rank;
  final DateTime? last_updated;
  final double? price;
  final double? volume_24h;
  final double? volume_change_24h;
  final double? change_1h;
  final double? change_24h;
  final double? change_7d;
  final double? change_30d;
  final double? market_cap;
  final double? market_cap_dominance;
  final String? logo;

  CryptoToken({
    required this.name,
    required this.symbol,
    required this.slug,
    required this.rank,
    required this.is_active,
    this.circulating_supply,
    this.total_supply,
    this.max_supply,
    this.date_added,
    this.num_market_pairs,
    this.cmc_rank,
    this.last_updated,
    this.price,
    this.volume_24h,
    this.volume_change_24h,
    this.change_1h,
    this.change_24h,
    this.change_7d,
    this.change_30d,
    this.market_cap,
    this.market_cap_dominance,
    this.logo,
  });

  factory CryptoToken.fromJson(Map<String, dynamic> json) {
    return CryptoToken(
      name: json['name'].toString(),
      symbol: json['symbol'].toString(),
      slug: json['slug'].toString(),
      rank: double.tryParse(json['rank'].toString())!,
      is_active: json['is_active'].toString() == "true",
      circulating_supply:
          double.tryParse(json['circulating_supply'].toString()),
      total_supply: double.tryParse(json['total_supply'].toString()),
      max_supply: double.tryParse(json['max_supply'].toString()),
      date_added: DateTime.tryParse(json['date_added'].toString())?.toLocal(),
      num_market_pairs: double.tryParse(json['num_market_pairs'].toString()),
      cmc_rank: double.tryParse(json['cmc_rank'].toString()),
      last_updated:
          DateTime.tryParse(json['last_updated'].toString())?.toLocal(),
      price: double.tryParse(json['price'].toString()),
      volume_24h: double.tryParse(json['volume_24h'].toString()),
      volume_change_24h: double.tryParse(json['volume_change_24h'].toString()),
      change_1h: double.tryParse(json['percent_change_1h'].toString()),
      change_24h: double.tryParse(json['percent_change_24h'].toString()),
      change_7d: double.tryParse(json['percent_change_7d'].toString()),
      change_30d: double.tryParse(json['percent_change_30d'].toString()),
      market_cap: double.tryParse(json['market_cap'].toString()),
      market_cap_dominance:
          double.tryParse(json['market_cap_dominance'].toString()),
      logo: json['logo']?.toString(),
    );
  }
}
