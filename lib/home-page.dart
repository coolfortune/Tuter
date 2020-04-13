import 'package:Tuter/backend/database.dart';
import 'package:Tuter/qrCodeGenerator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Tuter/appointment.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Tuter/backend/auth.dart';
<<<<<<< HEAD
import 'package:barcode_scan/barcode_scan.dart';
import 'package:Tuter/Models/user.dart';
import 'package:flutter/services.dart';
=======
>>>>>>> 57485ae19a5713e4f7174ed3170a10249b23618a

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePage createState() => new _HomePage();
}

class _HomePage extends State<HomePage> {
  String _searchText;
  final TextEditingController _filter = TextEditingController();
  bool _searching = false;
  final Auth _auth = Auth();
  String _scanResult;

  final List<String> weekday = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  @override
  void initState() {
    super.initState();

    // Listener for search text
    _filter.addListener(_searchListener);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _searchListener listener.
    _filter.dispose();
    super.dispose();
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('Appointments').orderBy('startTime').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError)
            return Text(
              'Internal Error',
              style: TextStyle(
                color: Colors.red,
              ),
            );
          else if (!snapshot.hasData) return LinearProgressIndicator();

          return _buildList(context, snapshot.data.documents);
        });
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
        padding: EdgeInsets.only(top: 20.0),
        // Filters based on your search query; returns everything if empty
        children: snapshot
            .where(_filterList)
            .map((data) => _buildListItem(context, data))
            .toList());
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot snapshot) {
    final record = Appointment.fromSnapshot(snapshot);

    final int startHour = record.startTime.toDate().hour;
    final int startMinute = record.startTime.toDate().minute;
    final String startTime =
        (startHour > 9 ? startHour.toString() : '0' + startHour.toString()) +
            ':' +
            (startMinute > 9
                ? startMinute.toString()
                : '0' + startMinute.toString());

    final int endHour = record.endTime.toDate().hour;
    final int endMinute = record.endTime.toDate().minute;
    final String endTime =
        (endHour > 9 ? endHour.toString() : '0' + endHour.toString()) +
            ':' +
            (endMinute > 9 ? endMinute.toString() : '0' + endMinute.toString());

    final String weekdayName = weekday[record.startTime.toDate().weekday];

    return PopupMenuButton(
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          child: Text('Add Appointment'),
        ),
      ],
      offset: Offset(1.0, 0),
      onSelected: (value) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Confirm Appointment?'),
                content: Text(
                    '${record.className} with ${record.tutorName} on\n$weekdayName at $startTime - $endTime?'),
                actions: <Widget>[
                  FlatButton(
                      textColor: Colors.amber,
                      onPressed: () => _addAppointment(record),
                      child: Text('Yes')),
                  FlatButton(
                      textColor: Colors.amber,
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('No')),
                ],
              );
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
            gradient: LinearGradient(colors: [Colors.white, Colors.grey[300]]),
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

  void _addAppointment(record) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String uid = user.uid;

    DatabaseService(uid: uid)
        .addAppointment(uid, record)
        .then((value) => print('Appointment added successfully'))
        .catchError((onError) => print(onError));

    Navigator.of(context).pop();
    Scaffold.of(context).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.grey[200],
        content: Text(
          'Appointment added successfully!',
          style: TextStyle(
            color: Colors.black,
          ),
        )));
  }


  // Filtering function for the list builder
  bool _filterList(snapshot) {
    if (_searchText == "" || _searchText == null) {
      return true;
    } else {
      return snapshot.data['className']
          .toLowerCase()
          .contains(_searchText.toLowerCase());
    }
  }

  // Search Bar widget
  TextField _searchBar() {
    return TextField(
      autofocus: true,
      controller: _filter,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search),
        hintText: 'Search...',
      ),
    );
  }

  // Search Listener
  void _searchListener() {
    if (_filter.text.isEmpty) {
      setState(() {
        _searchText = "";
      });
    } else {
      setState(() {
        _searchText = _filter.text;
      });
    }
    print(_searchText);
  }

  // Sets the state of the search icon, by flipping the _searching boolean
  void _searchAppointment() {
    if (_searching) {
      setState(() => _searchText = "");
    }
    setState(() => _searching = !_searching);
  }


  // Function which automatically shows or hides the floating button
  // based on the tab the user is on

  // scans QR code
  Future scan() async{

    try{
      String scanResult = await BarcodeScanner.scan();
      setState(() {
        _scanResult = scanResult;
      });
    } on PlatformException catch(e)
    {
      if (e.code == BarcodeScanner.CameraAccessDenied)
        print('User denied camera acces');
    else print('Unknown Error');
    }
    on FormatException{
      print('User backed out of camera');
    }
  }

  void selected(int selection){

      if(selection == 1)
      {
        scan();
        // go to review page
      }
     else if (selection == 2)
      {
        Navigator.push( context, MaterialPageRoute(builder: (context) => GenerateScreen(uid: 'appointment id')));
      }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _searching ? _searchBar() : Text('Home'),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text('Log Out'),
            onPressed: () async {
              await _auth.logOut();
            },
          ),
          PopupMenuButton<int>(
            icon: Icon(Icons.filter_center_focus),
            onSelected: selected,
            itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
              const PopupMenuItem<int>(
                value: 1,
                child: Text('Scan QR Code')
              ),
              const PopupMenuItem<int>(
                value: 2,
                child: Text('Create QR Code')
                )
            ]
          )
        ],
      ),
      body: _buildBody(context),
      floatingActionButton: FloatingActionButton(
        clipBehavior: Clip.antiAlias,
        backgroundColor: Theme.of(context).primaryColor,
        child: _searching ? Icon(Icons.close) : Icon(Icons.search),
        onPressed: _searchAppointment,
      ),
    );
  }
}
