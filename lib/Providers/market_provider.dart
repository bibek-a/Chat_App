import 'dart:async';
import 'package:flutter/cupertino.dart';

import '../models/Cryptocurrency.dart';
import '../models/LocalStorage.dart';
import '../models/Api.dart';

class MarketProvider with ChangeNotifier {
  //
  bool isLoading = true;
  List<Cryptocurrency> markets = [];
  //
  MarketProvider() {
    fetchData();
  }
  Future<void> fetchData() async {
    List<dynamic> _markets = await API.getMarkets();
    List<Cryptocurrency> temp = [];
    List<String> favorites = await LocalStorage.fetchFavorites();

    for (var market in _markets) {
      Cryptocurrency newCrypto = Cryptocurrency.toObject(market);
      if (favorites.contains(newCrypto.id)) {
        newCrypto.isFavorite = true;
      }
      temp.add(newCrypto);
    }

    markets = temp;
    isLoading = false;
    notifyListeners();
  }

  Cryptocurrency fetchCryptoById(String id) {
    Cryptocurrency crypto =
        markets.where((element) => element.id == id).toList()[0];
    return crypto;
  }

  void addFavorite(Cryptocurrency crypto) async {
    int indexOfCrypto = markets.indexOf(crypto);
    markets[indexOfCrypto].isFavorite = true;
    await LocalStorage.addFavorite(crypto.id!);
    notifyListeners();
  }

  void removeFavorite(Cryptocurrency crypto) async {
    int indexOfCrypto = markets.indexOf(crypto);
    markets[indexOfCrypto].isFavorite = false;
    await LocalStorage.removeFavorite(crypto.id!);
    notifyListeners();
  }
}
