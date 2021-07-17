import 'package:flutter/material.dart';
import '../widgets/login_screen_background.dart';

class LogInScreen extends StatefulWidget {
  static const String routeName = '/login-screen';
  const LogInScreen({Key? key}) : super(key: key);

  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  bool _hidePassword = true;
  void validate() {
    FormState formState = _formKey.currentState ?? FormState();
    if (formState.validate()) {
      print("hello");
    } else {
      print('');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: LogInScreenBackground(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                fit: FlexFit.tight,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                      // child: Image.asset(
                      //   'assets/images/tasqment-logo.png',
                      //   fit: BoxFit.contain,
                      // ),
                      ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  focusNode: _emailFocusNode,
                  autofocus: true,
                  controller: _emailController,
                  validator: (String? email) {
                    if (email!.contains('@') &&
                        (email.contains('.com') || email.contains('.net')))
                      return '';
                    return 'Input valid email';
                  },
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_passwordFocusNode);
                  },
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.go,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 5,
                      child: TextFormField(
                        focusNode: _passwordFocusNode,
                        controller: _passwordController,
                        obscureText: _hidePassword,
                        onFieldSubmitted: (_) {},
                        validator: (_) {
                          if (_passwordController.text.isEmpty) {
                            return 'Input valid password';
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: IconButton(
                        icon: Icon(
                          Icons.remove_red_eye,
                          color: _hidePassword ? Colors.purple : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _hidePassword = !_hidePassword;
                          });
                        },
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  onPressed: () {
                    validate();
                    //TODO login
                  },
                  child: Text(
                    'Log In',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              Row(
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
            ],
          ),
        ),
      ),
    );
  }
}
