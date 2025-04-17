
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCodeGenerator extends StatefulWidget {
  @override
  _QRCodeGeneratorState createState() => _QRCodeGeneratorState();
}

class _QRCodeGeneratorState extends State<QRCodeGenerator> {
  String _qrData = "Initial Data";
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _updateQRData();
    _timer = Timer.periodic(Duration(days: 1), (timer) {
      _updateQRData();
    });
  }

  void _updateQRData() {
    setState(() {
      _qrData = "Updated Data: ${DateTime.now()}";
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('QR Code')),
      body: Center(
        child: QrImageView(
          data: _qrData,
          version: QrVersions.auto,
          size: 300.0,
        ),
      ),
    );
  }
}
