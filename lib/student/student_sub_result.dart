import 'package:chatapp/redux/reducer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class StudentSubResult extends StatefulWidget {
  final String subject;
  const StudentSubResult({super.key, required this.subject});

  @override
  State<StudentSubResult> createState() => _StudentSubResultState();
}

class _StudentSubResultState extends State<StudentSubResult> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                widget.subject,
                style: const TextStyle(overflow: TextOverflow.ellipsis),
              ),
              backgroundColor: Colors.indigo[300],
            ),
            body: FutureBuilder(
              future: FirebaseFirestore.instance
                  .doc("Student_Detail/${state.prn}/Result/${widget.subject}")
                  .get(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snap) {
                if (snap.connectionState != ConnectionState.waiting) {
                  if (snap.hasData && snap.data!.data()!.isNotEmpty) {
                    Map<String, dynamic> tests =
                        snap.data!.data() as Map<String, dynamic>;
                    return ListView.builder(
                      itemCount: tests.length,
                      itemBuilder: (context, index) {
                        String key = tests.keys.elementAt(index);
                        return Padding(
                          padding: const EdgeInsetsDirectional.all(20),
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            color: Colors.white,
                            child: Row(
                              children: [
                                Expanded(
                                    flex: 4,
                                    child: Container(
                                      height: 80,
                                      alignment: Alignment.center,
                                      child: Text(key,
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontFamily: 'Custom'),
                                          textAlign: TextAlign.center),
                                    )),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                      "${tests[key]['mark']} / ${tests[key]['total']}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: (tests[key]['mark'] * 100) /
                                                      tests[key]['total'] >
                                                  35
                                              ? Colors.green[800]
                                              : Colors.red)),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: Text(
                        'Records Not Added.',
                        style: TextStyle(color: Colors.grey, fontSize: 20),
                      ),
                    );
                  }
                } else {
                  return Center(
                      child: LoadingAnimationWidget.staggeredDotsWave(
                          size: 50, color: Colors.red));
                }
              },
            ),
          );
        });
  }
}
