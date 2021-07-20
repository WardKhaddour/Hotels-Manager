import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import '../screens/login_screen.dart';
import '../services/auth.dart';
import '../services/check_internet.dart';
import '../widgets/logo.dart';

class WelcomeScreen extends StatefulWidget {
  static const String routeName = '/welcome-screen';
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _isConnected = false;

  Future<void> tryAutoLogin() async {
    final pref = await SharedPreferences.getInstance();
    final email = pref.getString('email') ?? '';
    final password = pref.getString('password') ?? '';
    if (email.isNotEmpty && password.isNotEmpty) {
      await AuthService().signIn(email, password);
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1)).then((_) async {
      _isConnected = await CheckInternet.checkInternet();
      print('is connected $_isConnected');
      if (_isConnected) {
        // await tryAutoLogin();
        Get.offNamed(LogInScreen.routeName);
      } else {
        Get.snackbar(
          'No Internet',
          'Connect and retry',
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Logo(),
          Expanded(
            flex: 1,
            child: Text(
              'TasQment',
              style:
                  TextStyle(color: Colors.grey.withOpacity(0.7), fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }
}
