import 'dart:io';
import 'dart:typed_data';
import 'package:chatapp/loadpdf.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as fs;
import 'package:cloud_firestore/cloud_firestore.dart';

import '../student/student_dashboard.dart';

class FacultyNotes extends StatefulWidget {
  const FacultyNotes({super.key});

  @override
  State<FacultyNotes> createState() => _FacultyNotesState();
}

class _FacultyNotesState extends State<FacultyNotes> {
  bool uploading = false;
  double progress = 0.0;

  get dirpath => null;

  Future<void> uploadDataToFirebase() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'pdf', 'doc', 'docx', 'xls', 'xlsx', 'txt'],
      );

      if (result != null) {
        Uint8List? uploadfile = result.files.single.bytes;
        String filename = basename(result.files.single.name);
        fs.Reference storageRef =
            fs.FirebaseStorage.instance.ref().child('$dirpath$filename');

        final fs.UploadTask uploadTask = storageRef.putData(uploadfile!);
        uploadTask.snapshotEvents.listen((fs.TaskSnapshot snapshot) {
          setState(() {
            progress = snapshot.bytesTransferred.toDouble() /
                snapshot.totalBytes.toDouble();
          });
        });

        final fs.TaskSnapshot downloadUrl = await uploadTask;
        final String attchurl = await downloadUrl.ref.getDownloadURL();

        await FirebaseFirestore.instance.collection("notes").add({
          'url': attchurl,
          'num': filename,
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "placement Result",
          style: TextStyle(fontFamily: 'Narrow', fontSize: 30),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Color.fromRGBO(34, 9, 44, 1),
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        onPressed: () async {
          await uploadDataToFirebase();
        },
        child: uploading
            ? CircularProgressIndicator(
                value: progress,
              )
            : const Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("notes").snapshots(),
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
                    return Padding(
                      padding: const EdgeInsetsDirectional.all(20),
                      child: InkWell(
                        onTap: () {
                          if (!x['num'].toString().endsWith('.pdf')) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Install Proper App to view"),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => LoadPdf(url: x["url"]),
                              ),
                            );
                          }
                        },
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          color: Colors.white,
                          child: Container(
                            alignment: Alignment.center,
                            height: 80,
                            child: Text(
                              (x["num"]),
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 20),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    );
                  });
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}


// import 'dart:io';
// import 'package:chatapp/loadpdf.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
// import 'package:loading_animation_widget/loading_animation_widget.dart';
// import 'package:percent_indicator/circular_percent_indicator.dart';

// import '../student/student_dashboard.dart';

// class FacultyNotes extends StatefulWidget {
//   const FacultyNotes({Key? key}) : super(key: key);

//   @override
//   State<FacultyNotes> createState() => _FacultyNotesState();
// }

// class _FacultyNotesState extends State<FacultyNotes> {
//   String url = "";
//   int? num;
//   bool uploading = false;
//   bool clicked = false;
//   double progress = 0.0;
//   dynamic uploadListner;

//   uploadDataToFirebase() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles();
//     if (result == null) {
//       setState(() {
//         uploading = false;
//       });
//     } else {
//       setState(() {
//         uploading = true;
//       });
//       File pick = File(result.files.single.path.toString());
//       var file = pick.readAsBytesSync();
//       String fileName = pick.path.split('/').last;

//       //uploading
//       var pdfFile =
//           FirebaseStorage.instance.ref().child("notes").child(fileName);
//       UploadTask task = pdfFile.putData(file);

//       uploadListner = task.snapshotEvents.listen((event) async {
//         switch (event.state) {
//           case TaskState.running:
//             setState(() {
//               progress = event.bytesTransferred.toDouble() /
//                   event.totalBytes.toDouble();
//             });
//             break;
//           case TaskState.paused:
//             setState(() {
//               uploading = false;
//             });
//             break;
//           case TaskState.canceled:
//             setState(() {
//               uploading = false;
//             });
//             break;
//           case TaskState.error:
//             setState(() {
//               uploading = false;
//             });
//             break;
//           case TaskState.success:
//             url = await pdfFile.getDownloadURL();

//             //  to cloud firebase

//             await FirebaseFirestore.instance.collection("notes").add({
//               'url': url,
//               'num': fileName,
//             });

