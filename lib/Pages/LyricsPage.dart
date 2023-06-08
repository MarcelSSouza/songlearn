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
        

        setState(() {
          _lyrics = lyrics;
        });
      } else {
        setState(() {
          _lyrics = 'Lyrics not found.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lyrics Search'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Enter song name',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _fetchLyrics,
              child: Text('Search'),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: SingleChildScrollView(
                child: Text(_lyrics),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
