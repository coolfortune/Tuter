// import 'package:Tuter/Models/student.dart';
// import 'package:Tuter/Models/tutor.dart';
import 'package:Tuter/appointment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  // collection reference
  final CollectionReference studentCollection =
      Firestore.instance.collection('Students');
  final CollectionReference tutorCollection =
      Firestore.instance.collection('Tutors');

  Future<void> updateStudentData(
      String email, String firstName, String lastName, String major) async {
    return await studentCollection.document(uid).setData({
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'major': major,
      'positiveRatings': 0,
      'totalRatings': 0,
    });
  }

  Future<void> addAppointment(String uid, Appointment record) async {
    final DocumentReference reference = record.reference;

    return await studentCollection.document(uid).updateData({
      'appointments': FieldValue.arrayUnion([reference])
    });
  }

  Future<void> deleteAppointment(String uid, Appointment record) async {
    final DocumentReference reference = record.reference;

    return await studentCollection.document(uid).updateData({
      'appointments': FieldValue.arrayRemove([reference])
    });
  }
  Future<void> updateTutorData(
      String email, String firstName, String lastName, String major) async {
    return await tutorCollection.document(uid).setData({
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'major': major,
      'positiveRatings': 0,
      'totalRatings': 0,
      'verified': false,
      'userType': true,
    });
  }

  Future<bool> getUserType(String uid) async {
    bool isTutor = false;

    try 
    {
    await Firestore.instance.
          collection('Tutors')
          .document(uid)
          .get()
          .then((DocumentSnapshot doc){
            if (doc.exists)
                isTutor = true;
    });

    return isTutor;
    }
    catch(e)
    {
      print(e.toString());
    }
  }

  


  Stream<QuerySnapshot> get students {
    return studentCollection.snapshots();
  }

  Stream<QuerySnapshot> get tutors {
    return tutorCollection.snapshots();
  }

  // // student list from snapshot
  // List<Student> _studentsFromSnapshot(QuerySnapshot snapshot) {
  //   return snapshot.documents.map((doc){
  //     //print(doc.data);
  //     return Student(
  //       firstName: doc.data['firstName'] ?? '',
  //       lastName: doc.data['lastName'] ?? '',
  //       email: doc.data['email'] ?? ''
  //     );
  //   }).toList();
  // }

}
