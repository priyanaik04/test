
// ignore_for_file: file_names

import 'package:flutter/material.dart';

import './ResultPage.dart';

class CgpaCalc extends StatefulWidget {
  final int n;
  const CgpaCalc(this.n, {super.key});

  @override
  GPAcalcstate createState() =>  GPAcalcstate();
}

class GPAcalcstate extends State<CgpaCalc> {
  late List _sgpaController;
  late List _creditController;
  late List list;

  @override
  void initState() {
    super.initState();
_sgpaController = List<String>.filled(widget.n, "");
_creditController = List<String>.filled(widget.n, "");

    list = List<int>.generate(widget.n, (i) => i);

  }

  @override
  Widget build(BuildContext context) {

    double sumOfCreditMulSGPA = 0, sumOfCredit = 0;
    double cgpa = 0.0;
    var fields = <Widget>[];
    bool insertedValue = true;

    for (var i in list) {
      fields.add(
         Row(
            children: [
              //subject er text
               Text(
                "Semester ${i+1}:",
                style:  const TextStyle(
                    color: Colors.black87, fontWeight: FontWeight.bold),
              ),
               const Padding(
                padding:  EdgeInsets.all(10.0),
              ),

              //sgpa er textField
              SizedBox(
                width: 60.0,
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(hintText: "SGPA"),
                  onChanged: (value) {
                    setState(() {
                      _sgpaController[i] = value;
                    });
                  },
                ),
              ),
              const Padding(
                padding:  EdgeInsets.all(35.0),
              ),

              //credit er textField
              SizedBox(
                width: 60.0,
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(hintText: "CREDIT"),
                  onChanged: (s) {
                    setState(() {
                      _creditController[i] = s;
                    });
                  },
                ),
              ),
            ]),
      );
    }



    return Scaffold(
      appBar: AppBar(
        title: const Text("CGPA calculator",style: TextStyle(color: Colors.white)),
        backgroundColor:const Color.fromRGBO(34, 9, 44, 1),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
        const Row(
        children: [
         Padding(
        padding: EdgeInsets.only(left: 120.0,top: 20.0),
      ),
         Text(
          "SGPA",
          overflow: TextOverflow.ellipsis,
          style:  TextStyle(fontWeight: FontWeight.bold,fontSize: 17.0),
        ),
         Padding(
          padding: EdgeInsets.only(left: 80.0),
        ),
         Text(
          "Credits",
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17.0),
        ),
         Padding(
          padding: EdgeInsets.only(bottom:5.0),
        ),
        ]
    ),
            Container(
              decoration: BoxDecoration(
                  border:  Border.all(color: Colors.transparent, width: 30.0)),
              child: Column(
                children: fields,
              ),
            ),

              ElevatedButton(
              //padding: EdgeInsets.all(10.0),
              //color: Colors.deepOrange,
              child: const Text("Calculate CGPA",
               
              style: TextStyle(fontSize: 15.0,color: Colors.white),),
              style: ElevatedButton.styleFrom(
      backgroundColor:  const Color.fromRGBO(34, 9, 44, 1), // Set button background color
    ),
              onPressed: () {

                for (int i = 0; i < widget.n; i++) {
                  if(_creditController[i]==null){
                    insertedValue = false;
                    continue;
                  }
                  if(_sgpaController[i]==null){
                    insertedValue = false;
                    continue;
                  }

                  double sgpa = double.parse(_sgpaController[i]);
                  int credit = int.parse(_creditController[i]);

                  double creditMulSGPA = credit * sgpa;
                  sumOfCreditMulSGPA += creditMulSGPA; //sumOfCreditMulSGPA = sumOfCreditMulSGPA+creditMulSGPA
                  sumOfCredit += credit; //sumOfCredit = sumOfCredit+credit
                }
                cgpa = sumOfCreditMulSGPA / sumOfCredit;

                if(insertedValue==true) {
                  Navigator.of(context).push(
                     MaterialPageRoute(
                      builder: (BuildContext context) =>  ResultPage(cgpa),
                    ),
                  );
                } else{
                  showAlertBox();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  showAlertBox() {
    return showDialog<Null>(
      context: context,
     barrierDismissible: false,
      builder: (BuildContext context) {
        return  AlertDialog(
          title:  const Text('Please enter some value to calculate'),
          actions: <Widget>[
              TextButton(
              child: const Icon(Icons.clear),
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
