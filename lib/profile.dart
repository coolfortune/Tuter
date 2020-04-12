import 'package:Tuter/make-appointment.dart';
import 'package:flutter/material.dart';
import 'package:Tuter/backend/auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key key}) : super(key: key);
  @override
  _ProfilePage createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  final Auth _auth = Auth();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text('Log Out'),
            onPressed: _auth.logOut,
          )
        ],
      ),
      body: MakeAppointment(),
    );
  }
}
