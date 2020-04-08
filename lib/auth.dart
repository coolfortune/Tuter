import 'package:firebase_auth/firebase_auth.dart';


class Auth {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream that the provider uses in wrapper to change pages 
  Stream<FirebaseUser> get user {
    return _auth.onAuthStateChanged;
  }

  // log in
  Future logIn(String email, String password) async{
    try{
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return result.user;
    }
    catch(e){
      print(e.toString());
      return null;
    }

  }

  // log out
  Future logOut() async{
    try{
      return await _auth.signOut();
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }

  // sign up



}