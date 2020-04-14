import 'dart:io';
import 'package:Tuter/loading.dart';
import 'package:path/path.dart' as Path;
import 'package:Tuter/make-appointment.dart';
import 'package:flutter/material.dart';
import 'package:Tuter/backend/auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'Models/student.dart';
import 'Models/tutor.dart';

class ProfilePage extends StatefulWidget {
  final bool isTutor;
  const ProfilePage({Key key, this.isTutor}) : super(key: key);

  @override
  _ProfilePage createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  final Auth _auth = Auth();
  File _image = null;
  String _uploadedFileURL;
  Student student;
  Tutor tutor;
  bool loading;

  Future getStudent() async {
    setState(() => loading = true);
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    DocumentSnapshot doc = await Firestore.instance
        .collection('Students')
        .document(user.uid)
        .get();

    setState(() {
      student = new Student.fromProfile(
          doc.data['email'],
          doc.data['firstName'],
          doc.data['lastName'],
          doc.data['major'],
          doc.data['positiveRatings'],
          doc.data['totalRatings']);
      loading = false;
    });
  }

  Future getTutor() async {
    setState(() => loading = true);
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    DocumentSnapshot doc =
        await Firestore.instance.collection('Tutors').document(user.uid).get();

    setState(() {
      tutor = new Tutor.fromProfile(
          doc.data['email'],
          doc.data['firstName'],
          doc.data['lastName'],
          doc.data['major'],
          doc.data['positiveRatings'],
          doc.data['totalRatings'],
          doc.data['verified']);
      loading = false;
    });
  }

  Widget profileAvatar(BuildContext context) {
    bool isTutor = widget.isTutor;

    double percent = isTutor
        ? tutor.positiveRatings / tutor.totalRatings
        : student.positiveRatings / student.totalRatings;

    isTutor
        ? print('tutor ' + tutor.lastName)
        : print('student $student.firstName');
    String initials = isTutor
        ? tutor.firstName[0] + tutor.lastName[0]
        : student.firstName[0] + student.lastName[0];
    return CircleAvatar(
        radius: 80,
        backgroundColor: Color.lerp(Colors.red, Colors.green, percent),
        child: Text(
          initials,
          style: new TextStyle(
            fontSize: 80,
            color: Colors.black,
          ),
        ));
  }

  Widget profileName(BuildContext context) {
    bool isTutor = widget.isTutor;
    String firstName = isTutor ? tutor.firstName : student.firstName;
    String lastName = isTutor ? tutor.lastName : student.lastName;
    return !isTutor
        ? Text(
            '$firstName $lastName',
            style: new TextStyle(
              fontSize: 40,
              color: Colors.black,
            ),
          )
        : RichText(
            text: TextSpan(
            style: new TextStyle(
              fontSize: 40,
              color: Colors.black,
            ),
            children: [
              TextSpan(text: ('$firstName $lastName')),
              widget.isTutor && tutor.verified
                  ? WidgetSpan(
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.blue,
                      ),
                    )
                  : WidgetSpan(child: SizedBox.shrink()),
            ],
          ));
  }

  Widget majorProfile(context) {
    String major = widget.isTutor ? tutor.major : student.major;
    return Text(
      major,
      style: new TextStyle(fontSize: 20),
    );
  }

  Future chooseFile() async {
    try {
      await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
        setState(() {
          _image = image;
        });
      });
    } catch (e) {
      print('Error in image picker');
    }
  }

  Future uploadImage() async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('Transcripts/${Path.basename(_image.path)}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;

    print('File Uploaded');

    storageReference.getDownloadURL().then((imageURL) {
      setState(() {
        _uploadedFileURL = imageURL;
      });
    });

    Navigator.of(context).pop();
    Scaffold.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.grey[200],
        behavior: SnackBarBehavior.floating,
        content: Text(
          'Transcript uploaded successfully!',
          style: TextStyle(
            color: Colors.black,
          ),
        )));
  }

  void selected(String selection) {
    print('congrats no selecting');
    if (selection == 'Upload Transcripts') chooseFile();

    if (selection == 'Clear') {
      setState(() {
        _image = null;
      });
    }
  }

  void _confirmSignout() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Are you sure you want to log out?'),
            actions: <Widget>[
              FlatButton(
                  textColor: Colors.amber,
                  onPressed: () {
                    Navigator.of(context).pop();
                    _auth.logOut();
                  },
                  child: Text('Yes')),
              FlatButton(
                  textColor: Colors.amber,
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('No')),
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    loading = false;
    widget.isTutor ? getTutor() : getStudent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(() {
          if (widget.isTutor)
            return 'Profile: Tutor';
          else
            return 'Profile: Student';
        }()),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text('Log Out'),
            onPressed: _confirmSignout,
          ),
          PopupMenuButton<String>(
              onSelected: selected,
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'Upload Transcripts',
                      child: Text("Upload Transcripts"),
                    ),
                    const PopupMenuItem<String>(
                      child: Text("Edit Profile"),
                    ),
                    const PopupMenuItem<String>(
                      child: Text("Make a Report"),
                    ),
                    _image == null ? null : PopupMenuDivider(height: 15),
                    _image == null
                        ? null
                        : const PopupMenuItem<String>(
                            value: 'Clear',
                            child: Text('Clear'),
                          )
                  ]),
        ],
      ),
      body: loading
          ? LinearProgressIndicator()
          : Center(
              child: SingleChildScrollView(
                  child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                profileAvatar(context),
                profileName(context),
                majorProfile(context),
              ],
            ))),
      floatingActionButton: uploadDialog(),
    );
  }

  uploadDialog() {
    if (_image != null) {
      return FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: confirmUpload,
        child: Icon(Icons.file_upload),
      );
    } else {
      return null;
    }
  }

  void confirmUpload() {
    assert(_image != null);

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirm Upload'),
            content: Image.file(_image),
            actions: <Widget>[
              FlatButton(
                  textColor: Colors.amber,
                  onPressed: uploadImage,
                  child: Text('Yes')),
              FlatButton(
                  textColor: Colors.amber,
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('No')),
            ],
          );
        });
  }
}
