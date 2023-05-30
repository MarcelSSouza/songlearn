import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

class VideoUploadPage extends StatefulWidget {
  @override
  _VideoUploadPageState createState() => _VideoUploadPageState();
}

class _VideoUploadPageState extends State<VideoUploadPage> {
  File? _videoFile;
  TextEditingController _videoNameController = TextEditingController();

  void _pickVideo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );

    if (result != null) {
      setState(() {
        _videoFile = File(result.files.single.path!);
      });
    }
  }

  Future<String> uploadVideo(File videoFile, String videoName) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print('No user signed in');
        return '';
      }
      Reference ref = FirebaseStorage.instance.ref().child(videoName);
      await ref.putFile(videoFile);
      String downloadURL = await ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error uploading video: $e');
      return '';
    }
  }

  @override
  void dispose() {
    _videoNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Upload'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _pickVideo,
              child: Text('Select Video'),
            ),
            SizedBox(height: 16.0),
            if (_videoFile != null)
              Text('Selected Video: ${_videoFile!.path}'),
            SizedBox(height: 16.0),
            TextField(
              controller: _videoNameController,
              decoration: InputDecoration(
                labelText: 'Video Name',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                if (_videoFile != null) {
                  String videoName = _videoNameController.text.trim();
                  if (videoName.isNotEmpty) {
                    String downloadURL = await uploadVideo(_videoFile!, videoName);
                    print('Download URL: $downloadURL');
                    // Alert the user that upload was successful
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Video uploaded successfully'),
                      ),
                    );
                  } else {
                    print('Please enter a video name');
                  }
                } else {
                  print('Please select a video file');
                }
              },
              child: Text('Upload Video'),
            ),
          ],
        ),
      ),
    );
  }
}
