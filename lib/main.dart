import 'package:flutter/material.dart';
import 'package:Tuter/customTextField.dart';
import 'package:Tuter/login-buttons.dart';
import 'package:Tuter/signup.dart';
import 'package:Tuter/home.dart';

void main() => runApp(MyApp());

  Future navigateToSignupPage(context) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => SignupPage()));
  }

  Future navigateToHomePage(context) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
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
              Column(
                children: <Widget>[
                  CustomTextField(
                    hint: 'Email',
                    //password: false
                    //validator: form validator function
                    //onSaved: function called on saving
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  CustomTextField(
                    hint: 'Password',
                    password: true,
                    validator: (input) => input.isEmpty ? "Required" : null,
                  ),
                ],
              ),
              SizedBox(height: 25.0),
              LoginButton(text: 'Login', onPressed: () => navigateToHomePage(context)),
              RawMaterialButton(
                padding: EdgeInsets.symmetric(horizontal: 60.0),
                fillColor: Colors.lightBlue[800],
                elevation: 2.0,
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Sign In with Google',
                    maxLines: 1,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                ),
                shape: StadiumBorder(),
                onPressed: () => null,
              ),
              SizedBox(height: 60.0),
              Text(
                'New to Tüter?',
                style: TextStyle(
                  fontSize: 17.0,
                ),
              ),
              LoginButton(text: 'Sign Up', padding: 110.0, onPressed: () => navigateToSignupPage(context)),
            ],
          ),
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}

