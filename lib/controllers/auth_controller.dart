import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/auth.dart';

class AuthController extends GetxService {
  final _auth = AuthService();
  final isLoggedIn = false.obs;

  @override
  void onInit() async {
    final _auth = FirebaseAuth.instance;
    _auth.idTokenChanges().listen((event) {
      isLoggedIn.value = event != null;
      if (event == null) {
        _auth.currentUser?.refreshToken;
      }
    });

    super.onInit();
  }

  Future<void> login(String email, String password) async {
    await _auth.signIn(email, password);
  }
}
