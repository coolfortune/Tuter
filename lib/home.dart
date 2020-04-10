import 'package:Tuter/profile.dart';
import 'package:flutter/material.dart';
import 'package:Tuter/appointment-page.dart';
import 'package:Tuter/home-page.dart';

class NavBar extends StatefulWidget {
  @override
  _NavBar createState() => new _NavBar();
}

class _NavBar extends State<NavBar> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _children = [
    HomePage(
      key: PageStorageKey('Home Page'),
    ),
    AppointmentPage(
      key: PageStorageKey('Appointment Page'),
    ),
    ProfilePage(
      key: PageStorageKey('Profile Page'),
    ),
  ];

  final PageStorageBucket bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        child: _children[_selectedIndex],
        bucket: bucket,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
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
