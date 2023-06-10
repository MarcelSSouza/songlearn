import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:video_player/video_player.dart';

class Video {
  final String name;
  final String url;
  bool isFavorite;

  Video({required this.name, required this.url, this.isFavorite = false});
}

class VideoBloc {
  List<Video> _videos = [];
  final _videosSubject = BehaviorSubject<List<Video>>();
  Stream<List<Video>> get videosStream => _videosSubject.stream;

  void fetchVideos() async {
    ListResult result = await FirebaseStorage.instance.ref().listAll();
    List<Video> fetchedVideos = [];

    for (Reference ref in result.items) {
      String videoUrl = await ref.getDownloadURL();
      String videoName = ref.name;

      fetchedVideos.add(Video(name: videoName, url: videoUrl));
    }

    _videos = fetchedVideos;
    _videosSubject.add(_videos); // Notificar a conclusão do carregamento

    if (_videos.isEmpty) {
      _videosSubject
          .close(); // Fechar o StreamController se a lista estiver vazia
    }
  }

  void toggleFavorite(int index) {
    _videos[index].isFavorite = !_videos[index].isFavorite;
    _videosSubject.add(_videos);
  }

  List<Video> getFavoriteVideos() {
    return _videos.where((video) => video.isFavorite).toList();
  }

  void dispose() {
    _videosSubject.close();
  }
}
