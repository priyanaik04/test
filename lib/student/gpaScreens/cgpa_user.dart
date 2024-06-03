import 'package:chatapp/student/gpaScreens/cgpapage.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/utils/app_colors.dart';
//import 'package:chatapp/widgets/app_button.dart';

// ignore: camel_case_types
class Cgpa_user extends StatefulWidget {
  const Cgpa_user({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<Cgpa_user> {
  TextEditingController semController = TextEditingController();
  late int n;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title:const Text("CGPA calculator"), backgroundColor: const Color.fromRGBO(34, 9, 44, 1)),
      appBar: AppBar(
        title: const Text(
          "CGPA calculator",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromRGBO(34, 9, 44, 1),
      ),
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.transparent, width: 25.0),
            color: Colors.transparent),
        child: ListView(
          children: <Widget>[
            TextField(
              textAlign: TextAlign.center,
              autofocus: true,
              decoration: const InputDecoration(
                  fillColor: Colors.lightBlueAccent,
                  hintText: "Enter number of semester",
                  hintStyle: TextStyle(color: Colors.black54)),
              keyboardType: TextInputType.number,
              controller: semController,
              onChanged: (String str) {
                setState(() {
                  if (semController.text == "") {
                    n = 0;
                  } else {
                    n = int.parse(semController.text);
                  }
                });
              },
            ),
            //  IconButton(
            //   icon: const Icon(Icons.touch_app,size: 35.0,color: Colors.deepPurpleAccent,),
            //   onPressed: (){
            //     if(n is int && n > 0 ){
            //       int pass=n;
            //       n=0;
            //       semController.text="";
            //       Navigator.of(context).push(MaterialPageRoute(
            //           builder:(BuildContext context)=> CgpaCalc(pass)));
            //     }
            //     else{
            //       semController.text="";
            //       alert();
            //     }
            //   },
            // )
            //  AppButton.button(
            //             text: 'Done',
            //              color: AppColors.secondary,
            //              width: 100.0,
            //             // height: 48.0,
            //             // onTap: () {
            //             //   Navigator.pushReplacementNamed(
            //             //       context, );
            //             // },
            //         onTap: () async{
            //         if(n is int && n > 0 ){
            //        int pass=n;
            //        n=0;
            //        semController.text="";
            //        Navigator.of(context).push(MaterialPageRoute(
            //            builder:(BuildContext context)=> CgpaCalc(pass)));
            //      }
            //      else{
            //        semController.text="";
            //        alert();
            //         }
            //       },
            //           ),

            ButtonTheme(
              minWidth: 100.0,
              child: ElevatedButton(
                onPressed: () async {
                  if (n is int && n > 0) {
                    int pass = n;
                    n = 0;
                    semController.text = "";
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => CgpaCalc(pass),
                    ));
                  } else {
                    semController.text = "";
                    alert();
                  }
                },
                child: Text(
                  'Done',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      AppColors.secondary, // Set button background color
                  // minimumSize: Size(100.0, 48.0), // Set button width and height
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  alert() {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              const Text('Please enter number of semester to calculate CGPA'),
          actions: <Widget>[
            TextButton(
              child: const Icon(
                Icons.clear,
                size: 40.0,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
