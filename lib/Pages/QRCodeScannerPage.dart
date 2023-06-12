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
            title: Text('Erro'),
            content: Text('Ocorreu um erro ao escanear o QR code: $e'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Fechar o diálogo de erro
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Scanner'),
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Result: $result',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 16),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'QR Code',
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _scanQRCode,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text('Scan QR Code'),
            ),
          ],
        ),
      ),
    );
  }
}
