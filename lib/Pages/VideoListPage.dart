import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rxdart/rxdart.dart';
import 'package:video_player/video_player.dart';

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
    if (_isDisposed) return; // Do not fetch videos if the bloc is disposed

    ListResult result = await FirebaseStorage.instance.ref().listAll();
    List<Video> fetchedVideos = [];

    for (Reference ref in result.items) {
      String videoUrl = await ref.getDownloadURL();
      String videoName = ref.name;

      fetchedVideos.add(Video(name: videoName, url: videoUrl));
    }

    _videos = fetchedVideos;
    _videosSubject.add(_videos); // Notify the completion of loading

    if (_videos.isEmpty) {
      _videosSubject.close(); // Close the BehaviorSubject if the list is empty
    }
  }

  void dispose() {
    _isDisposed = true;
    _videosSubject.close();
  }
}

class VideoListPage extends StatefulWidget {
  final VideoBloc videoBloc;

  VideoListPage({required this.videoBloc});

  @override
  _VideoListPageState createState() => _VideoListPageState();
}

class _VideoListPageState extends State<VideoListPage> {
  @override
  void initState() {
    super.initState();
    widget.videoBloc.fetchVideos();
  }

  @override
  void dispose() {
    widget.videoBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lessons'),
      ),
      body: StreamBuilder<List<Video>>(
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
              padding: EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: videos.length,
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    elevation: 4.0,
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(
                        videos[index].name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
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
