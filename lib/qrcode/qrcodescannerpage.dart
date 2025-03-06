import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({Key? key}) : super(key: key);

  @override
  _QRScannerPageState createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  MobileScannerController cameraController = MobileScannerController();
  bool _isCameraInitialized = false;

  //DetectionSpeed detectionSpeed= DetectionSpeed.normal;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }
  Future<void> _initializeCamera() async {
    try {
      await cameraController.start();
      setState(() => _isCameraInitialized = true);
    } catch (e) {
      print("Failed to start camera: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCameraInitialized) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
      ),
      body: MobileScanner(
        controller: cameraController,
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          for (final barcode in barcodes) {
            final String? scannedCode = barcode.rawValue;
            if (scannedCode != null) {
              // Handle the scanned invite code
              processInviteCode(scannedCode);
            }
          }
        },
      ),
    );
  }

  void processInviteCode(String inviteCode) {
    // Process the scanned invite code
    // Example: Validate and use the invite code
    print("Scanned Invite Code: $inviteCode");
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }
}