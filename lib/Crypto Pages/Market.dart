// import 'package:chating_app/Models/Cryptocurrency.dart';
import 'package:chating_app/Providers/market_provider.dart';
// import 'package:chating_app/Providers/market_provider.dart';
import 'package:chating_app/Providers/theme_provider.dart';
import 'package:chating_app/Widgets/CryptoListTile.dart';
// import 'package:chating_app/models/Cryptocurrency.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';

class Market extends StatefulWidget {
  // const Market({super.key});

  @override
  State<Market> createState() => _MarketState();
}

class _MarketState extends State<Market> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MarketProvider>(builder: ((context, provider, child) {
      if (provider.isLoading == true) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else {
        if (provider.markets.length > 0) {
          return RefreshIndicator(
            backgroundColor:
                Provider.of<themeProvider>(context, listen: false).themeMode ==
                        ThemeMode.light
                    ? Colors.blue[200]
                    : Color.fromARGB(255, 201, 197, 197),
            color:
                Provider.of<themeProvider>(context, listen: false).themeMode ==
                        ThemeMode.light
                    ? Colors.black
                    : Colors.black,
            // displacement: 20,
            // edgeOffset: 10,
            onRefresh: () async {
              await provider.fetchData();
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: ListView.builder(
                physics: BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                itemCount: provider.markets.length,
                itemBuilder: (context, index) {
                  var currentCrypto = provider.markets[index];
                  return CryptoListTile(currentCrypto: currentCrypto);
                },
              ),
            ),
          );
        } else {
          return Center(child: Text("Data Not found"));
        }
      }
    }));
  }
}
