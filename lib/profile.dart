import 'dart:io';
import 'package:path/path.dart' as Path; 
import 'package:flutter/material.dart';
import 'package:Tuter/backend/auth.dart';
import 'package:firebase_storage/firebase_storage.dart';  
import 'package:image_picker/image_picker.dart';   



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

  Future chooseFile() async{
    try{
      await ImagePicker.pickImage(source: ImageSource.gallery).then((image){
          setState(() {
            _image = image;
          });
      });
    } catch(e)
    {
      print('Error in image picker');
    }

  }

  Future uploadImage() async{
    StorageReference storageReference = FirebaseStorage.instance.ref().child('Transcripts/${Path.basename(_image.path)}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;

    print('File Uploaded');

    storageReference.getDownloadURL().then((imageURL){
      setState(() {
        _uploadedFileURL = imageURL;
      });
    });
  }

  void selected(String selection){

      print('congrats no selecting');
      if (selection == 'Upload Transcripts')
        chooseFile();
      
      if (selection == 'Confirm Upload')
      {
        uploadImage();
        setState(() {
          _image = null;
        });
      }

  }

  @override  
  Widget build(BuildContext context) {
    //initState();
    return Scaffold(
      appBar: AppBar(
        title: Text((){
            if (widget.isTutor)
              return 'Profile: Tutor';
            else return 'Profile: Student';
        }()),
        actions: <Widget>[

          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text('Log Out'),
            onPressed: () async {
              await _auth.logOut();
            },
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
              
              _image == null ? null : 
                const PopupMenuItem<String>(
                  value: 'Confirm Upload',
                  child: Text('Confirm Upload'),
              
              )
            ]
          ),
        ],
      ),
      );
  }
}


