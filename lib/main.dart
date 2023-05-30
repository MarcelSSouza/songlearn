import 'package:flutter/material.dart';
import 'package:songlearn/Pages/Register.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Pages/Login.dart';
import 'Pages/Map.dart';
import 'Pages/QRCodeScannerPage.dart';
import 'Pages/VideoListPage.dart';
import 'Pages/VideoUploadPage.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(LearningMusicApp());
}


class LearningMusicApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Learning Music',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: QRCodeScannerPage(),
       routes: {
        '/menu': (context) => MenuPage(),
        '/login': (context) => Login(),
        '/register': (context) => Register(),
        '/map': (context) => MapScreen(),
        '/video': (context) => VideoUploadPage(),
        '/videoList': (context) => VideoListPage(),
        'QRCodeScanner': (context) => QRCodeScannerPage(),
      },
    );
  }
}

class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Learning Music'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MenuButton(
              title: 'Lessons',
              icon: Icons.book,
              onTap: () {
                // Handle "Lessons" section tap
              },
            ),
            MenuButton(
              title: 'Exercises',
              icon: Icons.fitness_center,
              onTap: () {
                // Handle "Exercises" section tap
              },
            ),
            MenuButton(
              title: 'Practice',
              icon: Icons.music_note,
              onTap: () {
                // Handle "Practice" section tap
              },
            ),
            MenuButton(
              title: 'Progress',
              icon: Icons.bar_chart,
              onTap: () {
                // Handle "Progress" section tap
              },
            ),
            MenuButton(
              title: 'Settings',
              icon: Icons.settings,
              onTap: () {
                // Handle "Settings" section tap
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MenuButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const MenuButton({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 200,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              color: Colors.white,
              size: 40,
            ),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
