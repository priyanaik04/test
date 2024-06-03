import 'package:chatapp/faculty/faculty_login.dart';
import 'package:chatapp/student/student_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Image.asset(
              "assets/images/welcome.gif",
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () {
                    // Navigator.pushNamed(context, 's_login_form');
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => const KeyboardVisibilityProvider(
                            child: StudentLogin())));
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    margin: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/images/student_l.png",
                        ),
                        const Text("Student",
                            style:
                                TextStyle(fontFamily: 'Custom', fontSize: 20)),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () {
                    // Navigator.pushNamed(context, 't_login_form');
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => const KeyboardVisibilityProvider(
                            child: FacultyLogin())));
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    margin: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/images/teacher_l.png",
                          repeat: ImageRepeat.repeat,
                        ),
                        const Text("Faculty",
                            style:
                                TextStyle(fontFamily: 'Custom', fontSize: 20)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
