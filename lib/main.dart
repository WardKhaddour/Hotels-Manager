import 'package:flutter/material.dart';

import './constants.dart';
import './screens/login_screen.dart';
import './screens/welcome_screen.dart';

void main() {
  runApp(HotelsManager());
}

class HotelsManager extends StatelessWidget {
  const HotelsManager({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.purple,
        primaryColor: Colors.purple,
        accentColor: Colors.pink,
        fontFamily: uchen_family,
        focusColor: Colors.purple,
      ),
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.purple,
        primaryColor: Colors.purple,
        accentColor: Colors.pink,
        fontFamily: uchen_family,
      ),
      themeMode: ThemeMode.dark,
      initialRoute: WelcomeScreen.routeName,
      routes: {
        WelcomeScreen.routeName: (ctx) => WelcomeScreen(),
        LogInScreen.routeName: (ctx) => LogInScreen(),
      },
    );
  }
}
