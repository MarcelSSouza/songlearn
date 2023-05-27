import 'package:flutter/material.dart';
import 'package:songlearn/Pages/LoginForm.dart';
import 'package:songlearn/Pages/Register.dart';
import 'package:songlearn/Pages/map.dart';
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:sqflite/sqflite.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      home: MapScreen(),
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
