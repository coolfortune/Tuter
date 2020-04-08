import 'package:Tuter/backend/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Tuter/customTextField.dart';
import 'package:Tuter/login-buttons.dart';
import 'package:Tuter/signup.dart';
import 'package:Tuter/forgot-password.dart';
import 'package:Tuter/home.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

Future navigateToPage(context, direction, page) async {
  Navigator.of(context).push(_createRoute(direction, page));
}

Route _createRoute(direction, page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      double xOffset = direction == Direction.left ? -1.0 : 1.0;
      Offset begin = Offset(xOffset, 0.0);
      Offset end = Offset.zero;
      Curve curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

enum Direction { left, right }

class _LogInState extends State<LogIn> {final _formKey = GlobalKey<FormState>();

  final Auth _auth = Auth();
  String _email, _password;

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 30.0),
              Row(
                children: <Widget>[
                  Image(
                    image: AssetImage('lib/images/tuterLogo.png'),
                    height: 130.0,
                    width: 350.0,
                  ),
                ],
              ),
              SizedBox(height: 30.0),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    CustomTextField(
                      hint: 'Email',
                      //password: false
                      validator: (input) => input.isEmpty ? "Required" : null,
                      onSaved: (value) => _email = value.trim().toLowerCase(),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    CustomTextField(
                      hint: 'Password',
                      password: true,
                      validator: (input) => input.isEmpty ? "Required" : null,
                      onSaved: (value) => _password = value.trim(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25.0),
              LoginButton(
                text: 'Login',
                onPressed: () async{
                  final form = _formKey.currentState;
                  if(_formKey.currentState.validate())
                    {
                      form.save();
                      dynamic result = await _auth.logIn(_email, _password);
                      if(result == null)
                        print('Email or password is incorrect');
                    }
                }
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 35.0, vertical: 8.0),
                child: RawMaterialButton(
                  fillColor: Colors.lightBlue[800],
                  elevation: 2.0,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image(
                          image: AssetImage('lib/images/googleLogo.png'),
                          height: 25.0,
                          width: 25.0,
                        ),
                        SizedBox(width: 15.0),
                        Text(
                          'Login with Google',
                          maxLines: 1,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  shape: StadiumBorder(),
                  onPressed: () => null,
                ),
              ),
              FlatButton(
                onPressed: () =>
                    navigateToPage(context, Direction.left, ForgotPage()),
                child: Text(
                  'Forgot Password?',
                ),
              ),
              SizedBox(height: 50.0),
              Text(
                'New to Tüter?',
                style: TextStyle(
                  fontSize: 17.0,
                ),
              ),
              LoginButton(
                  text: 'Sign Up',
                  padding: 110.0,
                  onPressed: () =>
                      navigateToPage(context, Direction.right, SignupPage())),
              SizedBox(height: 10.0),
            ],
          ),
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }

  // Future<void> logIn() async {
  //   final formState = _formKey.currentState;
  //     if(formState.validate()){
  //       formState.save();
  //       try{
  //         AuthResult user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);
  //        // navigateToPage(context, Direction.right, HomePage());
  //       }catch(e){
  //         print(e.toString());
  //       }
  //     }
  // }
}