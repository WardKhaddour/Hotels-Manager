import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../screens/login_screen.dart';
import '../services/check_internet.dart';
import '../widgets/logo.dart';
import 'hotels_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static const String routeName = '/welcome-screen';
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _isConnected = false;

  Future<bool?> tryAutoLogin() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1)).then((_) async {
      _isConnected = await CheckInternet.checkInternet();
      if (_isConnected) {
        final autoLogin = await tryAutoLogin();
        if (!autoLogin!) {
          Get.offNamed(LogInScreen.routeName);
        } else {
          Get.offNamed(HotelsScreen.routeName);
        }
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
