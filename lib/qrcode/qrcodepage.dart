import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCodePage extends StatelessWidget {
  final String inviteCode;

  const QRCodePage({Key? key, required this.inviteCode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Share Invite Code'),
      ),
      body: Center(
        child: QrImageView(
          data: inviteCode,
          version: QrVersions.auto,
          size: 200.0,
        ),
      ),
    );
  }
}