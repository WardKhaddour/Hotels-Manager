import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../widgets/login_form.dart';

class LogInScreen extends StatelessWidget {
  static const String routeName = '/login-screen';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder(
          future: Firebase.initializeApp(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return LoginForm();
            } else if (snapshot.connectionState == ConnectionState.none) {
              return Text("No data");
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
