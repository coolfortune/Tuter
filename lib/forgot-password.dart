import 'package:Tuter/customTextField.dart';
import 'package:Tuter/login-buttons.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPage extends StatefulWidget {
  ForgotPage({Key key}) : super(key: key);
  @override
  _ForgotPage createState() => new _ForgotPage();
}

class _ForgotPage extends State<ForgotPage> {
  final _formKey = GlobalKey<FormState>();

  String _email;

  void saveUserInformation(BuildContext context) async {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();

      FirebaseAuth auth = FirebaseAuth.instance;
      try {
        await auth.sendPasswordResetEmail(email: _email);

        Scaffold.of(context).showSnackBar(SnackBar(
            content: Text('A password reset link has been sent to $_email')));
      } catch (e) {
        print(e);
      }

      print(_email);
      print('Form is valid');
    } else {
      print('Form is invalid');
    }
  }

  String validateEmail(input) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);

    if (regex.hasMatch(input)) {
      return null;
    } else {
      return 'Please enter a valid email address';
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Password Reset'),
      ),
      body: Builder(
        builder: (context) {
        return Center(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(10.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    CustomTextField(
                      hint: 'Please enter your Email Address',
                      validator: validateEmail,
                      onSaved: (value) => _email = value.trim().toLowerCase(),
                    ),
                    SizedBox(height: 50.0),
                    LoginButton(
                      text: 'Send Verification Code',
                      padding: 50.0,
                      onPressed: () => saveUserInformation(context),
                    ),
                    SizedBox(height: 100.0),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}
