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
      home: Register(),
       routes: {
        '/menu': (context) => MenuPage(),
        '/login': (context) => Login(),
        '/register': (context) => Register(),
        '/map': (context) => MapScreen(),
        '/video': (context) => VideoUploadPage(),
        '/videoList': (context) => VideoListPage(),
        '/QRCodeScanner': (context) => QRCodeScannerPage(),
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
        child: ButtonBar(
          alignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/videoList');
              },
              icon: Icon(Icons.book),
              label: Text('Lessons'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/map');
              },
              icon: Icon(Icons.map_rounded),
              label: Text('Map'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/QRCodeScanner');
              },
              icon: Icon(Icons.music_note),
              label: Text('Scan Lesson'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/video');
              },
              icon: Icon(Icons.video_camera_back),
              label: Text('Upload Video'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                // Handle "Settings" section tap
              },
              icon: Icon(Icons.settings),
              label: Text('Settings'),
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
