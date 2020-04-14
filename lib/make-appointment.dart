import 'package:Tuter/appointment.dart';
import 'package:Tuter/backend/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MakeAppointment extends StatefulWidget {
  MakeAppointment({Key key}) : super(key: key);

  @override
  _MakeAppointmentState createState() => _MakeAppointmentState();
}

class _MakeAppointmentState extends State<MakeAppointment> {
  final List<String> classCodes = [
    'COP3405',
    'COP4210',
    'COP3100',
    'COP3502',
    'COP3503'
  ];

  final List<String> weekday = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  int _selectedIndex = 0;

  DateTime date = DateTime(2020, DateTime.now().month, DateTime.now().day + 1);
  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime = TimeOfDay.now();

  FirebaseUser user;
  String uid;

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.currentUser().then((user) {
      setState(() {
        this.user = user;
        uid = user.uid;
      });
    }).catchError((onError) => print(onError.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '   Class Code',
                  style: TextStyle(
                    color: Colors.grey[800],
                  ),
                ),
                RaisedButton(
                  padding: EdgeInsets.all(15.0),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  elevation: 3.0,
                  child: Container(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(classCodes[_selectedIndex]),
                      Text(
                        'Choose',
                        style: TextStyle(
                          color: Colors.amber,
                        ),
                      ),
                    ],
                  )),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 10.0),
                            title: Text('Class Codes'),
                            content: ListView(
                              children: classCodes
                                  .map((code) => ListTile(
                                        leading:
                                            (code == classCodes[_selectedIndex])
                                                ? Icon(Icons.check,
                                                  color: Colors.amber,
                                                )
                                                : SizedBox(),
                                        title: Text(code),
                                        onTap: () {
                                          _selectClass(
                                              classCodes.indexOf(code));
                                          Navigator.of(context).pop();
                                        },
                                      ))
                                  .toList(),
                            ),
                          );
                        });
                  },
                ),
                SizedBox(height: 20.0),
                Text(
                  '   Start Date',
                  style: TextStyle(
                    color: Colors.grey[800],
                  ),
                ),
                RaisedButton(
                  padding: EdgeInsets.all(15.0),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  elevation: 3.0,
                  child: Container(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(date.toString().split(r" ")[0]),
                      Text(
                        'Change',
                        style: TextStyle(
                          color: Colors.amber,
                        ),
                      ),
                    ],
                  )),
                  onPressed: buildShowDatePicker,
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '   Start Time',
                  style: TextStyle(
                    color: Colors.grey[800],
                  ),
                ),
                RaisedButton(
                    padding: EdgeInsets.all(15.0),
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    elevation: 3.0,
                    child: Container(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(startTime.toString().substring(10, 15)),
                        Text(
                          'Change',
                          style: TextStyle(
                            color: Colors.amber,
                          ),
                        ),
                      ],
                    )),
                    onPressed: () async {
                      TimeOfDay time = await buildShowTimePicker(startTime);
                      if (time != null)
                        setState(() {
                          startTime = time;
                        });
                    }),
              ],
            ),
            SizedBox(height: 10.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '   End Time',
                  style: TextStyle(
                    color: Colors.grey[800],
                  ),
                ),
                RaisedButton(
                    padding: EdgeInsets.all(15.0),
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    elevation: 3.0,
                    child: Container(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(endTime.toString().substring(10, 15)),
                        Text(
                          'Change',
                          style: TextStyle(
                            color: Colors.amber,
                          ),
                        ),
                      ],
                    )),
                    onPressed: () async {
                      TimeOfDay time = await buildShowTimePicker(endTime);
                      if (time != null)
                        setState(() {
                          endTime = time;
                        });
                    }),
              ],
            ),
            SizedBox(height: 50.0),
            Container(
                child: RaisedButton(
              elevation: 5.0,
              highlightElevation: 1.0,
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              color: Colors.amberAccent,
              child: Text(
                'Make Appointment',
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: _makeAppointmentPopup,
            ))
          ],
        ),
      ),
    );
  }

  void _makeAppointmentPopup() {
    final String dateString =
        date.toString().replaceAll(r"-", r"/").split(r" ")[0].substring(5);
    final String startTimeString = startTime.toString().substring(10, 15);
    final String endTimeString = endTime.toString().substring(10, 15);
    final String weekdayStr = weekday[date.weekday];

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Create Appointment?'),
            content: Text(
                'Create Appointment with ${user.email} on\n$weekdayStr, $dateString from $startTimeString to $endTimeString?'),
            actions: <Widget>[
              FlatButton(
                  textColor: Colors.amber,
                  onPressed: _makeAppointment,
                  child: Text('Yes')),
              FlatButton(
                  textColor: Colors.amber,
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('No')),
            ],
          );
        });
  }

  Future<void> buildShowDatePicker() async {
    DateTime _date = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: date,
      lastDate: DateTime(2030),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: Theme.of(context),
          child: child,
          isMaterialAppTheme: true,
        );
      },
    );

    if (_date != null) {
      setState(() {
        date = _date;
      });
    }
  }

  Future<TimeOfDay> buildShowTimePicker(time) async {
    return await showTimePicker(
      context: context,
      initialTime: time,
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: Theme.of(context),
          child: child,
          isMaterialAppTheme: true,
        );
      },
    );
  }

  _selectClass(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  _makeAppointment() async {
    String tutorName = await Firestore.instance.collection('Tutors').document(uid).get().then((snap) => snap.exists ? (snap.data['tutorName'] ?? "") : "");
    DateTime dateStart =
        date.add(Duration(hours: startTime.hour, minutes: startTime.minute));
    DateTime dateEnd =
        date.add(Duration(hours: endTime.hour, minutes: endTime.minute));
    String timeStr = dateStart.toString().substring(10, 16) + ' - ' + dateEnd.toString().substring(10, 16);
    String weekdayStr = weekday[date.weekday];

    Appointment record = Appointment(
      className: classCodes[_selectedIndex],
      startTime: Timestamp.fromDate(dateStart),
      endTime: Timestamp.fromDate(dateEnd),
      time: timeStr,
      date: weekdayStr,
      tutorName: tutorName,
    );

    DatabaseService(uid: uid)
        .makeAppointment(uid, record)
        .then((value) => print('Appointment created successfully'))
        .catchError((onError) => print(onError));

    
    Navigator.of(context).pop();
    Scaffold.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.grey[200],
        behavior: SnackBarBehavior.floating,
        content: Text(
          'Appointment created successfully!',
          style: TextStyle(
            color: Colors.black,
          ),
        )));
  }
}
