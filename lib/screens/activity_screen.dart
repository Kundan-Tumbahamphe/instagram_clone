import 'package:flutter/material.dart';

class ActivityScreen extends StatefulWidget {
  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Instagram',
          style: const TextStyle(
            color: Colors.black,
            fontFamily: 'Billabong',
            fontSize: 30.0,
          ),
        ),
      ),
      body: Center(
        child: Text('Activity screen'),
      ),
    );
  }
}
