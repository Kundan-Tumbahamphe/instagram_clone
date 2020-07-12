import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/signup_screen.dart';
import 'package:instagram_clone/services/auth_service.dart';
import 'package:instagram_clone/widgets/custom_flat_button.dart';

class LoginScreen extends StatefulWidget {
  static final id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginFormKey = GlobalKey<FormState>();
  String _email, _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Instagram',
                style: const TextStyle(
                  fontFamily: 'Billabong',
                  fontSize: 40.0,
                ),
              ),
              Form(
                key: _loginFormKey,
                child: Column(
                  children: <Widget>[
                    _buildEmailTF(),
                    _buildPasswordTF(),
                    const SizedBox(height: 18.0),
                    CustomFlatButton(
                      buttonText: 'Login',
                      onPressed: _submit,
                    ),
                    const SizedBox(height: 18.0),
                    CustomFlatButton(
                      buttonText: 'Signup',
                      onPressed: () =>
                          Navigator.pushNamed(context, SignupScreen.id),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildEmailTF() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 8.0),
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(labelText: 'Email'),
        validator: (inputValue) =>
            !inputValue.contains('@') ? 'Invalid email' : null,
        onSaved: (inputValue) => _email = inputValue,
      ),
    );
  }

  _buildPasswordTF() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 8.0),
      child: TextFormField(
        decoration: InputDecoration(labelText: 'Password'),
        obscureText: true,
        validator: (inputValue) => inputValue.length < 6
            ? 'Password must be at least 6 characters'
            : null,
        onSaved: (inputValue) => _password = inputValue,
      ),
    );
  }

  _submit() {
    if (_loginFormKey.currentState.validate()) {
      _loginFormKey.currentState.save();

      AuthService.login(email: _email, password: _password);
    }
  }
}
