import 'package:Tuter/backend/auth.dart';
import 'package:flutter/material.dart';
import 'package:Tuter/appointment.dart';


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

  final Auth _auth = Auth();

  final _pageOptions = [
    Text('Appointment Page'),
    Text('Profile Page'),
  ];


  Widget appointmentList() {
    return ListView(
      children: _appointmentList
    );
  }

  final _appointmentList = [
    Appointment(className: 'COP3402', time: '13:00', date: 'Wednesday', tutor: 'Jeff',),
    Appointment(className: 'COP4210', time: '14:00', date: 'Thursday', tutor: 'Tim'),
  ];


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
      body: Center(child: appointmentList()),
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
