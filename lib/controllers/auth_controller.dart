import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/login_screen.dart';

import '../services/auth.dart';

class AuthController extends GetxService {
  final _auth = AuthService();
  final isLoggedIn = false.obs;
  bool keepRefresh = true;
  String? currentUser;
  @override
  void onInit() async {
    final _auth = FirebaseAuth.instance;
    currentUser = _auth.currentUser!.email!;
    _auth.idTokenChanges().listen((event) {
      isLoggedIn.value = event != null;
      if (event == null && keepRefresh) {
        _auth.currentUser?.refreshToken;
      }
    });

    super.onInit();
  }

  Future login(String email, String password) async {
    keepRefresh = true;
    return await _auth.signIn(email, password);
  }

  Future signUp(String email, String password) async {
    keepRefresh = true;
    return await _auth.signUp(email, password);
  }

  Future<void> logout() async {
    keepRefresh = false;
    await _auth.signOut();
    Get.offNamed(LogInScreen.routeName);
  }
}
