import 'package:chating_app/Crypto%20Pages/Favourites.dart';
import 'package:chating_app/Crypto%20Pages/Market.dart';
import 'package:chating_app/Providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class CryptoPage extends StatefulWidget {
  // const CryptoPage({super.key});

  @override
  State<CryptoPage> createState() => _CryptoPageState();
}

class _CryptoPageState extends State<CryptoPage> with TickerProviderStateMixin {
  late TabController viewController;
  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    viewController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor:
          Provider.of<themeProvider>(context, listen: false).themeMode ==
                  ThemeMode.dark
              ? Color.fromARGB(255, 26, 26, 26)
              : Colors.blue[200],
      statusBarIconBrightness:
          Provider.of<themeProvider>(context, listen: false).themeMode ==
                  ThemeMode.light
              ? Brightness.dark
              : Brightness.light,
    ));
    return SafeArea(
      child: Scaffold(
        backgroundColor:
            Provider.of<themeProvider>(context, listen: false).themeMode ==
                    ThemeMode.dark
                ? Color.fromARGB(255, 16, 16, 16)
                : Colors.blue[200],
        appBar: AppBar(
          elevation: 10,
          shadowColor: Color.fromARGB(255, 15, 10, 8),
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
                            ThemeMode.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                decoration: BoxDecoration(
                  color: Provider.of<themeProvider>(context, listen: false)
                              .themeMode ==
                          ThemeMode.dark
                      ? Color.fromARGB(255, 2, 2, 2)
                      : Colors.blue[200],
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Provider.of<themeProvider>(context, listen: false)
                                  .themeMode ==
                              ThemeMode.light
                          ? Colors.black.withOpacity(0.6)
                          : Color.fromARGB(255, 255, 255, 255),
                      spreadRadius: -7,
                      offset: Offset(5, 5),
                      blurRadius: 20,
                    ),
                  ],
                )),
          ),
        ),
        body: Container(
          padding: EdgeInsets.only(top: 20, left: 20, bottom: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome Back",
                style: TextStyle(fontSize: 20),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Crypto Today",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 10),
              TabBar(
                indicatorColor: Colors.black,
                physics: BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                controller: viewController,
                tabs: [
                  Tab(
                    child: Text(
                      "Markets",
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Favorites",
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: viewController,
                  children: [
                    Market(),
                    Favorites(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


 // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   statusBarColor:
    //       Provider.of<themeProvider>(context, listen: false).themeMode ==
    //               ThemeMode.dark
    //           ? Colors.black
    //           : Colors.blue[200],
    //   // statusBarBrightness: Brightness.dark,
    // ));