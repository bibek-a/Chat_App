import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import '../Crypto Pages/Details.dart';
import '../Providers/market_provider.dart';
import '../models/Cryptocurrency.dart';

class CryptoListTile extends StatelessWidget {
  final Cryptocurrency currentCrypto;
  const CryptoListTile({required this.currentCrypto});
  Widget getPrice(var value) {
    var newValue = value * 1.6;
    return Text(
      newValue!.toStringAsFixed(3),
      style: TextStyle(
          color: Colors.blue, fontSize: 17, fontWeight: FontWeight.bold),
    );
  }

  @override
  Widget build(BuildContext context) {
    MarketProvider provider =
        Provider.of<MarketProvider>(context, listen: false);
    return ListTile(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return DetailsPage(id: currentCrypto.id!);
        }));
      },
      contentPadding: EdgeInsets.only(right: 4),
      leading: CircleAvatar(
        backgroundColor: Colors.grey,
        backgroundImage: NetworkImage(currentCrypto.image!),
      ),
      title: Row(
        children: [
          Flexible(
            child: Text(
              currentCrypto.name!,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 30),
          currentCrypto.isFavorite == false
              ? GestureDetector(
                  onTap: () {
                    provider.addFavorite(currentCrypto);
                  },
                  child: Icon(
                    CupertinoIcons.heart,
                    size: 28,
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    provider.removeFavorite(currentCrypto);
                  },
                  child: Icon(
                    CupertinoIcons.heart_fill,
                    color: Colors.red,
                    size: 28,
                  ),
                )
        ],
      ),
      subtitle: Text(
        currentCrypto.symbol!.toUpperCase(),
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          getPrice(currentCrypto.currentPrice),
          Builder(builder: (context) {
            double priceChange = currentCrypto.priceChange24!;
            double priceChangePercentage =
                currentCrypto.priceChangePercentage24!;
            if (priceChange < 0) {
              //negative
              return Text(
                "${priceChangePercentage.toStringAsFixed(2)}%  (${priceChange.toStringAsFixed(3)})",
                style: TextStyle(
                  color: Colors.red,
                ),
              );
            } else {
              //positive
              return Text(
                "+${priceChangePercentage.toStringAsFixed(2)}%  (+${priceChange.toStringAsFixed(3)})",
                style: TextStyle(
                  color: Color.fromARGB(255, 6, 126, 10),
                ),
              );
            }
          })
        ],
      ),
    );
  }
}
