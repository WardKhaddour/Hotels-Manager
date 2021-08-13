import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import '../controllers/auth_controller.dart';
import '../screens/hotels_screen.dart';
import './logo.dart';
import 'custom_button.dart';

enum SignMode {
  LogIn,
  SignUp,
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _authController = AuthController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  SignMode _signMode = SignMode.LogIn;
  bool _hidePassword = true;
  bool _saveUser = true;
  bool _loading = false;
  void changeMode() {
    setState(() {
      _signMode == SignMode.SignUp
          ? _signMode = SignMode.LogIn
          : _signMode = SignMode.SignUp;
    });
  }

  Future<void> validateAndSignUp() async {
    FormState? formState = _formKey.currentState ?? FormState();
    final isValid = formState.validate();
    if (!isValid) return;
    setState(() {
      _loading = true;
    });
    await _authController
        .signUp(_emailController.text, _passwordController.text)
        .then((value) {
      if (value == null) {
        Get.snackbar('Error', 'something went wrong!');
      } else {
        Get.offNamed(HotelsScreen.routeName);
      }
    });
    setState(() {
      _loading = false;
    });
  }

  Future<void> validateAndLogin() async {
    FormState? formState = _formKey.currentState ?? FormState();
    final isValid = formState.validate();
    if (!isValid) return;
    setState(() {
      _loading = true;
    });
    if (_saveUser) {
      final pref = await SharedPreferences.getInstance();
      await pref.setBool('save-user', _saveUser);
    }

    await _authController
        .login(_emailController.text, _passwordController.text)
        .then((res) {
      if (res == null) {
        Get.snackbar('Error', 'something went wrong!');
      } else {
        Get.offNamed(HotelsScreen.routeName);
      }
    });
    setState(() {
      _loading = false;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _loading,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Logo(),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                focusNode: _emailFocusNode,
                autofocus: true,
                controller: _emailController,
                validator: (email) {
                  if (email!.contains('@') &&
                      (email.contains('.com') || email.contains('.net'))) {
                    return null;
                  }
                  return 'Input valid email';
                },
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_passwordFocusNode);
                },
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.go,
                decoration: kTextFieldDecoration.copyWith(hintText: 'Email'),
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                focusNode: _passwordFocusNode,
                controller: _passwordController,
                obscureText: _hidePassword,
                onFieldSubmitted: (_) async {
                  await validateAndLogin();
                },
                validator: (_) {
                  if (_passwordController.text.isEmpty &&
                      _passwordController.text.length < 6) {
                    return 'Input valid password';
                  }
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.remove_red_eye,
                      color: _hidePassword ? Colors.purple : Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        _hidePassword = !_hidePassword;
                      });
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
            if (_signMode == SignMode.LogIn)
              ListTile(
                title: Text('Remember this user'),
                trailing: Checkbox(
                  fillColor: MaterialStateProperty.all(Colors.purple),
                  onChanged: (value) {
                    setState(() {
                      _saveUser = value ?? true;
                    });
                  },
                  value: _saveUser,
                ),
              ),
            CustomButton(
              onPress: _signMode == SignMode.LogIn
                  ? validateAndLogin
                  : validateAndSignUp,
              title: _signMode == SignMode.LogIn ? 'Log In' : 'Create Account',
            ),
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      _signMode == SignMode.LogIn
                          ? 'Don\'t Have Account Yet?'
                          : '',
                    ),
                  ),
                  CustomButton(
                    onPress: changeMode,
                    title:
                        _signMode == SignMode.LogIn ? 'Create Now' : 'Log In',
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
