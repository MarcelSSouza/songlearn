import 'package:flutter/material.dart';
import 'package:songlearn/Pages/Register.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Pages/Login.dart';
import 'Pages/LyricsPage.dart';
import 'Pages/Map.dart';
import 'Pages/QRCodeScannerPage.dart';
import 'Pages/VideoListPage.dart';
import 'Pages/VideoUploadPage.dart';
import 'Pages/MetronomeApp.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(LearningMusicApp());
}

class LearningMusicApp extends StatefulWidget {
  @override
  _LearningMusicAppState createState() => _LearningMusicAppState();
}

class _LearningMusicAppState extends State<LearningMusicApp> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    Login(),
    MenuPage(),
    MapScreen(),
    VideoUploadPage(),
    MetronomeScreen(),
    LyricsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Songlearn',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _pages[_selectedIndex],
      routes: {
        '/menu': (context) => MenuPage(),
        '/login': (context) => Login(),
        '/register': (context) => Register(),
        '/map': (context) => MapScreen(),
        '/video': (context) => VideoUploadPage(),
        '/videoList': (context) => VideoListPage(),
        '/QRCodeScanner': (context) => QRCodeScannerPage(),
        '/metronome': (context) => MetronomeScreen(),
        '/lyrics': (context) => LyricsPage(),
      },
    );
  }
}

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    VideoListPage(),
    MapScreen(),
    QRCodeScannerPage(),
    VideoUploadPage(),
    MetronomeScreen(),
    LyricsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Songlearn'),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.grey[900],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Lessons',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_rounded),
            label: 'Map of Users',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.music_note),
            label: 'Scan Lesson',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_camera_back),
            label: 'Upload Video/lesson',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timelapse),
            label: 'Metronome',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sign_language),
            label: 'Lyrics',
          ),
        ],
      ),
    );
  }
}
