import 'dart:async';
import 'package:chatapp/redux/actions/fetchUserData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoadingPage extends StatefulWidget {
  // final String? email;

  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (auth.currentUser?.email != null) {
        //
        FirebaseFirestore.instance
            .collection("Student_Detail")
            .where('Email', isEqualTo: auth.currentUser?.email)
            .limit(1)
            .count()
            .get()
            .then((value) async {
          if (value.count == 1) {
            await FetchData()
                .fetchStudentData(auth.currentUser?.email)
                .onError((error, stackTrace) {
              return null;
            });
          } else {
            await FetchData()
                .fetchFacultyData(auth.currentUser?.email)
                .onError((error, stackTrace) {
              return null;
            });
          }
        });
      }
      Future.delayed(const Duration(milliseconds: 6000),
          () => {Navigator.pushReplacementNamed(context, 'main')});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenheight = MediaQuery.of(context).size.height;
    double screenwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: screenheight,
        width: screenwidth,
        color: Color.fromRGBO(34, 9, 44, 1),
        child: Stack(
          children: [
            Positioned(
                top: 10,
                right: 50,
                left: 50,
                child: Image.asset(
                  "assets/images/logope1.png",
                  //color: Color.fromRGBO(34, 9, 44, 1),
                )),
            // Positioned(
            //   child: Image.asset(
            //     "assets/images/main_top.png",
            //     height: 150,
            //   ),
            // ),
            // Positioned(
            //   bottom: 0,
            //   child: Image.asset(
            //     "assets/images/main_bottom.png",
            //     height: 200,
            //   ),
            // ),
            // Positioned(
            //   bottom: 0,
            //   right: 0,
            //   child: Image.asset(
            //     "assets/images/login_bottom.png",
            //     height: 150,
            //   ),
            // ),
            // Positioned(
            //   right: 0,
            //   child: Image.asset(
            //     "assets/images/main_topR.png",
            //     height: 200,
            //   ),
            // ),
            // Positioned(
            //   top: 370,
            //   right: 50,
            //   left: 40,
            //   child: Image.asset(
            //     "assets/icons/login.gif",
            //     height: 200,
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
