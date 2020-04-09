import 'package:Tuter/backend/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Tuter/appointment.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Tuter/backend/auth.dart';
import 'package:Tuter/Models/user.dart';

class AppointmentPage extends StatefulWidget {
  @override
  _AppointmentPage createState() => new _AppointmentPage();
}

class _AppointmentPage extends State<AppointmentPage> {
  String _searchText;
  final TextEditingController _filter = TextEditingController();
  bool _searching = false;
  final Auth _auth = Auth();

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
        stream: Firestore.instance.collection('Appointments').snapshots(),
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

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Appointment.fromSnapshot(data);

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
                    '${record.className} with ${record.tutorName} on\n${record.date} at ${record.time}?'),
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
            gradient: LinearGradient(colors: [Colors.white, Colors.grey[300]]),
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: ListTile(
            title: Text(record.time),
            leading: Text(
              record.className,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: Text(record.tutorName),
            isThreeLine: true,
            subtitle: Text(record.date),
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

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _searching ? _searchBar() : Text('Appointments'),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: _searching ? Icon(Icons.close) : Icon(Icons.search),
        onPressed: _searchAppointment,
      ),
    );
  }
}
