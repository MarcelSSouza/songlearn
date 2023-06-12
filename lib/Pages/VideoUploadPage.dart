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
  bool _uploading = false;
  bool _uploadSuccess = false;

  void _pickVideo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );

    if (result != null) {
      setState(() {
        _videoFile = File(result.files.single.path!);
        _uploadSuccess = false;
      });
    }
  }

  Future<void> _uploadVideo() async {
    if (_videoFile != null) {
      String videoName = _videoNameController.text.trim();
      if (videoName.isNotEmpty) {
        setState(() {
          _uploading = true;
        });

        try {
          User? user = FirebaseAuth.instance.currentUser;
          if (user == null) {
            print('No user signed in');
            return;
          }

          Reference ref = FirebaseStorage.instance.ref().child(videoName);
          await ref.putFile(_videoFile!);
          String downloadURL = await ref.getDownloadURL();

          setState(() {
            _uploading = false;
            _uploadSuccess = true;
          });

          print('Download URL: $downloadURL');
          // Alert the user that upload was successful
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Video uploaded successfully'),
            ),
          );

          // Reset the state after successful upload
          Future.delayed(Duration(seconds: 2), () {
            if (mounted) {
              setState(() {
                _videoFile = null;
                _videoNameController.text = '';
                _uploadSuccess = false;
              });
            }
          });
        } catch (e) {
          print('Error uploading video: $e');
          setState(() {
            _uploading = false;
            _uploadSuccess = false;
          });
        }
      } else {
        print('Please enter a video name');
      }
    } else {
      print('Please select a video file');
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
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          color: Colors.black,
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
                      'Upload Lessons',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF64FEDA),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_videoFile == null)
                      ElevatedButton(
                        onPressed: _pickVideo,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          primary: Color(0xFF64FEDA),
                        ),
                        child: Text(
                          'Select Video',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    if (_videoFile != null)
                      Column(
                        children: [
                          Text(
                            'Selected Video: ${_videoFile!.path}',
                          ),
                          SizedBox(height: 16.0),
                          TextField(
                            controller: _videoNameController,
                            decoration: InputDecoration(
                              labelText: 'Video Name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          ElevatedButton(
                            onPressed: _uploading ? null : _uploadVideo,
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              primary: Color(0xFF64FEDA),
                            ),
                            child: _uploading
                                ? CircularProgressIndicator()
                                : Text(
                                    'Upload Video',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
