import 'package:flutter/material.dart';
import 'package:chatapp/student/gpaScreens/cgpa_user.dart';

class ResultPage extends StatelessWidget {
  final double score;
  const ResultPage(this.score, {super.key});
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.deepOrange,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text("Your CGPA is: ",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 40.0)),
          Text(score.toStringAsFixed(score.truncateToDouble() == score ? 0 : 2),
              // ignore: prefer_const_constructors
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 50.0)),
          IconButton(
            icon: const Icon(
              Icons.restore,
              size: 30.0,
            ),
            color: Colors.white,
            iconSize: 50.0,
            // ignore: unnecessary_null_comparison
            onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (BuildContext context) => Cgpa_user()),
                (Route route) => route == null),
          )
        ],
      ),
    );
  }
}
