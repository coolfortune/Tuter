import 'package:Tuter/backend/database.dart';
import 'package:Tuter/logIn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Tuter/home.dart';

enum userType{student, tutor}

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {

  bool isTutor;
  FirebaseUser user;
  
  final db = DatabaseService();

  Widget build(BuildContext context) {
    setState(() {
      user =  Provider.of<FirebaseUser>(context);
      if (user != null)
          db.getUserType(user.uid).then((res){
            setState(() {
              isTutor = res;
             });
           });
    });

    // decide to either go to log in or home page
    if (user == null)
      return LogIn();

    else if(isTutor)
      return NavBar(isTutor: true);

    else return NavBar(isTutor: false);
  }
}