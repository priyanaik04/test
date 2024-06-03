import 'package:chatapp/faculty/faculty_notes.dart';
import 'package:chatapp/faculty/faculty_result_history.dart';
import 'package:chatapp/faculty/faculty_subject.dart';
import 'package:chatapp/redux/reducer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'faculty_attendance_option.dart';
import 'faculty_event.dart';
import 'faculty_timetable.dart';

class FacultyHome extends StatefulWidget {
  const FacultyHome({super.key});

  @override
  State<FacultyHome> createState() => _FacultyHomeState();
}

class _FacultyHomeState extends State<FacultyHome> {
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
                  child: Row(children: [
                    Text(
                      "  Hey ${state.name['First'] ?? ''}. ${state.name['Middle'] ?? ''}. ${state.name['Last'] ?? ''}",
                      style:
                          const TextStyle(fontSize: 30, fontFamily: 'Custom'),
                    )
                  ]),
                ),
              ), //Name Tag
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Expanded(
                        child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const FacultyResultHistory()));
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 5,
                        child: Column(
                          children: [
                            Expanded(
                                flex: 4,
                                child: Image.asset(
                                  "assets/images/timetable.gif",
                                )),
                            const Expanded(
                                flex: 1,
                                child: Text(
                                  "Reports",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: 'Custom', fontSize: 20),
                                )),
                          ],
                        ),
                      ),
                    )),
                    // Expanded(
                    //     child: InkWell(
                    //   onTap: () {
                    //     Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (_) => FacultySubject(
                    //                   email: state.email,
                    //                   branch: state.branch,
                    //                 )));
                    //   },
                    //   child: Card(
                    //     shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(12)),
                    //     elevation: 5,
                    //     child: Column(
                    //       children: [
                    //         Expanded(
                    //           flex: 4,
                    //           child: Image.asset(
                    //             "assets/images/syllabus.gif",
                    //           ),
                    //         ),
                    //         const Expanded(
                    //             flex: 1,
                    //             child: Text(
                    //               "Subjects",
                    //               style: TextStyle(
                    //                   fontFamily: 'Custom', fontSize: 20),
                    //             )),
                    //       ],
                    //     ),
                    //   ),
                    // )),
                  ],
                ),
              ), //TimeTable-Syllabus
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Expanded(
                        child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const FacultyEvent()));
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 5,
                        child: Column(
                          children: [
                            Expanded(
                                flex: 4,
                                child: Image.asset(
                                  "assets/images/events.gif",
                                )),
                            const Expanded(
                                flex: 1,
                                child: Text(
                                  "Events",
                                  style: TextStyle(
                                      fontFamily: 'Custom', fontSize: 20),
                                )),
                          ],
                        ),
                      ),
                    )),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const FacultyNotes()));
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          elevation: 5,
                          child: Column(
                            children: [
                              Expanded(
                                flex: 4,
                                child: Image.asset(
                                  "assets/images/notes.gif",
                                ),
                              ),
                              const Expanded(
                                  flex: 1,
                                  child: Text(
                                    "Placement Result",
                                    style: TextStyle(
                                        fontFamily: 'Custom', fontSize: 20),
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ), //Attendance-Notes
              // Expanded(
              //   flex: 2,
              //   child: Row(
              //     children: [
              // Expanded(
              //     child: InkWell(
              //   onTap: () {
              //     Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: (_) => const FacultyEvent()));
              //   },
              //   child: Card(
              //     shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(12)),
              //     elevation: 5,
              //     child: Column(
              //       children: [
              //         Expanded(
              //             flex: 4,
              //             child: Image.asset(
              //               "assets/images/events.gif",
              //             )),
              //         const Expanded(
              //             flex: 1,
              //             child: Text(
              //               "Events",
              //               style: TextStyle(
              //                   fontFamily: 'Custom', fontSize: 20),
              //             )),
              //       ],
              //     ),
              //   ),
              // )),
              // Expanded(
              //     child: InkWell(
              //   onTap: () => Navigator.of(context).push(MaterialPageRoute(
              //       builder: (_) => const FacultyResultHistory())),
              //   child: Card(
              //     shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(12)),
              //     elevation: 5,
              //     child: Column(
              //       children: [
              //         Expanded(
              //             flex: 4,
              //             child: Image.asset(
              //               "assets/images/result.gif",
              //             )),
              //         const Expanded(
              //             flex: 1,
              //             child: Text(
              //               "Result",
              //               style: TextStyle(
              //                   fontFamily: 'Custom', fontSize: 20),
              //             )),
              //       ],
              //     ),
              //   ),
              // ))
              //],
              //),
              // ), //Events-Result
            ],
          ),
        );
      },
    );
  }
}
