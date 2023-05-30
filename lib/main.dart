import 'package:flutter/material.dart';
import 'package:songlearn/Pages/Login.dart';
import 'package:songlearn/Pages/Register.dart';
import 'package:songlearn/Pages/Map.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:async';

import 'firebase_options.dart';
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
      title: 'SongLearn',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: Register(),
      routes: {
        '/login': (context) => Login(),
        '/register': (context) => Register(),
        '/map': (context) => MapScreen(),
      },
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
