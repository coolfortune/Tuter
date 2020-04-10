import 'package:Tuter/backend/auth.dart';
import 'package:flutter/material.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({Key key}) : super(key: key);
  @override
  _AppointmentPage createState() => new _AppointmentPage();
}

class _AppointmentPage extends State<AppointmentPage> {
  Auth _auth = Auth();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointments'),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text('Log Out'),
            onPressed: () async {
              await _auth.logOut();
            },
          )
        ],
      ),
    );
  }
}