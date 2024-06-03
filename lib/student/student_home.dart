import 'package:chatapp/student/gpaScreens/cgpa_user.dart';
import 'package:chatapp/student/student_attendance.dart';
import 'package:chatapp/student/event/student_event.dart';
import 'package:chatapp/student/student_notes.dart';
import 'package:chatapp/student/student_result.dart';
import 'package:chatapp/student/student_syllabus.dart';
import 'package:chatapp/student/student_timetable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../redux/reducer.dart';

class StudentHome extends StatefulWidget {
  const StudentHome({super.key});

  @override
  State<StudentHome> createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  @override
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
                      )
                    ]),
                  ),
                ), //Name Tag
                //Expanded(
                //flex: 2,
                //child: Row(
                //children: [
                //       Expanded(
                //           child: InkWell(
                //         onTap: () {
                //           Navigator.of(context).push(MaterialPageRoute(
                //               builder: (_) => const StudentTimeTable()));
                //         },
                //         child: Card(
                //           shape: RoundedRectangleBorder(
                //               borderRadius: BorderRadius.circular(12)),
                //           elevation: 5,
                //           child: Column(
                //             children: [
                //               Expanded(
                //                   flex: 4,
                //                   child: Image.asset(
                //                     "assets/images/timetable.gif",
                //                   )),
                //               const Expanded(
                //                   flex: 1,
                //                   child: Text(
                //                     "Time Table",
                //                     textAlign: TextAlign.center,
                //                     style: TextStyle(
                //                         fontFamily: 'Custom', fontSize: 20),
                //                   )),
                //             ],
                //           ),
                //         ),
                //       )),
                //       Expanded(
                //           child: InkWell(
                //         onTap: () {
                //           Navigator.of(context).push(MaterialPageRoute(
                //               builder: (_) => const StudentSyllabus()));
                //         },
                //         child: Card(
                //           shape: RoundedRectangleBorder(
                //               borderRadius: BorderRadius.circular(12)),
                //           elevation: 5,
                //           child: Column(
                //             children: [
                //               Expanded(
                //                 flex: 4,
                //                 child: Image.asset(
                //                   "assets/images/syllabus.gif",
                //                 ),
                //               ),
                //               const Expanded(
                //                   flex: 1,
                //                   child: Text(
                //                     "Syllabus",
                //                     style: TextStyle(
                //                         fontFamily: 'Custom', fontSize: 20),
                //                   )),
                //             ],
                //           ),
                //         ),
                //       )),
                //     ],
                //   ),
                // ), //TimeTable-Syllabus
                // Expanded(
                //   flex: 2,
                //   child: Row(
                //     children: [
                //       Expanded(
                //         child: InkWell(
                //           onTap: () {
                //             Navigator.of(context).push(
                //                 MaterialPageRoute(builder: (_) => Cgpa_user()));
                //           },
                //           child: Card(
                //             shape: RoundedRectangleBorder(
                //                 borderRadius: BorderRadius.circular(12)),
                //             elevation: 5,
                //             child: Column(
                //               children: [
                //                 Expanded(
                //                     flex: 4,
                //                     child: Image.asset(
                //                       "assets/images/attendance.gif",
                //                     )),
                //                 const Expanded(
                //                     flex: 1,
                //                     child: Text(
                //                       "Attendance",
                //                       style: TextStyle(
                //                           fontFamily: 'Custom', fontSize: 20),
                //                     )),
                //               ],
                //             ),
                //           ),
                //         ),
                //       ),
                //       Expanded(
                //         child: InkWell(
                //           onTap: () {
                //             Navigator.push(
                //                 context,
                //                 MaterialPageRoute(
                //                     builder: (_) => const StudentNotes()));
                //           },
                //           child: Card(
                //             shape: RoundedRectangleBorder(
                //                 borderRadius: BorderRadius.circular(12)),
                //             elevation: 5,
                //             child: Column(
                //               children: [
                //                 Expanded(
                //                   flex: 4,
                //                   child: Image.asset(
                //                     "assets/images/notes.gif",
                //                   ),
                //                 ),
                //                 const Expanded(
                //                     flex: 1,
                //                     child: Text(
                //                       "Notes",
                //                       style: TextStyle(
                //                           fontFamily: 'Custom', fontSize: 20),
                //                     )),
                //               ],
                //             ),
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ), //Attendance-Notes
                // Expanded(
                //   flex: 2,
                //   child: Row(
                //     children: [
                //       Expanded(
                //           child: InkWell(
                //         onTap: () {
                //           Navigator.push(
                //               context,
                //               MaterialPageRoute(
                //                   builder: (_) => const StudentEvent()));
                //         },
                //         child: Card(
                //           shape: RoundedRectangleBorder(
                //               borderRadius: BorderRadius.circular(12)),
                //           elevation: 5,
                //           child: Column(
                //             children: [
                //               Expanded(
                //                   flex: 4,
                //                   child: Image.asset(
                //                     "assets/images/events.gif",
                //                   )),
                //               const Expanded(
                //                   flex: 1,
                //                   child: Text(
                //                     "Events",
                //                     style: TextStyle(
                //                         fontFamily: 'Custom', fontSize: 20),
                //                   )),
                //             ],
                //           ),
                //         ),
                //       )),
                //       Expanded(
                //           child: InkWell(
                //         onTap: () => Navigator.of(context).push(
                //             MaterialPageRoute(
                //                 builder: (_) => const StudentResult())),
                //         child: Card(
                //           shape: RoundedRectangleBorder(
                //               borderRadius: BorderRadius.circular(12)),
                //           elevation: 5,
                //           child: Column(
                //             children: [
                //               Expanded(
                //                   flex: 4,
                //                   child: Image.asset(
                //                     "assets/images/result.gif",
                //                   )),
                //               const Expanded(
                //                   flex: 1,
                //                   child: Text(
                //                     "Result",
                //                     style: TextStyle(
                //                         fontFamily: 'Custom', fontSize: 20),
                //                   )),
                //             ],
                //           ),
                //         ),
                //       )),
                //  ],
                // ),
                // ), //Events-Result
              ],
            ),
          );
        });
  }
}