//             setState(() {
//               uploading = false;
//             });
//             break;
//         }
//       });
//       uploadListner.cancle();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: const Text(
//           "Notes",
//           style: TextStyle(fontFamily: 'Narrow', fontSize: 30),
//           textAlign: TextAlign.center,
//         ),
//         backgroundColor: Color.fromRGBO(34, 9, 44, 1),
//       ),
//       floatingActionButton: FloatingActionButton(
//         foregroundColor: Colors.black,
//         backgroundColor: Colors.white,
//         onPressed: () async {
//           await uploadDataToFirebase();
//         },
//         child: uploading
//             ? CircularPercentIndicator(
//                 radius: 28.0,
//                 lineWidth: 8.0,
//                 animation: true,
//                 percent: progress,
//                 center: Text(
//                   "${(progress * 100).toStringAsFixed(0)}%",
//                   style: const TextStyle(
//                       fontWeight: FontWeight.bold, fontSize: 18.0),
//                 ),
//                 circularStrokeCap: CircularStrokeCap.round,
//                 progressColor: Colors.orange,
//               )
//             : const Icon(Icons.add),
//       ),
//       body: clicked
//           ? const Center(
//               child: CircularProgressIndicator(),
//             )
//           : StreamBuilder(
//               stream:
//                   FirebaseFirestore.instance.collection("notes").snapshots(),
//               builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                 if (snapshot.hasData) {
//                   if (snapshot.data!.docs.isEmpty) {
//                     return const Center(
//                         child: Text(
//                       'Files Not Added.',
//                       style: TextStyle(color: Colors.grey, fontSize: 20),
//                     ));
//                   } else {
//                     return ListView.builder(
//                         itemCount: snapshot.data!.docs.length,
//                         itemBuilder: (context, i) {
//                           QueryDocumentSnapshot x = snapshot.data!.docs[i];
//                           return Padding(
//                             padding: const EdgeInsetsDirectional.all(20),
//                             child: InkWell(
//                               onTap: () {
//                                 if (!x['num'].toString().endsWith('.pdf')) {
//                                   setState(() {
//                                     clicked = true;
//                                   });
//                                   StudentDashboard.launchAnyURL(
//                                           x["url"], x["num"])
//                                       .then((value) => {
//                                             setState(() {
//                                               clicked = false;
//                                             })
//                                           })
//                                       .onError((error, stackTrace) => {
//                                             setState(() {
//                                               clicked = false;
//                                             }),
//                                             ScaffoldMessenger.of(context)
//                                                 .showSnackBar(const SnackBar(
//                                                     content: Text(
//                                                         "Install Proper App to view"))),
//                                           });
//                                 } else {
//                                   Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (_) =>
//                                               LoadPdf(url: x["url"])));
//                                 }
//                               },
//                               child: Slidable(
//                                 key: ValueKey(i),
//                                 endActionPane: ActionPane(
//                                   extentRatio: 0.23,
//                                   motion: const ScrollMotion(),
//                                   children: [
//                                     SlidableAction(
//                                       borderRadius: BorderRadius.circular(30),
//                                       onPressed: (v) async {
//                                         FirebaseFirestore.instance
//                                             .collection("notes")
//                                             .where('num', isEqualTo: x['num'])
//                                             .get()
//                                             .then((value) => {
//                                                   FirebaseFirestore.instance
//                                                       .collection("notes")
//                                                       .doc(value.docs.first.id)
//                                                       .delete()
//                                                 });
//                                       },
//                                       backgroundColor: Colors.white,
//                                       foregroundColor: const Color(0xFFFE4A49),
//                                       icon: Icons.delete,
//                                       label: 'Delete',
//                                     ),
//                                   ],
//                                 ),
//                                 child: Card(
//                                   elevation: 5,
//                                   shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(50)),
//                                   color: Colors.white,
//                                   child: Container(
//                                     alignment: Alignment.center,
//                                     height: 80,
//                                     child: Text(
//                                       (x["num"]),
//                                       textAlign: TextAlign.center,
//                                       style: const TextStyle(fontSize: 20),
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           );
//                         });
//                   }
//                 } else {
//                   return Center(
//                     child: LoadingAnimationWidget.staggeredDotsWave(
//                         size: 50, color: Colors.red),
//                   );
//                 }
//               }),
//     );
//   }
// }
