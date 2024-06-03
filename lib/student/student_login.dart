import 'package:chatapp/password_reset.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import '../firebase/auth.dart';

class StudentLogin extends StatefulWidget {
  const StudentLogin({super.key});

  @override
  State<StudentLogin> createState() => _StudentLoginState();
}

class _StudentLoginState extends State<StudentLogin> {
  static const String _title = 'Log In';
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isVisible = false;
  bool isClicked = false;

  @override
  Widget build(BuildContext context) {
    final bool isKeyboardVisible =
        KeyboardVisibilityProvider.isKeyboardVisible(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(_title),
        backgroundColor: Color.fromRGBO(34, 9, 44, 1),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                isKeyboardVisible
                    ? SizedBox(
                        width: 150,
                        child: Image.asset("assets/images/keyboardLoad.gif"),
                      )
                    : Container(
                        margin: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Image.asset(
                              "assets/images/student_l.png",
                            ),
                          ],
                        ),
                      ),
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(20),
                    child: const Text(
                      'STUDENT',
                      style: TextStyle(
                          fontSize: 50, fontFamily: 'Montserrat-Bold'),
                    )),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                            left: 40, right: 40, bottom: 20),
                        child: TextFormField(
                          controller: emailController,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[a-z]|[A-Z]|[0-9]|\.|@'))
                          ],
                          validator: (name) {
                            if (name == null || name.isEmpty) {
                              return 'Enter Email Address';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Email',
                          ),
                        ),
                      ), //Email TextField
                      Container(
                        padding: const EdgeInsets.only(
                            left: 40, right: 40, bottom: 20),
                        child: TextFormField(
                          obscureText: !isVisible,
                          validator: (pswd) {
                            if (pswd == null || pswd.isEmpty) {
                              return 'Enter Password';
                            }
                            return null;
                          },
                          controller: passwordController,
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: 'Password',
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isVisible = !isVisible;
                                    });
                                  },
                                  icon: const Icon(Icons.remove_red_eye))),
                        ),
                      ), //Password TextField
                      Container(
                          height: 50,
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: isClicked
                              ? FloatingActionButton(
                                  heroTag: null,
                                  onPressed: null,
                                  backgroundColor:
                                      Color.fromRGBO(238, 78, 52, 1),
                                  child: const CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : FloatingActionButton.extended(
                                  heroTag: null,
                                  backgroundColor:
                                      Color.fromRGBO(238, 78, 52, 1),
                                  label: const Text(
                                    'Log In',
                                    style: TextStyle(
                                        fontSize: 17, color: Colors.white),
                                  ),
                                  onPressed: () async {
                                    setState(() => isClicked = true);
                                    if (formKey.currentState!.validate()) {
                                      await Auth()
                                          .signIn(
                                        username: emailController.text.trim(),
                                        password: passwordController.text,
                                        isStudent: true,
                                      )
                                          .onError((FirebaseException e,
                                              stackTrace) async {
                                        if (e.code == 'user-not-found') {
                                          return await Auth()
                                              .createUser(
                                            username:
                                                emailController.text.trim(),
                                            password: passwordController.text,
                                            isStudent: true,
                                          )
                                              .onError((FirebaseException error,
                                                  stackTrace) {
                                            return null;
                                          }).then((value) => value);
                                          // ScaffoldMessenger.of(context)
                                          //     .showSnackBar(const SnackBar(content: Text("Invalid Email Address.")));
                                        } else if (e.code == 'wrong-password') {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  content: Text(
                                                      "Incorrect Password.")));
                                          setState(() => isClicked = false);
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content:
                                                      Text(e.code.toString())));
                                          setState(() => isClicked = false);
                                        }
                                        return null;
                                        // return false;
                                      }).then((value) {
                                        if (value != null && value) {
                                          Navigator.of(context).pop();
                                        } else {
                                          if (value != null && !value) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content: Text(
                                              "Don't use Faculty Login in Student section.",
                                              maxLines: 2,
                                            )));
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content: Text(
                                              "User not found",
                                              maxLines: 2,
                                            )));
                                          }
                                        }
                                      });
                                    }
                                    setState(() => isClicked = false);
                                  })),
                      // Container(
                      //     height: 70,
                      //     padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      //     child: FloatingActionButton.extended(
                      //         backgroundColor: Color.fromRGBO(238, 78, 52, 1),
                      //         label: const Text(
                      //           'Reset Password',
                      //           style: TextStyle(
                      //               fontSize: 17, color: Colors.white),
                      //         ),
                      //         onPressed: () async {
                      //           Navigator.push(
                      //               context,
                      //               MaterialPageRoute(
                      //                   builder: (_) => const ResetPassword()));
                      //         })),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
