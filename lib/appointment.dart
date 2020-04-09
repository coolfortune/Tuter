import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Tuter/users.dart';

class Appointment {
  final String className;
  final String time;
  final String date;
  final String tutorName;
  final DocumentReference reference;

  Appointment({this.className, this.time, this.date, this.tutorName, this.reference});

  Appointment.fromMap(Map<String, dynamic> map, {this.reference})
    :assert(map['className'] != null),
    assert(map['time'] != null),
    //assert(map['tuterName'] != null),
    className = map['className'],
    time = map['time'],
    date = map['date'],
    tutorName = map['tutorName'];
   


    Appointment.fromSnapshot(DocumentSnapshot snapshot)
      :this.fromMap(snapshot.data, reference: snapshot.reference);


  @override
 String toString() => "Appointment<$className:$time:$date:$tutorName>";

}