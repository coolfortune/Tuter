import 'package:Tuter/auth.dart';
import 'package:flutter/material.dart';
import 'package:Tuter/appointment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePage createState() => new _HomePage();
}

class _HomePage extends State<HomePage> with SingleTickerProviderStateMixin {
  // Controller for the search text
  final TextEditingController _filter = TextEditingController();

  String _searchText;
  int _selectedIndex = 0;
  bool _searching = false;

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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final _appointmentList = [
    {
      "className": 'COP3402',
      "time": '13:00',
      "date": 'Wednesday',
      "tutorName": 'Jeff Fortune'
    },
    {
      "className": 'COP3402',
      "time": '13:00',
      "date": 'Wednesday',
      "tutorName": 'Timothy Jinkys'
    },
    {
      "className": 'COP3402',
      "time": '13:00',
      "date": 'Wednesday',
      "tutorName": 'Timothy Jinkys'
    },
    {
      "className": 'COP3402',
      "time": '13:00',
      "date": 'Wednesday',
      "tutorName": 'Timothy Jinkys'
    },
    {
      "className": 'COP3402',
      "time": '13:00',
      "date": 'Wednesday',
      "tutorName": 'Timothy Jinkys'
    },
    {
      "className": 'COP3402',
      "time": '13:00',
      "date": 'Wednesday',
      "tutorName": 'Timothy Jinkys'
    },
    {
      "className": 'COP3402',
      "time": '13:00',
      "date": 'Wednesday',
      "tutorName": 'Timothy Jinkys'
    },
    {
      "className": 'COP3402',
      "time": '13:00',
      "date": 'Wednesday',
      "tutorName": 'Timothy Jinkys'
    },
  ];

  final Auth _auth = Auth();

  final _pageOptions = [
    Text('Appointment Page'),
    Text('Profile Page'),
  ];

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
          else if (!snapshot.hasData)
            return LinearProgressIndicator(
              backgroundColor: Theme.of(context).primaryColor,
            );

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

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Appointment.fromSnapshot(data);

    return Padding(
      key: ValueKey(record.tutorName),
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
    setState(() => _searching = !_searching);
  }

  @override
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
      floatingActionButton: _inAppointmentsTab(),
    );
  }

  // Function which automatically shows or hides the floating button
  // based on the tab the user is on
  FloatingActionButton _inAppointmentsTab() {
    if (_selectedIndex == 0) {
      return FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          child: _searching ? Icon(Icons.close) : Icon(Icons.search),
          onPressed: _searchAppointment);
    } else {
      return null;
    }
  }
}
