// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:Tuter/logIn.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  test('Login: Empty String Validation', () {
    String resEmail = Validators.validateEmail('');
    String resPsswd = Validators.password('');
    expect(resEmail, 'Please enter a valid email address');
    expect(resPsswd, 'Please provide a password');

  });
  test('Login: Valid String Validation', () {
    String resEmail = Validators.validateEmail('test@gmail.com');
    String resPsswd = Validators.password('test123');
    expect(resEmail, null);
    expect(resPsswd, null);
  });
  test('Forgot Password: Empty String Validation', () {
    String res = Validators.validateEmail('');
    expect(res, 'Please enter a valid email address');
  });
  test('Forgot Password: Invalid Email Validation', () {
    String res = Validators.validateEmail('email@gmail.com.a');
    expect(res, 'Please enter a valid email address');
  });
  test('Forgot Password: Valid Email Validation', () {
    String res = Validators.validateEmail('email@gmail.com.au');
    expect(res, null);
  });
  test('Sign Up: Invalid First Name Validation', () {
    String res = Validators.generic('', 'Please enter your first name');
    expect(res, 'Please enter your first name');
  });
  test('Sign Up: Invalid Last Name Validation', () {
    String res = Validators.generic('', 'Please enter your last name');
    expect(res, 'Please enter your last name');
  });
  test('Sign Up: Invalid Major Validation', () {
    String res = Validators.generic('', 'Please enter your major');
    expect(res, 'Please enter your major');
  });
  test('Sign Up: Valid First Name Validation', () {
    String res = Validators.generic('Rick', 'Please enter your first name');
    expect(res, null);
  });
  test('Sign Up: Valid Last Name Validation', () {
    String res = Validators.generic('Leinecker', 'Please enter your last name');
    expect(res, null);
  });
  test('Sign Up: Valid Major Validation', () {
    String res = Validators.generic('Computer Science', 'Please enter your major');
    expect(res, null);
  });
}
