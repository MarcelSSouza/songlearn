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
    String? cameraScanResult = await scanner.scan();

    //froms trign to uri
    Uri cameraScanResultUri = Uri.parse(cameraScanResult!);

    setState(() {
      result = cameraScanResult;
    });

 
    _launchURL(cameraScanResultUri);
    
  }

  Future<void> _launchURL(Uri url) async {
      await launchUrl(url );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Scanner'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Result: $result'),
            ElevatedButton(
              onPressed: _scanQRCode,
              child: Text('Scan QR Code'),
            ),
          ],
        ),
      ),
    );
  }
}
