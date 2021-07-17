import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import '../services/auth.dart';
import './logo.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  bool _hidePassword = true;
  bool _saveUser = true;
  Future<void> validateAndLogin() async {
    FormState? formState = _formKey.currentState ?? FormState();
    if (formState.validate()) {
      print("hello");
    } else {
      print('');
    }
    if (_saveUser) {
      final pref = await SharedPreferences.getInstance();
      await pref.setString('email', _emailController.text);
      await pref.setString('password', _passwordController.text);
    }
    AuthService? authService = AuthService();
    await authService.signIn(_emailController.text, _passwordController.text);
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
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Logo(),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              focusNode: _emailFocusNode,
              // autofocus: true,
              controller: _emailController,
              validator: (email) {
                if (email!.contains('@') &&
                    (email.contains('.com') || email.contains('.net'))) {
                  return '';
                }
                return 'Input valid email';
              },
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_passwordFocusNode);
              },
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.go,
              decoration: kEmailTextFieldDecoration,
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
                if (_passwordController.text.isEmpty) {
                  return 'Input valid password';
                }
              },
              decoration: kEmailTextFieldDecoration.copyWith(
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
          ListTile(
            title: Text('Remember this user'),
            trailing: Checkbox(
              onChanged: (value) {
                setState(() {
                  _saveUser = value ?? true;
                });
              },
              value: _saveUser,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              onPressed: validateAndLogin,
              child: Text(
                'Log In',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    onPressed: () {
                      //TODO create new user
                    },
                    child: Text('Create Account'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
