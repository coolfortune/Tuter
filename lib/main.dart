import 'package:Tuter/auth.dart';
import 'package:Tuter/wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // receives stream from auth.dart to give to wrapper class
    return StreamProvider<FirebaseUser>.value(
      value: Auth().user,
      child: MaterialApp(
        title: 'Tüter',
        theme: ThemeData(
            primaryColor: Color(0xFFFFDD28)),
        home: Wrapper(),
      )
    );
  }
}