// import 'package:flutter/material.dart';
// import 'package:flutter_redux/flutter_redux.dart';
// import '../components/event.dart';
// import '../redux/reducer.dart';

// class StudentEvent extends StatefulWidget {
//   const StudentEvent({super.key});

//   @override
//   State<StudentEvent> createState() => _StudentEventState();
// }

// class _StudentEventState extends State<StudentEvent> {
//   @override
//   Widget build(BuildContext context) {
//     var data = StoreProvider.of<AppState>(context).state;
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: const Text(
//           "Events",
//           style: TextStyle(fontFamily: 'Narrow', fontSize: 30),
//           textAlign: TextAlign.center,
//         ),
//         backgroundColor: Colors.indigo[300],
//       ),
//       body: Padding(padding: const EdgeInsets.all(15), child: Event(data.isStudent)),
//     );
//   }
// }

import 'dart:collection';

import 'package:chatapp/student/event/edit_event.dart';
import 'package:chatapp/student/mock/quizhome.dart';
import 'package:chatapp/student/pages/others/Widget021.dart';
import 'package:chatapp/student/student_notes.dart';
import 'package:chatapp/utils/widgets/features/event_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'package:flutter/material.dart';
import 'package:chatapp/student/gpaScreens/cgpa_user.dart';

import 'package:chatapp/models/event.dart';
//import 'package:chatapp/utils/app_colors.dart';
import 'package:table_calendar/table_calendar.dart';

//import '../../widgets/features/event_item.dart';
//import 'user/add_event.dart';
//import 'user/edit_event.dart';

class StudentEvent extends StatefulWidget {
  // final String email;
  // final String password;

  // const StudentEvent({Key? key, required this.email, required this.password})
  //     : super(key: key);
  static const String routeName = 'StudentEvent';
  const StudentEvent({super.key});
//   const StudentEvent({super.key});

  @override
  _StudentEventState createState() => _StudentEventState();
}

class _StudentEventState extends State<StudentEvent> {
  // late String _email;
  // late String _password;

  late DateTime _focusedDay;
  late DateTime _firstDay;
  late DateTime _lastDay;
  late DateTime _selectedDay;
  late CalendarFormat _calendarFormat;
  late Map<DateTime, List<Event>> _events;

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  @override
  void initState() {
    // super.initState();
    // _email = widget.email;
    // _password = widget.password;
    super.initState();
    _events = LinkedHashMap(
      equals: isSameDay,
      hashCode: getHashCode,
    );
    _focusedDay = DateTime.now();
    _firstDay = DateTime.now().subtract(const Duration(days: 1000));
    _lastDay = DateTime.now().add(const Duration(days: 1000));
    _selectedDay = DateTime.now();
    _calendarFormat = CalendarFormat.month;
    _loadFirestoreEvents();
  }

  _loadFirestoreEvents() async {
    final firstDay = DateTime(_focusedDay.year, _focusedDay.month, 1);
    final lastDay = DateTime(_focusedDay.year, _focusedDay.month + 1, 0);
    _events = {};

    final snap = await FirebaseFirestore.instance
        .collection('events')
        .where('date', isGreaterThanOrEqualTo: firstDay)
        .where('date', isLessThanOrEqualTo: lastDay)
        .withConverter(
            fromFirestore: Event.fromFirestore,
            toFirestore: (event, options) => event.toFirestore())
        .get();
    for (var doc in snap.docs) {
      final event = doc.data();
      final day =
          DateTime.utc(event.date.year, event.date.month, event.date.day);
      if (_events[day] == null) {
        _events[day] = [];
      }
      _events[day]!.add(event);
    }
    setState(() {});
  }

  List<Event> _getEventsForTheDay(DateTime day) {
    return _events[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(title: const Text('Placement Edge')),
      ),
      drawer: const NavigationDrawer(),
      body: ListView(
        children: [
          TableCalendar(
            eventLoader: _getEventsForTheDay,
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            focusedDay: _focusedDay,
            firstDay: _firstDay,
            lastDay: _lastDay,
            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
              });
              _loadFirestoreEvents();
            },
            selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
            onDaySelected: (selectedDay, focusedDay) {
              print(_events[selectedDay]);
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarStyle: const CalendarStyle(
              weekendTextStyle: TextStyle(
                color: Color.fromRGBO(34, 9, 44, 1),
              ),
              selectedDecoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Color.fromRGBO(34, 9, 44, 1),
              ),
            ),
            calendarBuilders: const CalendarBuilders(),
          ),
          ..._getEventsForTheDay(_selectedDay).map(
            (event) => EventItem(
                event: event,
                onTap: () async {
                  final res = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditEvent(
                          firstDate: _firstDay,
                          lastDate: _lastDay,
                          event: event),
                    ),
                  );
                  if (res ?? false) {
                    _loadFirestoreEvents();
                  }
                },
                onDelete: () async {
                  final delete = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text("Delete Event?"),
                      content: const Text("Are you sure you want to delete?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.black,
                          ),
                          child: const Text("No"),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.red,
                          ),
                          child: const Text("Yes"),
                        ),
                      ],
                    ),
                  );
                  if (delete ?? false) {
                    await FirebaseFirestore.instance
                        .collection('events')
                        .doc(event.id)
                        .delete();
                    _loadFirestoreEvents();
                  }
                }),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     final result = await Navigator.push<bool>(
      //       context,
      //       MaterialPageRoute(
      //         builder: (_) => AddEvent(
      //           firstDate: _firstDay,
      //           lastDate: _lastDay,
      //           selectedDate: _selectedDay,
      //         ),
      //       ),
      //     );
      //     if (result ?? false) {
      //       _loadFirestoreEvents();
      //     }
      //   },
      //  child: const Icon(Icons.add),
      //),

      backgroundColor: Colors.white,
      // bottomNavigationBar: CurvedNavigationBar(
      //   backgroundColor: Colors.white,
      //   color: Color.fromRGBO(34, 9, 44, 1),
      //   //onTap: , use it afterward to navigate to page
      //   items: [
      //     Icon(
      //       Icons.chat,
      //       color: Colors.white,
      //     ),
      //     Icon(
      //       Icons.calendar_month,
      //       color: Colors.white,
      //     ),
      //     Icon(Icons.person, color: Colors.white),
      //   ],
      // ),
    );
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
          Text(
            'Sneha Naik',
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
          Text(
            'sneha@gmail.com',
            style:
                TextStyle(fontSize: 13, color: Color.fromARGB(96, 82, 81, 81)),
          )

//         ],
//       ));
        ],
      ));

  Widget buildMenuItems(BuildContext context) => Container(
        padding: const EdgeInsets.all(24),
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.document_scanner_outlined),
              title: const Text('Resume Scorer'),
              onTap: () async {
                final res = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => Widget021(),
                  ),
                );
              },
            ),
            const Divider(color: Color.fromARGB(134, 194, 194, 194)),
            ListTile(
              leading: const Icon(Icons.calculate_outlined),
              title: const Text('CGPA Calculator'),
              onTap: () async {
                final res = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => Cgpa_user(),
                  ),
                );
              },
            ),
            const Divider(color: Color.fromARGB(134, 194, 194, 194)),
            ListTile(
              leading: const Icon(Icons.score_outlined),
              title: const Text('Mock Test'),
              onTap: () async {
                final res = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => quizpage(),
                  ),
                );
              },
            ),
            const Divider(color: Color.fromARGB(134, 194, 194, 194)),
            ListTile(
              leading: const Icon(Icons.note),
              title: const Text('Placement Result'),
              onTap: () async {
                final res = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => StudentNotes(),
                  ),
                );
              },
            )
          ],
        ),
      );

  Widget buildMenu(BuildContext context) => Container(
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
              onTap: () {},
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
