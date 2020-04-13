import 'package:Tuter/backend/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'appointment.dart';
import 'backend/database.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({Key key}) : super(key: key);
  @override
  _AppointmentPage createState() => new _AppointmentPage();
}

class _AppointmentPage extends State<AppointmentPage> {
  Auth _auth = Auth();

  final List<String> weekday = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  String uid;
  FirebaseUser user;
  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.currentUser().then((user) {
      setState(() {
        uid = user.uid;
      });
    }).catchError((onError) => print(onError.toString()));
  }

  void _deleteAppointment(record) async {
    DatabaseService(uid: uid)
        .deleteAppointment(uid, record)
        .then((value) => print('Appointment deleted successfully'))
        .catchError((onError) => print(onError));

    Navigator.of(context).pop();
    Scaffold.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.grey[200],
        behavior: SnackBarBehavior.floating,
        content: Text(
          'Appointment deleted',
          style: TextStyle(
            color: Colors.black,
          ),
        )));
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance.document('Students/' + '$uid').snapshots(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasError)
            return Text(
              'Internal Error',
              style: TextStyle(
                color: Colors.red,
              ),
            );
          else if (!snapshot.hasData) return LinearProgressIndicator();

          final List<dynamic> refList =
              snapshot.data.data['appointments'] ?? [];

          return refList.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                        child: Text(
                      'No Saved Appointments',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15.0,
                      ),
                    )),
                  ],
                )
              : ListView(
                  padding: EdgeInsets.only(top: 20.0),
                  children: refList
                      .map((ref) => _buildList(context, ref.get().asStream()))
                      .toList());
        });
  }

  Widget _buildList(
      BuildContext context, Stream<DocumentSnapshot> snapshotStream) {
    return StreamBuilder<DocumentSnapshot>(
      stream: snapshotStream,
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasError)
          return Text(
            'Internal Error',
            style: TextStyle(
              color: Colors.red,
            ),
          );
        else if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildListItem(context, snapshot.data);
      },
    );
  }
  //  Widget _processRef(DocumentReference ref) {
  //    ref
  //        .snapshots()
  //        .then((snapshot) => Appointment.fromSnapshot(snapshot))
  //        .then((appointment) => _buildListItem(context, appointment))
  //        .catchError((onError) => print(onError));
  //  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot snapshot) {
    final record = Appointment.fromSnapshot(snapshot);

    final String startTime = record.startTime.toDate().toString().substring(10, 16);

    final String endTime = record.endTime.toDate().toString().substring(10, 16);

    final String weekdayName = weekday[record.startTime.toDate().weekday];

    return PopupMenuButton(
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          child: Text('Delete Appointment'),
        ),
        PopupMenuItem(
          value: 2,
          child: Text('See Contact Info'),
        ),
      ],
      offset: Offset(1.0, 0),
      onSelected: (value) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              if (value == 1) {
                return AlertDialog(
                  title: Text('Confirm Deletion?'),
                  actions: <Widget>[
                    FlatButton(
                        textColor: Colors.amber,
                        onPressed: () => _deleteAppointment(record),
                        child: Text('Yes')),
                    FlatButton(
                        textColor: Colors.amber,
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('No')),
                  ],
                );
              } else {
                return AlertDialog(
                  title: Text('Contact Information'),
                  //content: Text(
                  actions: <Widget>[
                    FlatButton(
                      textColor: Colors.amber,
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('Close'),
                    )
                  ],
                );
              }
            });
      },
      child: Padding(
        key: ValueKey(record.tutorName),
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(3.0, 3.0),
                blurRadius: 3.0,
              )
            ],
            color: Colors.green[400],
            border: Border.all(color: Colors.grey, style: BorderStyle.none),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: ListTile(
            title: Text(startTime + ' - ' + endTime),
            leading: Text(
              record.className,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: Text(record.tutorName),
            isThreeLine: true,
            subtitle: Text(weekdayName),
            onTap: null,
          ),
        ),
      ),
    );
  }

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
      body: _buildBody(context),
    );
  }
}
