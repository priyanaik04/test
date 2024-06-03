import 'package:chatapp/firebase/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:provider/provider.dart';
import 'package:chatapp/faculty/faculty_dashboard.dart';
import '../login_page.dart';
import '../redux/reducer.dart';
import '../student/student_dashboard.dart';

class Wrapper extends HookWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    if (auth.getUser() == null) {
      return const Login();
    } else {
      return StoreConnector<AppState, AppState>(
          converter: (store) => store.state,
          builder: (_, state) {
            if (state.isStudent != null) {
              if (state.isStudent) {
                return StudentDashboard(
                  email: state.email,
                );
              } else {
                return FacultyDashboard(
                  email: state.email,
                );
              }
            }
            return FacultyDashboard(email: state.email);
          });
    }
  }
}
