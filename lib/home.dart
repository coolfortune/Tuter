import 'package:Tuter/auth.dart';
import 'package:flutter/material.dart';
import 'package:Tuter/appointment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';




class HomePage extends StatefulWidget {
  @override
  _HomePage createState() => new _HomePage();
}

class _HomePage extends State<HomePage> with SingleTickerProviderStateMixin {

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final _appointmentList = [
    {"className": 'COP3402', "time": '13:00', "date": 'Wednesday', "tutorName": 'Jeff Fortune'},
    {"className": 'COP3402', "time": '13:00', "date": 'Wednesday', "tutorName": 'Timothy Jinkys'},
    {"className": 'COP3402', "time": '13:00', "date": 'Wednesday', "tutorName": 'Timothy Jinkys'},
    {"className": 'COP3402', "time": '13:00', "date": 'Wednesday', "tutorName": 'Timothy Jinkys'},
    {"className": 'COP3402', "time": '13:00', "date": 'Wednesday', "tutorName": 'Timothy Jinkys'},
    {"className": 'COP3402', "time": '13:00', "date": 'Wednesday', "tutorName": 'Timothy Jinkys'},
    {"className": 'COP3402', "time": '13:00', "date": 'Wednesday', "tutorName": 'Timothy Jinkys'},
    {"className": 'COP3402', "time": '13:00', "date": 'Wednesday', "tutorName": 'Timothy Jinkys'},
  ];

  final Auth _auth = Auth();

  final _pageOptions = [
    Text('Appointment Page'),
    Text('Profile Page'),
  ];

  Widget _buildBody(BuildContext context) {
    // TODO: get actual snapshot from Cloud Firestore
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('Appointments').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildList(context, snapshot.data.documents);
      }
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList()
    );
  }


  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Appointment.fromSnapshot(data);

    return Padding(
      key: ValueKey(record.tutorName),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          title: Text(record.time),
          leading: Text(record.className),
          trailing: Text(record.tutorName),
          isThreeLine: true,
          subtitle: Text(record.date),
          onTap: () => print(record),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
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
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            title: Text('Appointments'),
            
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('Profile'),
          )
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Color(0xFF000000),
      ),

    );
      
  }
}

