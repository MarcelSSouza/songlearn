import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LyricsPage extends StatefulWidget {
  @override
  _LyricsPageState createState() => _LyricsPageState();
}

class _LyricsPageState extends State<LyricsPage> {
  TextEditingController _searchController = TextEditingController();
  String _lyrics = '';
  String _artist = '';
  String _title = '';
  String _thumbnailUrl = '';

  Future<void> _fetchLyrics() async {
    String searchQuery = _searchController.text.trim();

    if (searchQuery.isNotEmpty) {
      String apiUrl =
          'https://some-random-api.com/others/lyrics?title=$searchQuery';
      http.Response response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        String lyrics = responseData['lyrics'];
        String artist = responseData['author'];
        String title = responseData['title'];
        String thumbnailUrl = responseData['thumbnail']['genius'];

        setState(() {
          _lyrics = lyrics;
          _artist = artist;
          _title = title;
          _thumbnailUrl = thumbnailUrl;
        });
      } else {
        setState(() {
          _lyrics = 'Lyrics not found.';
          _artist = '';
          _title = '';
          _thumbnailUrl = '';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  color: Colors.grey[900],
                  child: Center(
                    child: Text(
                      'Lyrics',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF64FEDA),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 55.0),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      Card(
                        color: Colors.grey[900],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              TextField(
                                controller: _searchController,
                                decoration: InputDecoration(
                                    alignLabelWithHint: true,
                                    hintText: 'Search for lyrics...',
                                    hintStyle:
                                        TextStyle(color: Color(0xFF64FEDA))),
                                style: TextStyle(color: Colors.white),
                                onChanged: (value) {
                                  setState(() {});
                                },
                              ),
                              SizedBox(height: 16.0),
                              ElevatedButton.icon(
                                onPressed: _fetchLyrics,
                                icon: Icon(
                                  Icons.search,
                                  color: Colors.grey[900],
                                ),
                                label: Text(
                                  'Search',
                                  style: TextStyle(
                                      color: Colors.grey[900],
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary: Color(0xFF64FEDA),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Visibility(
                        visible: _lyrics.isNotEmpty,
                        child: Card(
                          color: Colors.grey[900],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                if (_thumbnailUrl.isNotEmpty)
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(16.0),
                                    child: Image.network(
                                      _thumbnailUrl,
                                      height: 120,
                                      width: 120,
                                    ),
                                  ),
                                SizedBox(width: 16.0),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Artist',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                          color: Color(0xFF64FEDA),
                                        ),
                                      ),
                                      SizedBox(height: 8.0),
                                      Text(
                                        '$_artist',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(height: 8.0),
                                      Text(
                                        'Title',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                          color: Color(0xFF64FEDA),
                                        ),
                                      ),
                                      SizedBox(height: 8.0),
                                      Text(
                                        '$_title',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.all(32.0),
                            child: Text(
                              _lyrics,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
