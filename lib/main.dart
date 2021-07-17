import 'package:flutter/material.dart';
import './screens/login_screen.dart';

void main() {
  runApp(HotelsManager());
}

class HotelsManager extends StatelessWidget {
  const HotelsManager({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        primaryColor: Colors.purple,
        accentColor: Colors.pink,
      ),
      initialRoute: LogInScreen.routeName,
      routes: {
        LogInScreen.routeName: (ctx) => LogInScreen(),
      },
    );
  }
}
