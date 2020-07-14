import 'package:flutter/material.dart';
import 'package:instagram_clone/services/auth_service.dart';
import 'package:instagram_clone/widgets/custom_flat_button.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _signupFormKey = GlobalKey<FormState>();
  String _name, _email, _password;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                      key: _signupFormKey,
                      child: Column(
                        children: <Widget>[
                          _buildNameTF(),
                          _buildEmailTF(),
                          _buildPasswordTF(),
                          const SizedBox(height: 18.0),
                          CustomFlatButton(
                            buttonText: 'Signup',
                            onPressed: _submit,
                          ),
                          const SizedBox(height: 18.0),
                          CustomFlatButton(
                            buttonText: 'Back to login',
                            onPressed: () => Navigator.pop(context),
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

  _buildNameTF() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 8.0),
      child: TextFormField(
        decoration: InputDecoration(labelText: 'Name'),
        validator: (inputValue) =>
            inputValue.trim().isEmpty ? 'Name must not be empty' : null,
        onSaved: (inputValue) => _name = inputValue,
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

  _submit() async {
    if (_signupFormKey.currentState.validate()) {
      _signupFormKey.currentState.save();

      setState(() => _isLoading = true);

      await Provider.of<AuthService>(context, listen: false).signup(
          context: context, name: _name, email: _email, password: _password);

      setState(() => _isLoading = false);
    }
  }
}
