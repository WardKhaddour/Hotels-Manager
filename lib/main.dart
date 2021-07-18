import 'package:flutter/material.dart';
import 'package:get/get.dart';

import './constants.dart';
import './controllers/auth_controller.dart';
import './controllers/hotels_controller.dart';
import './screens/hotels_screen.dart';
import './screens/login_screen.dart';
import './screens/welcome_screen.dart';

void main() {
  Get.lazyPut(() => AuthController());
  Get.lazyPut(() => HotelsController());
  runApp(HotelsManager());
}

class HotelsManager extends StatelessWidget {
  const HotelsManager({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
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
        HotelsScreen.routeName: (ctx) => HotelsScreen(),
      },
    );
  }
}
