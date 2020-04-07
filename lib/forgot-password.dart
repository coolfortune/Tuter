import 'package:Tuter/customTextField.dart';
import 'package:Tuter/login-buttons.dart';
import 'package:Tuter/validate.dart';
import 'package:flutter/material.dart';

class ForgotPage extends StatefulWidget {
  ForgotPage({Key key}) : super(key: key);
  @override
  _ForgotPage createState() => new _ForgotPage();
}

class _ForgotPage extends State<ForgotPage> {
  final formKey = GlobalKey<FormState>();

  String _email;

  void saveUserInformation() {
    final form = formKey.currentState;
    if (form.validate()) {
      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ValidatePage()));
      print('Form is valid');
    } else {
      print('Form is invalid');
    }
  }

  String validateEmail(input) {
    RegExp pattern = RegExp(r"^[a-zA-Z0-9]+@[a-zA-z]*\.[a-z]{2,}$");

    if (pattern.hasMatch(input)) {
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
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  CustomTextField(
                    hint: 'Please enter your Email Address',
                    validator: validateEmail,
                    onSaved: (value) => _email = value,
                  ),
                  SizedBox(height: 50.0),
                  LoginButton(
                    text: 'Send Verification Code',
                    padding: 50.0,
                    onPressed: saveUserInformation,
                  ),
                  SizedBox(height: 100.0),
                ],
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}
