import 'package:chatapp/student/mock/quizpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class quizpage extends StatefulWidget {
  @override
  _quizpageState createState() => _quizpageState();
}

class _quizpageState extends State<quizpage> {
  List<String> images = [
    "images/py.jpg",
    "images/aptitude.jpg",
    "images/js.jpg",
    "images/cpp.jpg",
    "images/linux.jpg",
  ];

  List<String> des = [
    "Python",
    "Apptitude ",
    "C language",
    "C++",
    "Linux",
  ];

  Widget customcard(String langname, String image, String des) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 20.0,
        horizontal: 30.0,
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            // in changelog 1 we will pass the langname name to ther other widget class
            // this name will be used to open a particular JSON file
            // for a particular language
            builder: (context) => getjson(langname),
          ));
        },
        child: Material(
          color: Color.fromRGBO(238, 78, 52, 1),
          elevation: 10.0,
          borderRadius: BorderRadius.circular(25.0),
          child: Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 10.0,
                  ),
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(100.0),
                    child: Container(
                      // changing from 200 to 150 as to look better
                      height: 150.0,
                      width: 150.0,
                      child: ClipOval(
                        child: Image(
                          fit: BoxFit.cover,
                          image: AssetImage(
                            image,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    langname,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                      fontFamily: "Quando",
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    des,
                    style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                        fontFamily: "Alike"),
                    maxLines: 5,
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "PlacementEdge",
          style: TextStyle(
            fontFamily: "Montserrat-Bold",
          ),
        ),
      ),
      body: ListView(
        children: <Widget>[
          customcard("Python", images[0], des[0]),
          customcard("Java", images[1], des[1]),
          customcard("Javascript", images[2], des[2]),
          customcard("C++", images[3], des[3]),
          customcard("Linux", images[4], des[4]),
        ],
      ),
    );
  }
}
