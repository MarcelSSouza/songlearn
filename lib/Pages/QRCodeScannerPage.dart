import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:url_launcher/url_launcher.dart';

class QRCodeScannerPage extends StatefulWidget {
  @override
  _QRCodeScannerPageState createState() => _QRCodeScannerPageState();
}

class _QRCodeScannerPageState extends State<QRCodeScannerPage> {
  String? result = '';

  Future<void> _scanQRCode() async {
    try {
      String? cameraScanResult = await scanner.scan();
      Uri cameraScanResultUri = Uri.parse(cameraScanResult!);

      setState(() {
        result = cameraScanResult;
      });

      _launchURL(cameraScanResultUri);
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('An error occurred while scanning the QR code: $e'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _launchURL(Uri url) async {
    await launchUrl(url);
  }

  void _clearResult() {
    setState(() {
      result = '';
    });
  }

  void _openVideoPlayer() {
    if (result != null && result!.isNotEmpty) {
      _launchURL(Uri.parse(result!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
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
                    'Scan Lesson QR Code',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF64FEDA),
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (result != null && result!.isNotEmpty)
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      margin: EdgeInsets.all(32),
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Result: ',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF64FEDA),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: _clearResult,
                                  icon: Icon(Icons.close),
                                  color: Colors.white,
                                  iconSize: 28,
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '$result',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: _openVideoPlayer,
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                backgroundColor: Color(0xFF64FEDA),
                              ),
                              child: Text(
                                'Open Video Player',
                                style: TextStyle(
                                  color: Colors.grey[900],
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ElevatedButton(
                    onPressed: _scanQRCode,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      backgroundColor: Color(0xFF64FEDA),
                    ),
                    child: Text(
                      'Scan QR Code',
                      style: TextStyle(color: Colors.grey[900], fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
