import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rxdart/rxdart.dart';
import 'package:video_player/video_player.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class Video {
  final String name;
  final String url;

  Video({required this.name, required this.url});
}

class VideoBloc {
  List<Video> _videos = [];
  final _videosSubject = BehaviorSubject<List<Video>>();
  Stream<List<Video>> get videosStream => _videosSubject.stream;
  bool _isDisposed = false;

  void fetchVideos() async {
    if (_isDisposed) return;

    ListResult result = await FirebaseStorage.instance.ref().listAll();
    List<Video> fetchedVideos = [];

    for (Reference ref in result.items) {
      String videoUrl = await ref.getDownloadURL();
      String videoName = ref.name;

      fetchedVideos.add(Video(name: videoName, url: videoUrl));
    }

    _videos = fetchedVideos;
    _videosSubject.add(_videos);

    if (_videos.isEmpty) {
      _videosSubject.close();
    }
  }

  void dispose() {
    _isDisposed = true;
    _videosSubject.close();
  }
}

class VideoListPage extends StatefulWidget {
  VideoBloc videoBloc;

  VideoListPage({required this.videoBloc});

  @override
  _VideoListPageState createState() => _VideoListPageState();
}

class _VideoListPageState extends State<VideoListPage> {
  @override
  void initState() {
    super.initState();
    reloadPage();
  }

  @override
  void dispose() {
    widget.videoBloc.dispose();
    super.dispose();
  }

  void reloadPage() {
    setState(() {
      widget.videoBloc.dispose();
      widget.videoBloc = VideoBloc();
      widget.videoBloc.fetchVideos();
    });
  }

  void reloadVideos() {
    reloadPage();
  }

  Future<void> _generateQRCode(String videoUrl) async {
    String qrCodeData = videoUrl;
    String qrCodeUrl =
        'https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=$qrCodeData';

    if (await canLaunch(qrCodeUrl)) {
      await launch(qrCodeUrl);
    } else {
      print('Could not launch QR code URL');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              height: 56.0,
              width: double.infinity,
              color: Colors.grey[900],
              child: Text(
                'Lessons',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF64FEDA),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<List<Video>>(
                stream: widget.videoBloc.videosStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (snapshot.hasData) {
                    List<Video> videos = snapshot.data!;

                    return Container(
                      padding: EdgeInsets.all(8.0),
                      child: ListView.builder(
                        itemCount: videos.length,
                        itemBuilder: (context, index) {
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32.0),
                            ),
                            elevation: 4.0,
                            margin: EdgeInsets.symmetric(vertical: 2.0),
                            child: ListTile(
                              tileColor: Colors.grey[900],
                              leading: Icon(
                                Icons.video_collection,
                                color: Color(0xFF64FEDA),
                              ),
                              title: Text(
                                videos[index].name,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => VideoPlayerPage(
                                      videoUrl: videos[index].url,
                                    ),
                                  ),
                                );
                              },
                              trailing: IconButton(
                                icon: FaIcon(
                                  FontAwesomeIcons.qrcode,
                                  color: Color(0xFF64FEDA),
                                ),
                                onPressed: () {
                                  String videoUrl = videos[index].url;
                                  _generateQRCode(videoUrl);
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return Center(
                      child: Text('No videos available.'),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: reloadPage,
        child: Icon(Icons.refresh),
      ),
    );
  }
}

class VideoPlayerPage extends StatefulWidget {
  final String videoUrl;

  VideoPlayerPage({required this.videoUrl});

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.value.isInitialized) {
      return Scaffold(
        body: AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        ),
      );
    } else {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final VideoBloc videoBloc = VideoBloc();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Player Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: VideoListPage(
        videoBloc: videoBloc,
      ),
    );
  }
}
