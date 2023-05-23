import 'package:flutter/material.dart';

void main() {
  runApp(MusicLearningApp());
}

class MusicLearningApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Learning App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Music Learning App'),
      ),
      body: Center(
        child: Text(
          'Welcome to the Music Learning App!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
