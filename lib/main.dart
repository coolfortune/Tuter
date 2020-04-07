import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Tuter/customTextField.dart';
import 'package:Tuter/login-buttons.dart';
import 'package:Tuter/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Tuter/home.dart';

void main() => runApp(MyApp());

Future navigateToSignupPage(context) async {
  Navigator.of(context).push(_createRoute());
}

Future navigateToHomePage(context) async {
  Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => SignupPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(1.0, 0.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tüter',
      theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primaryColor: Color(0xFFFFDD28)),
      home: MyHomePage(title: 'Tüter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  String _email, _password;
  static const String googleLogo =
      'https://cdn.clipart.email/13189a23fab66bb83ac56be2723942ee_download-free-png-google-logo-png-transparent-pictures-_945-945.png';

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: SingleChildScrollView(
          child: Column(
            // Column is also a layout widget. It takes a list of children and
            // arranges them vertically. By default, it sizes itself to fit its
            // children horizontally, and tries to be as tall as its parent.
            //
            // Invoke "debug painting" (press "p" in the console, choose the
            // "Toggle Debug Paint" action from the Flutter Inspector in Android
            // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
            // to see the wireframe for each widget.
            //
            // Column has various properties to control how it sizes itself and
            // how it positions its children. Here we use mainAxisAlignment to
            // center the children vertically; the main axis here is the vertical
            // axis because Columns are vertical (the cross axis would be
            // horizontal).
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
                      onSaved: (value) => _email = value.trim(),
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
              LoginButton(text: 'Login', onPressed: logIn),
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
                        Image.network(
                          googleLogo,
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
              SizedBox(height: 60.0),
              Text(
                'New to Tüter?',
                style: TextStyle(
                  fontSize: 17.0,
                ),
              ),
              LoginButton(
                  text: 'Sign Up',
                  padding: 110.0,
                  onPressed: () => navigateToSignupPage(context)),
              SizedBox(height: 10.0),
            ],
          ),
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }

  Future<void> logIn() async {
    final formState = _formKey.currentState;
      if(formState.validate()){
        formState.save();
        try{
          AuthResult user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);
          // TODO: Redirect to homepage
          navigateToHomePage(context);
        }catch(e){
          print(e.toString());
        }
      }
  }
}
