import 'package:Tuter/auth.dart';
import 'package:Tuter/wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());


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

      Animatable<Offset> tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

enum Direction { left, right }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // takes in stream from auth.dart to give to wrapper
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