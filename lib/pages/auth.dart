import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../ui/button_dark.dart';
import '../models/user.dart';
import '../scoped-models/main.dart';

enum AuthMode { Signup, Login }

class AuthPage extends StatefulWidget {
  final MainModel model;

  AuthPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage> {
  final User user = new User(); //User is only used to hold form data for now
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = new TextEditingController();
  AuthMode _authMode = AuthMode.Login;

  @override
  initState() {
    FirebaseAuth.instance.onAuthStateChanged.listen((firebaseUser) {
      if (firebaseUser != null) {
        print("sign in ok");
        widget.model.user = firebaseUser;
        Navigator.pushReplacementNamed(context, '/pokemon_feed');
      } else {
        widget.model.user = null;
      }
    });

    super.initState();
  }

  void _submitForm(Function login, Function signup) {
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();

    if (_authMode == AuthMode.Login) {
      login(user.email, user.password).then((FirebaseUser firebaseUser) {
        if (firebaseUser != null) {
          print(firebaseUser);
        } else {
          print("Something went wrong logging int");
        }
      });
    } else {
      signup(user.email, user.password).then((FirebaseUser firebaseUser) {
        if (firebaseUser != null) {
          print(firebaseUser);
        } else {
          print("Something went wrong signing up");
        }
      });
    }
  }

  Widget _buildEmailField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Email"),
      keyboardType: TextInputType.emailAddress,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Email is required';
        }

        if (!RegExp(
                r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
            .hasMatch(value)) {
          return 'Please enter a valid email address';
        }
      },
      onSaved: (String value) {
        user.email = value;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Password"),
      obscureText: true,
      controller: _passwordController,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Password is required';
        }

        if (value.length < 10 || value.length > 50) {
          return 'Password must be betweem 10 and 50 characters';
        }
      },
      onSaved: (String value) {
        user.password = value;
      },
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Confirm Password"),
      obscureText: true,
      validator: (String value) {
        if (_passwordController.text != value) {
          return 'Passwords do not match';
        }
      },
    );
  }

  Widget _buildAcceptSwitch() {
    return SwitchListTile(
      value: user.acceptTerms,
      onChanged: (bool value) {
        setState(() {
          user.acceptTerms = value;
        });
      },
      title: Text('Accept Terms'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("LOGIN")),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Image.asset('assets/pikachu.png', height: 160),
                Text(
                  "Pokemon Manager",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 28),
                ),
                SizedBox(height: 32),
                _buildEmailField(),
                _buildPasswordField(),
                _authMode == AuthMode.Signup ? _buildConfirmPasswordField() : Container(),
                SizedBox(height: 16),
                FlatButton(
                  child: Text(
                    'Switch to ${_authMode == AuthMode.Login ? 'Signup' : 'Login'}',
                  ),
                  onPressed: () {
                    setState(() {
                      _authMode = _authMode == AuthMode.Login ? AuthMode.Signup : AuthMode.Login;
                    });
                  },
                ),
                SizedBox(height: 16),
                _buildAcceptSwitch(),
                SizedBox(height: 16),
                ScopedModelDescendant<MainModel>(
                  builder: (BuildContext context, Widget widget, MainModel model) {
                    return model.isLoading
                        ? CircularProgressIndicator()
                        : DarkButton(
                            _authMode == AuthMode.Login ? 'LOGIN' : 'SIGNUP',
                            () => _submitForm(model.login, model.signup),
                          );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
