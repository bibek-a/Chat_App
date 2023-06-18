// import 'package:chating_app/Models/Cryptocurrency.dart';
import 'package:chating_app/Providers/market_provider.dart';
import 'package:chating_app/Providers/theme_provider.dart';
import 'package:chating_app/models/Cryptocurrency.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class DetailsPage extends StatefulWidget {
  final String id;
  const DetailsPage({required this.id});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  String getPrice(double indianprice) {
    var nepaliPrice = indianprice * 1.6;
    return "Rs " + nepaliPrice.toStringAsFixed(3);
  }

  @override
  Widget build(BuildContext context) {
    Widget titleAndDetail(title, CrossAxisAlignment value, detail) {
      return Column(
        crossAxisAlignment: value,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 17,
            ),
          ),
          Text(
            detail.toString(),
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      );
    }

    return Scaffold(
      backgroundColor:
          Provider.of<themeProvider>(context, listen: false).themeMode ==
                  ThemeMode.dark
              ? Color.fromARGB(255, 16, 16, 16)
              : Colors.blue[200],
      appBar: AppBar(
        elevation: 10,
        shadowColor: Color.fromARGB(255, 91, 35, 15),
        backgroundColor:
            Provider.of<themeProvider>(context, listen: false).themeMode ==
                    ThemeMode.light
                ? Colors.blue[200]
                : Color.fromARGB(255, 16, 16, 16),
        leading: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 25,
                  color: Provider.of<themeProvider>(context, listen: false)
                              .themeMode ==
                          ThemeMode.light
                      ? Colors.black
                      : Colors.white,
                ),
              ),
              decoration: BoxDecoration(
                color: Provider.of<themeProvider>(context, listen: false)
                            .themeMode ==
                        ThemeMode.light
                    ? Colors.blue[200]
                    : Provider.of<themeProvider>(context, listen: false)
                                .themeMode ==
                            ThemeMode.light
                        ? Color.fromARGB(179, 111, 109, 109)
                        : Colors.black,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Provider.of<themeProvider>(context, listen: false)
                                .themeMode ==
                            ThemeMode.dark
                        ? Color.fromARGB(255, 58, 67, 44)
                        : Colors.black,
                    spreadRadius: -7,
                    offset: Offset(5, 5),
                    blurRadius: 20,
                  )
                ],
              )),
        ),
      ),
      body: SafeArea(
        child: Consumer<MarketProvider>(
          builder: (context, provider, child) {
            Cryptocurrency currentCrypto = provider.fetchCryptoById(widget.id);
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: RefreshIndicator(
                backgroundColor:
                    Provider.of<themeProvider>(context, listen: false)
                                .themeMode ==
                            ThemeMode.light
                        ? Colors.blue[200]
                        : Color.fromARGB(255, 201, 197, 197),
                color: Provider.of<themeProvider>(context, listen: false)
                            .themeMode ==
                        ThemeMode.light
                    ? Colors.black
                    : Colors.black,
                onRefresh: () async {
                  await provider.fetchData();
                },
                child: ListView(
                  physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.black,
                        backgroundImage: NetworkImage(currentCrypto.image!),
                      ),
                      title: Text(currentCrypto.name! +
                          " (${currentCrypto.symbol!.toUpperCase()})"),
                      subtitle: Text(
                        getPrice(currentCrypto.currentPrice!),
                        style: TextStyle(color: Colors.blue, fontSize: 20),
                      ),
                    ),
                    SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Price Change(24h)",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 2),
                        Builder(builder: (context) {
                          double priceChange = currentCrypto.priceChange24!;
                          String NepaliPriceChange = getPrice(priceChange);
                          double priceChangePercentage =
                              currentCrypto.priceChangePercentage24!;
                          if (priceChange < 0) {
                            //negative
                            return Text(
                              "${priceChangePercentage.toStringAsFixed(2)}% (${NepaliPriceChange})",
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                              ),
                            );
                          } else {
                            //positive
                            return Text(
                              "+${priceChangePercentage.toStringAsFixed(2)}%  (+${priceChange.toStringAsFixed(3)})",
                              style: TextStyle(
                                color: Color.fromARGB(255, 6, 126, 10),
                                fontSize: 19,
                              ),
                            );
                          }
                        })
                      ],
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        titleAndDetail("Market Cap", CrossAxisAlignment.start,
                            getPrice(currentCrypto.marketCap!)),
                        titleAndDetail(
                          "Market Cap Rank",
                          CrossAxisAlignment.end,
                          "#" + currentCrypto.marketCapRank!.toStringAsFixed(0),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        titleAndDetail("Low 24h", CrossAxisAlignment.start,
                            getPrice(currentCrypto.low24!)),
                        titleAndDetail(
                          "High 24h",
                          CrossAxisAlignment.end,
                          getPrice(currentCrypto.high24!),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        titleAndDetail(
                            "Circulating Supply",
                            CrossAxisAlignment.start,
                            getPrice(currentCrypto.circulatingSupply!)),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        titleAndDetail("All time Low", CrossAxisAlignment.start,
                            getPrice(currentCrypto.atl!)),
                        titleAndDetail("All time High", CrossAxisAlignment.end,
                            getPrice(currentCrypto.ath!)),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
