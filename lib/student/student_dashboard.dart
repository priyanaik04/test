import 'dart:io';
import 'package:chatapp/messaging/conversation_screen.dart';
import 'package:chatapp/redux/reducer.dart';
import 'package:chatapp/student/event/student_event.dart';
import 'package:chatapp/student/gpaScreens/cgpa_user.dart';
import 'package:chatapp/student/student_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import '../firebase/auth.dart';
import 'student_home.dart';

class StudentDashboard extends StatefulWidget {
  final String email;

  const StudentDashboard({super.key, required this.email});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();

  static Future<File?> downloadFile(String url, String name) async {
    try {
      final appStorage = await getTemporaryDirectory();
      final file = File('${appStorage.path}/$name');
      final response = await Dio().get(url,
          options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            receiveTimeout: const Duration(seconds: 10),
          ));
      final raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();
      return file;
    } catch (e) {
      return null;
    }
  }

  static Future<void> launchAnyURL(String url, String name) async {
    final file = await downloadFile(url, name);
    if (file == null) return;
    OpenFile.open(file.path);
  }
}

class _StudentDashboardState extends State<StudentDashboard>
    with WidgetsBindingObserver {
  final navigationKey = GlobalKey<CurvedNavigationBarState>();
  final Auth auth = Auth();
  int index = 0;

  void setStatus(String status) {
    FirebaseFirestore.instance
        .doc("Messages/${widget.email}")
        .set({'status': status}, SetOptions(merge: true));
  }

  @override
  void initState() {
    super.initState();
    setStatus("Online");
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setStatus("Online");
    } else {
      setStatus("Offline");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screen = [
      //const StudentHome(),
      const StudentEvent(),
      const ConversationScreen(),
      StudentProfile(),
    ];
    final items = <Widget>[
      const Icon(
        Icons.calendar_month_rounded,
        color: Colors.white,
        size: 30,
      ),
      const Icon(
        Icons.messenger_outline_rounded,
        color: Colors.white,
        size: 30,
      ),
      const Icon(
        Icons.person_outline_outlined,
        color: Colors.white,
        size: 30,
      ),
    ];
    return Scaffold(
        drawer: NavigationDrawer(),
        backgroundColor: Colors.white,
        body: screen[index],
        bottomNavigationBar: CurvedNavigationBar(
          key: navigationKey,
          backgroundColor: Colors.white,
          color: const Color.fromRGBO(34, 9, 44, 1),
          //height: 60,
          items: items,
          index: index,
          onTap: (index) {
            setState(() {
              this.index = index;
            });
          },
        ));
  }
}

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) => Drawer(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              buildHeader(context),
              buildMenuItems(context),
            ],
          ),
        ),
      );
  // Widget buildname(BuildContext context) {
  //   return StoreConnector<AppState, AppState>(
  //       converter: (store) => store.state,
  //       builder: (_, state) {
  //         return Padding(
  //           padding: const EdgeInsetsDirectional.all(20),
  //           child: Column(
  //             children: [
  //               Expanded(
  //                 flex: 1,
  //                 child: Center(
  //                   child: Column(children: [
  //                     /////////////////////changed frm row to column
  //                     Text(
  //                       "  Hey ${state.name['First'].toString()}",
  //                       style: const TextStyle(
  //                           fontSize: 30, fontFamily: 'Montserrat'),
  //                     ),
  //                     Text(
  //                       "  Hey ${state.email.toString()}",
  //                       style: const TextStyle(
  //                           fontSize: 30, fontFamily: 'Montserrat'),
  //                     )
  //                   ]),
  //                 ),
  //               ), //Name Ta
  //             ],
  //           ),
  //         );
  //       });
  // }

  Widget buildHeader(BuildContext context) => Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
      ),
      child: const Column(
        children: [
          CircleAvatar(
            radius: 40,
            // backgroundImage: NetworkImage(
            //   'https://unsplash.com/photos/woman-wearing-blue-sweetheart-neckline-tube-dress-n9lOElGb1sI'
            //   ),
          ),
          SizedBox(height: 7),
          // Text(
          //               "  Hey ${state.name['First'].toString()}",
          //               style: const TextStyle(
          //                   fontSize: 30, fontFamily: 'Montserrat'),
          //             ),
          // Text(
          //   'sneha@gmail.com',
          //   style:
          //       TextStyle(fontSize: 13, color: Color.fromARGB(96, 82, 81, 81)),
          // )
        ],
      ));
  Widget buildMenuItems(BuildContext context) => Container(
        padding: const EdgeInsets.all(24),
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.document_scanner_outlined),
              title: const Text('Resume Scorer'),
              onTap: () {},
            ),
            const Divider(color: Color.fromARGB(134, 194, 194, 194)),
            ListTile(
              leading: const Icon(Icons.calculate_outlined),
              title: const Text('CGPA Calculator'),
              onTap: () async {
                final res = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const Cgpa_user(),
                  ),
                );
              },
            ),
            const Divider(color: Color.fromARGB(134, 194, 194, 194)),
            ListTile(
              leading: const Icon(Icons.score_outlined),
              title: const Text('Mock Test'),
              onTap: () {},
            )
          ],
        ),
      );
}

Widget build(BuildContext context) {
  return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (_, state) {
        return Padding(
          padding: const EdgeInsetsDirectional.all(20),
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Center(
                  child: Column(children: [
                    /////////////////////changed frm row to column
                    Text(
                      "  Hey ${state.name['First'].toString()}",
                      style: const TextStyle(
                          fontSize: 30, fontFamily: 'Montserrat'),
                    ),
                    Text(
                      "  Hey ${state.email.toString()}",
                      style: const TextStyle(
                          fontSize: 30, fontFamily: 'Montserrat'),
                    )
                  ]),
                ),
              ), //Name Ta
            ],
          ),
        );
      });
}
