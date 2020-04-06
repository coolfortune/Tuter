import 'package:Tuter/customTextField.dart';
import 'package:Tuter/login-buttons.dart';
import 'package:flutter/material.dart';

class ForgotPage extends StatefulWidget {
  ForgotPage({Key key}) : super(key: key);
  @override
  _ForgotPage createState() => new _ForgotPage();
}

class _ForgotPage extends State<ForgotPage> {
  final formKey = new GlobalKey<FormState>();

  String _email;

  void saveUserInformation() {
    final form = formKey.currentState;
    if (form.validate()) {
      print('Form is valid');
    } else {
      print('Form is invalid');
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
                    validator: (input) => input.isEmpty ? '*Required' : null,
                    onSaved: (value) => _email = value,
                  ),
                  SizedBox(height: 50.0),
                  LoginButton(
                    text: 'Send Verification Code',
                    padding: 50.0,
                    onPressed: () => saveUserInformation,
                  ),
                  SizedBox(height: 100.0),
                  LoginButton(
                    text: 'Go Back',
                    onPressed: () => Navigator.of(context).pop(),
                  ),
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
