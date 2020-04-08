import 'package:flutter/material.dart';

class Appointment extends StatelessWidget {
  final String className;
  final String time;
  final String date;
  final String tutor;

  Appointment({this.className, this.time, this.date, this.tutor});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(15.0),
          child: Text('$className: $date, $time ($tutor)',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Divider(),
      ],
    );
  }
}