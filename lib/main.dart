import 'dart:async';
import 'package:chatapp/admin/admin_home.dart';
import 'package:chatapp/messaging/conversation_screen.dart';
import 'package:chatapp/redux/store.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:provider/provider.dart';
import 'firebase/notification.dart';
import 'firebase/auth.dart';
import 'firebase/wrapper.dart';
import 'firebase_options.dart';
import 'loading_page.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform); // Initialize Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: MaterialApp(
        theme: ThemeData(fontFamily: "Muli"),
        color: Colors.transparent,
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const LoadingPage(),
          'main': (context) => const Main(),
          //'chat_screen': (context) => const StudentEvent(),
          'chat_screen': (context) => const ConversationScreen()
        },
      ),
    );
  }
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> with WidgetsBindingObserver {
  late StreamSubscription internet;
  bool isInternet = true;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state.index) {
      case 0:
        internet.resume();
        break;
      case 1:
      case 2:
        internet.pause();
        break;
      case 3:
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    super.dispose();
    internet.cancel();
  }

  @override
  void initState() {
    int id = 0;
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    internet =
        Connectivity().onConnectivityChanged.listen((ConnectivityResult event) {
      switch (event) {
        case ConnectivityResult.none:
          isInternet = false;
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            dismissDirection: DismissDirection.none,
            behavior: SnackBarBehavior.fixed,
            duration: Duration(days: 69),
            elevation: 10,
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Icon(Icons.cloud_off_outlined, color: Colors.white),
                ),
                Text(
                  "Offline - Showing limited content",
                  textAlign: TextAlign.end,
                ),
              ],
            ),
          ));
          break;
        case ConnectivityResult.mobile:
        case ConnectivityResult.wifi:
          if (!isInternet) {
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 1),
              elevation: 20,
              content: Text("Internet Connection is back"),
            ));
            isInternet = false;
          }
          break;
      }
    });

    // listen notification on foreground
    FirebaseMessaging.onMessage.listen((event) {
      id += 1;
      Map data = event.toMap();
      data["data"]["event"] != 'true'
          ? NotificationAPI.postLocalNotification(
              id: id,
              title: data["notification"]['title'],
              message: data["notification"]['body'],
              image: data["notification"]['image'])
          : showAlert(context, data);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      Navigator.of(context).pushNamed("/");
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => Auth(), child: const Wrapper());
  }

  showAlert(BuildContext context, Map data) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            alignment: Alignment.center,
            title: Text(data["notification"]['title']),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data["notification"]['body'],
                    maxLines: 9,
                  ),
                  data["data"]["image"].isNotEmpty
                      ? Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(data["data"]["image"])),
                              shape: BoxShape.circle),
                        )
                      : Container(),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.deepPurpleAccent),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)))),
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("OK"))
            ],
          );
        });
  }
}
