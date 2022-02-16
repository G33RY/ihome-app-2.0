import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:ihome/helpers/cacher.dart';
import 'package:ihome/models/api/api.dart';

class Token {
  String id;
  String name;
  String symbol;
  String slug;
  int rank;
  double price;
  String logo;
  double change1h;
  double change1d;
  double change7d;
  double change30d;

  Token({
    required this.id,
    required this.name,
    required this.symbol,
    required this.slug,
    required this.rank,
    required this.price,
    required this.logo,
    this.change1h = 0,
    this.change1d = 0,
    this.change7d = 0,
    this.change30d = 0,
  });

  static Future<List<Token>> fetch([bool force = false]) async {
    return Cache.get<List<Token>>(
      key: "tokens",
      force: force,
      func: () async {
        List<Token> tokens = [];
        try {
          List<dynamic> json =
              jsonDecode(await IHOMEAPI.GET("crypto/tokens")) as List<dynamic>;

          for (var item in json) {
            tokens.add(Token(
              id: item["id"].toString(),
              name: item["name"].toString(),
              symbol: item["symbol"].toString(),
              slug: item["slug"].toString(),
              rank: int.parse(item["rank"].toString()),
              price: double.tryParse(item["price"].toString()) ?? 0,
              logo: item["logo"].toString(),
            ));
          }
        } catch (e) {
          print("crypto tokens fetch all");
          print(e);
        }

        return tokens;
      },
    );
  }

  static Future<List<Token>> fetchOne(List<String> tokenIds,
      [bool force = false]) async {
    return Cache.get<List<Token>>(
      key: "token",
      force: force,
      func: () async {
        List<Token> tokens = [];

        try {
          List<dynamic> json = jsonDecode(
                  await IHOMEAPI.GET("crypto/tokens?ids=${tokenIds.join(',')}"))
              as List<dynamic>;
          for (var item in json) {
            tokens.add(Token(
              id: item["id"].toString(),
              name: item["name"].toString(),
              symbol: item["symbol"].toString(),
              slug: item["slug"].toString(),
              rank: item["rank"] as int,
              price: item["price"] as double? ?? 0,
              logo: item["logo"].toString(),
            ));
          }
        } catch (e) {
          print(e);
        }

        return tokens;
      },
    );
  }
}
