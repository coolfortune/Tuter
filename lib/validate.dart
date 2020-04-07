import 'package:Tuter/customTextField.dart';
import 'package:Tuter/login-buttons.dart';
import 'package:flutter/material.dart';

class ValidatePage extends StatefulWidget{
  ValidatePage({Key key}) : super(key: key);
  @override
  _ValidatePage createState() => new _ValidatePage();
}

class _ValidatePage extends State<ValidatePage> {
  final formKey = GlobalKey<FormState>();

  String _code;

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
                    hint: 'Enter your validation code',
                    validator: (value) => 's',
                    onSaved: (value) => _code = value,
                  ),
                  SizedBox(height: 50.0),
                  LoginButton(
                    text: 'Verify',
                    onPressed: () => null,
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