import 'package:chatapp/student/student_dashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../loadpdf.dart';

class StudentNotes extends StatefulWidget {
  const StudentNotes({super.key});

  @override
  State<StudentNotes> createState() => _StudentNotesState();
}

class _StudentNotesState extends State<StudentNotes> {
  bool clicked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Placement Result",
          style: TextStyle(fontFamily: 'Narrow', fontSize: 30),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.indigo[300],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: clicked
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection("notes").snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.docs.isEmpty) {
                      return const Center(
                          child: Text(
                        'Files Not Added.',
                        style: TextStyle(color: Colors.grey, fontSize: 20),
                      ));
                    } else {
                      return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, i) {
                            QueryDocumentSnapshot x = snapshot.data!.docs[i];
                            return InkWell(
                              onTap: () {
                                if (!x['num'].toString().endsWith('.pdf')) {
                                  setState(() {
                                    clicked = true;
                                  });
                                  StudentDashboard.launchAnyURL(
                                          x["url"], x["num"])
                                      .then((value) => {
                                            setState(() {
                                              clicked = false;
                                            })
                                          })
                                      .onError((error, stackTrace) => {
                                            setState(() {
                                              clicked = false;
                                            })
                                          });
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              LoadPdf(url: x["url"])));
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50)),
                                  color: Colors.white,
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 80,
                                    child: Text(
                                      (x["num"]),
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      style: const TextStyle(fontSize: 20),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          });
                    }
                  }
                  return Center(
                      child: LoadingAnimationWidget.staggeredDotsWave(
                          size: 50, color: Colors.red));
                }),
      ),
    );
  }
}
