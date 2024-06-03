import 'package:chatapp/redux/reducer.dart';
import 'package:chatapp/student/student_sub_attendance.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class StudentAttendance extends StatelessWidget {
  List subjectlist = [];

  StudentAttendance({super.key});

  // StudentAttendance({super.key});

  @override
  Widget build(BuildContext context) {
    var state = StoreProvider.of<AppState>(context).state;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Attendance",
          style: TextStyle(fontFamily: 'Narrow', fontSize: 30),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.indigo[300],
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .doc("College/${state.branch}/${state.year}/Subjects")
            .get(),
        builder: (BuildContext context, AsyncSnapshot list) {
          if (list.connectionState == ConnectionState.waiting) {
            return Container(
              color: Colors.white,
              child: Center(
                  child: LoadingAnimationWidget.staggeredDotsWave(
                      size: 50, color: Colors.red)),
            );
          } else {
            subjectlist = list.data[0].toList();
            return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Student_Detail/${state.prn}/Attendance")
                    .snapshots(),
                builder: (context, AsyncSnapshot attendance) {
                  if (attendance.hasData && attendance.data.docs.isNotEmpty) {
                    return Padding(
                      padding: const EdgeInsetsDirectional.all(20),
                      child: ListView.builder(
                        itemCount: attendance.data.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (subjectlist
                              .contains(attendance.data.docs[index].id)) {
                            return Padding(
                              padding: const EdgeInsetsDirectional.all(10),
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) => StudentSubAttendance(
                                            subject:
                                                attendance.data.docs[index].id,
                                          )));
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  elevation: 5,
                                  color: Colors.white,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 4,
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: 80,
                                          child: Text(
                                              attendance.data.docs[index].id,
                                              overflow: TextOverflow.ellipsis,
                                              style:
                                                  const TextStyle(fontSize: 20),
                                              textAlign: TextAlign.center),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          '${attendance.data.docs[index].data().entries.where((e) => e.value == true).toList().length.toString()}/${attendance.data.docs[index].data().length}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    );
                  } else {
                    return Container(
                      color: Colors.white,
                      child: Center(
                          child: LoadingAnimationWidget.staggeredDotsWave(
                              size: 50, color: Colors.red)),
                    );
                  }
                });
          }
        },
      ),
    );
  }
}
