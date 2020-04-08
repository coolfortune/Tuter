import 'package:Tuter/Models/student.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final String uid;
  DatabaseService({ this.uid });

  // collection reference
  final CollectionReference studentCollection = Firestore.instance.collection('Students');

  Future<void> updateUserData(String email, String firstName, String lastName, String major) async {
    return await studentCollection.document(uid).setData({
      'email': email,
      'firstName': firstName,
      'lastName' : lastName,
      'major': major,
    });
  }

  // student list from snapshot
  List<Student> _studentsFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc){
      //print(doc.data);
      return Student(
        firstName: doc.data['firstName'] ?? '',
        lastName: doc.data['lastName'] ?? '',
        email: doc.data['email'] ?? ''
      );
    }).toList();
  }

}