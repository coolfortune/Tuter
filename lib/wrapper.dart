<<<<<<< HEAD
import 'package:Tuter/backend/database.dart';
import 'package:Tuter/home.dart';
=======
>>>>>>> 87e02feeddac1bb9b2a88ca02c7b6d925d7610a5
import 'package:Tuter/logIn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Tuter/home.dart';


class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<FirebaseUser>(context);
    final db = DatabaseService();

    
    // decide to either go to log in or home page
    if (user == null)
    {
      return LogIn();
    }
    
    else 
<<<<<<< HEAD
    {
      bool tutorHomepage = false;

      db.getUserType(user.uid).then((isTutor){
        if (isTutor)
        {
          print('Tutor');
          tutorHomepage = true;
        }
        else 
        {
          print('Student');
          tutorHomepage = false;
        }
        
      });
      print(tutorHomepage);
      print('uooo');
      // TODO: return tutorHomepage ? TutorHomePage() : StudentHomePage();
      return (tutorHomepage) ? HomePage() : LogIn();
    }
=======
    return NavBar();
>>>>>>> 87e02feeddac1bb9b2a88ca02c7b6d925d7610a5
  }
 
}