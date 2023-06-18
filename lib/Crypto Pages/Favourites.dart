import 'package:chating_app/Providers/market_provider.dart';
import 'package:chating_app/Widgets/CryptoListTile.dart';
import 'package:chating_app/models/Cryptocurrency.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class Favorites extends StatefulWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MarketProvider>(builder: (context, provider, child) {
      List<Cryptocurrency> favorites = provider.markets
          .where((element) => element.isFavorite == true)
          .toList();

      if (favorites.length > 0) {
        return ListView.builder(
            physics: BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              Cryptocurrency currentCrypto = favorites[index];
              return CryptoListTile(currentCrypto: currentCrypto);
            });
      } else {
        return Center(
            child: Text(
          "No favorites yet",
          style: TextStyle(fontSize: 17),
        ));
      }
    });
  }
}
