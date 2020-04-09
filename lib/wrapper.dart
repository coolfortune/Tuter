import 'package:Tuter/logIn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Tuter/home.dart';


class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<FirebaseUser>(context);

    // decide to either go to log in or home page
    if (user == null)
      return LogIn();
    else 
    return NavBar();
  }
 
}