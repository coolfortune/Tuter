import 'package:firebase_auth/firebase_auth.dart';
import 'package:Tuter/Models/user.dart';
import 'package:Tuter/backend/database.dart';


class Auth {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<FirebaseUser> get user {
    return _auth.onAuthStateChanged;
  }

  // create user obj based on firebase user
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  Future emailVerification(FirebaseUser user) async {
    try {
      await user.sendEmailVerification();
      return _userFromFirebaseUser(user);
    } catch (e) {
      return e;
    }
  } 

  // log in

  Future logIn(String email, String password) async {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      print('IN THE LOG IN');
      user.reload();
      result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      user = result.user;
  
      if (user.isEmailVerified) {
        print('USER IS VERIFIED');
        return user;
      }
      else {
        print('USER IS NOT VERIFIED');
        return logOut();
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

  Future registerStudent(String email, String password, String firstName, String lastName, String major) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      // create a new Student for the user with the uid
      await DatabaseService(uid: user.uid).updateStudentData(email, firstName, lastName, major);
      return emailVerification(user);
    } catch (error) {
      print(error.toString());
      return null;
    }

  }

  Future registerTutor(String email, String password, String firstName, String lastName, String major) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      // create a new Tutor for the user with the uid
      await DatabaseService(uid: user.uid).updateTutorData(email, firstName, lastName, major);
      return  emailVerification(user);
    } catch (error) {
      print(error.toString());
      return null;
    } 
  }

}
