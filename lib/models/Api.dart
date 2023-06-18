import 'dart:convert';

import "package:http/http.dart" as http;

//
class API {
  static Future<List<dynamic>> getMarkets() async {
    //
    String Path =
        "https://api.coingecko.com/api/v3/coins/markets?vs_currency=inr&order=market_cap_desc&per_page=50&page=1&sparkline=false";
    Uri url = Uri.parse(Path);
    var response = await http.get(url);
    var decodedResponse = jsonDecode(response.body);
    List<dynamic> markets = decodedResponse as List<dynamic>;
    return markets;
    //
  }
}
