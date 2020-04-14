import 'package:Tuter/loading.dart';
import 'package:flutter/material.dart';
import 'package:Tuter/backend/auth.dart';

import 'logIn.dart';

class SignupPage extends StatefulWidget {
  SignupPage({Key key}) : super(key: key);
  @override
  _SignupPage createState() => new _SignupPage();
}

enum StudentType { student, tutor }

class _SignupPage extends State<SignupPage> {
  final formKey = new GlobalKey<FormState>();
  final Auth _auth = Auth();
  bool loading = false;

  String _email;
  String _password;
  String _firstName;
  String _lastName;
  String _major;

  StudentType _type = StudentType.student;

  // function to register during sign up on click of confirm
  void saveUserInformation() async {
    final form = formKey.currentState;
    // if form is valid, register
    if (form.validate())
    {
      form.save();
      print('Form is valid');
      // check for student, create user and Student collection
      if (_type == StudentType.student)
      {
        setState(() => loading = true);
        print('registering student');
        dynamic result = await _auth.registerStudent(_email.trim(), _password, _firstName, _lastName, _major);
        setState(() => loading = false);
        if (result == null)
        {
          setState(() 
          {
            print('registration failed');
          });
        }
      }
      // check for Tutor, create user and Tutor collection
      else if (_type == StudentType.tutor)
      {
        setState(() => loading = true);
        print('registering tutor');
        dynamic result = await _auth.registerTutor(_email.trim(), _password, _firstName, _lastName, _major);
        setState(() => loading = false);
        if (result == null)
        {
          setState(() 
          {
            print('registration failed');
          });
        }
      }
    } 
    else 
    {
      print('Form is invalid');
    }    
  }

  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
        appBar: new AppBar(
          title: Text('Hello, Welcome to Tüter!'),
        ),
        body: new SingleChildScrollView(
          child: new Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: new Form(
                key: formKey,
                child: new Column(children: <Widget>[
                  new TextFormField(
                    decoration: new InputDecoration(labelText: 'First Name'),
                    validator: (input) => Validators.generic(input, 'Please enter your first name'),
                    onSaved: (value) => _firstName = value,
                    textCapitalization: TextCapitalization.words,
                  ),
                  new TextFormField(
                    decoration: new InputDecoration(labelText: 'Last Name'),
                    validator: (input) => Validators.generic(input, 'Please enter your last name'),
                    onSaved: (value) => _lastName = value,
                    textCapitalization: TextCapitalization.words,
                  ),
                  new TextFormField(
                    decoration: new InputDecoration(labelText: 'Major'),
                    validator: (input) => Validators.generic(input, 'Please enter your major'),
                    onSaved: (value) => _major = value,
                    textCapitalization: TextCapitalization.words,
                  ),
                  new TextFormField(
                    decoration: new InputDecoration(labelText: 'Email'),
                    validator: Validators.validateEmail,
                    onSaved: (value) => _email = value,
                  ),
                  new TextFormField(
                    decoration: new InputDecoration(labelText: 'Password'),
                    validator: Validators.password,
                    obscureText: true,
                    onSaved: (value) => _password = value,
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Sign Up as a: ',
                    style: TextStyle(
                      fontSize: 15.0,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Row(
                    children: <Widget>[
                      Radio(
                          activeColor: Theme.of(context).primaryColor,
                          value: StudentType.student,
                          groupValue: _type,
                          onChanged: (StudentType value) {
                            setState(() {
                              _type = value;
                            });
                          }),
                      Text(
                        'Student',
                        style: TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                      Radio(
                          activeColor: Theme.of(context).primaryColor,
                          value: StudentType.tutor,
                          groupValue: _type,
                          onChanged: (StudentType value) {
                            setState(() {
                              _type = value;
                            });
                          }),
                      Text(
                        'Tutor',
                        style: TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 25.0),
                  new RawMaterialButton(
                    padding: EdgeInsets.symmetric(horizontal: 120.0),
                    fillColor: Colors.black,
                    elevation: 2.0,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                        'Confirm',
                        maxLines: 1,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                    shape: const StadiumBorder(),
                    onPressed: saveUserInformation,
                  ),
                  //LoginButton(text: 'Confirm'),
                ])),
          ),
        ));
  }
}
