import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);
  @override
  _HomePage createState() => new _HomePage();
}

class _HomePage extends State<HomePage> {

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
    );
  }
}