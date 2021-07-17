import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/login_screen.dart';
import '../services/auth.dart';
import '../services/check_internet.dart';
import '../widgets/logo.dart';

class WelcomeScreen extends StatefulWidget {
  static const String routeName = '/';
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
    Future.delayed(Duration(seconds: 0)).then((_) async {
      // _isConnected = await CheckInternet.checkInternet();
      if (!_isConnected) {
        // tryAutoLogin();
        Navigator.of(context).pushReplacementNamed(LogInScreen.routeName);
      } else {
        print('No internet ');
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
