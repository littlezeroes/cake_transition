import 'package:flutter/material.dart';

class PinkButtonPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pink Button Page'),
      ),
      body: Center(
        child: Text('You have arrived! Swipe right to go back.'),
      ),
    );
  }
}
