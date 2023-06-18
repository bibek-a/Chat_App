// import 'dart:developer';
// import 'package:chating_app/Constants/map.dart';
// import 'package:chating_app/Constants/map.dart';
import 'package:chating_app/Providers/GroupChatProvider.dart';
import 'package:chating_app/Providers/chatRoom_provider.dart';
import 'package:chating_app/Providers/market_provider.dart';
import 'package:chating_app/Providers/theme_provider.dart';
import 'package:chating_app/constants/themes.dart';
import 'package:chating_app/models/FirebaseHelper.dart';
import 'package:chating_app/models/UserModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:uuid/uuid.dart';
// import "package:flutter/src/material/colors.dart";
import 'Chat Pages/LoginPage.dart';
import 'FirstPage.dart';
import 'package:provider/provider.dart';

// import 'models/variables.dart';

var uuid = Uuid();
//
FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
  //   statusBarColor:
  //       Provider.of<themeProvider>(context, listen: false).themeMode ==
  //               ThemeMode.dark
  //           ? Color.fromARGB(255, 0, 0, 0)
  //           : Colors.blue[200],
  // ));
  //
  // getLocation();
  //
  WidgetsFlutterBinding.ensureInitialized();

  AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings("@mipmap/ic_launcher");

  DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestCriticalPermission: true,
    requestSoundPermission: true,
  );
  //
  InitializationSettings initializationSettings =
      InitializationSettings(android: androidSettings, iOS: iosSettings);

  //
  // bool? initialized =
  //     await notificationsPlugin.initialize(initializationSettings);

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyB6Nx_NvNfO_ORje5c-nc2RGQ6Kc_R17Gw",
      appId: "1:502959309624:android:2ab5af70e73b3dd18f37cd",
      messagingSenderId: "502959309624",
      projectId: "mychatapp-96f89",
    ), //mychatapp-96f89
  );
  User? currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    //Logged In
    UserModel? thisUserModel =
        await FirebaseHelper.getUserModelById(currentUser.uid);
    if (thisUserModel != null) {
      runApp(
          MyAppLoggedIn(userModel: thisUserModel, firebaseUser: currentUser));
    } else {
      runApp(MyApp());
    }
  } else {
    //Not Logged In
    runApp(MyApp());
  }
}

//NotLoggedIn
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<MarketProvider>(
            create: (context) {
              return MarketProvider();
            },
          ),
          ChangeNotifierProvider<themeProvider>(
            create: (context) {
              return themeProvider();
            },
          ),
          ChangeNotifierProvider<ChatRoomProvider>(
            create: (context) {
              return ChatRoomProvider();
            },
          ),
          ChangeNotifierProvider<GroupProvider>(
            create: (context) {
              return GroupProvider();
            },
          ),
        ],
        child: Consumer<themeProvider>(
          builder: (context, provider, child) => MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: provider.themeMode,
            home: LoginPage(),
          ),
        ));
  }
}

//
//
//Already Logged LoggIn
class MyAppLoggedIn extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;
  const MyAppLoggedIn(
      {Key? key, required this.userModel, required this.firebaseUser})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<MarketProvider>(
            create: (context) {
              return MarketProvider();
            },
          ),
          ChangeNotifierProvider<themeProvider>(
            create: (context) {
              return themeProvider();
            },
          ),
          ChangeNotifierProvider<ChatRoomProvider>(
            create: (context) {
              return ChatRoomProvider();
            },
          ),
          ChangeNotifierProvider<GroupProvider>(
            create: (context) {
              return GroupProvider();
            },
          ),
        ],
        child: Consumer<themeProvider>(
          builder: (context, provider, child) => MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: provider.themeMode,
            home: FirstPage(
              userModel: userModel,
              firebaseUser: firebaseUser,
            ),
          ),
        ));
  }
}
