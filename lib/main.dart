import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.black,
        statusBarColor: Colors.black,
        systemNavigationBarDividerColor: Colors.black,
        systemStatusBarContrastEnforced: true),
  );
  runApp(LearningMusicApp());
}

class LearningMusicApp extends StatefulWidget {
  @override
  _LearningMusicAppState createState() => _LearningMusicAppState();
}

class _LearningMusicAppState extends State<LearningMusicApp> {
  int _selectedIndex = 0;
  late VideoBloc _videoBloc;

  @override
  void initState() {
    super.initState();
    _videoBloc = VideoBloc();
  }

  @override
  void dispose() {
    _videoBloc.dispose();
    super.dispose();
  }

  final List<Widget> _pages = [
    Login(),
    MenuPage(videoBloc: VideoBloc()),
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
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        textTheme: TextTheme(
          bodyText1: TextStyle(color: Colors.white),
          bodyText2: TextStyle(color: Colors.white),
        ),
      ),
      home: _pages[_selectedIndex],
      routes: {
        '/menu': (context) => MenuPage(videoBloc: _videoBloc),
        '/login': (context) => Login(),
        '/register': (context) => Register(),
        '/map': (context) => MapScreen(),
        '/video': (context) => VideoUploadPage(),
        '/videoList': (context) => VideoListPage(videoBloc: _videoBloc),
        '/QRCodeScanner': (context) => QRCodeScannerPage(),
        '/metronome': (context) => MetronomeScreen(),
        '/lyrics': (context) => LyricsPage(),
      },
    );
  }
}

class MenuPage extends StatefulWidget {
  final VideoBloc videoBloc;

  MenuPage({required this.videoBloc});

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  int _selectedIndex = 0;

  late VideoBloc _videoBloc;

  @override
  void initState() {
    super.initState();
    _videoBloc = widget.videoBloc;
  }

  final List<Widget> _pages = [
    VideoListPage(videoBloc: VideoBloc()),
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
      body: Stack(
        children: [
          Container(
              margin: EdgeInsets.only(bottom: 50),
              child: _pages[_selectedIndex]),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Color(0xFF64FEDA), width: 0.5),
                ),
              ),
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.grey[900],
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                selectedFontSize: 0,
                unselectedFontSize: 0,
                iconSize: 24,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.book_rounded),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.map_rounded),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: FaIcon(FontAwesomeIcons.qrcode),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.video_camera_back),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.hourglass_bottom_rounded),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.queue_music),
                    label: '',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
