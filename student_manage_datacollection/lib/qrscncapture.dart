import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;

class QRScanPage extends StatefulWidget {
  const QRScanPage({Key? key}) : super(key: key);

  @override
  State<QRScanPage> createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  bool _isQRCodeDetected = false;
  String _qrData = '';
  CameraController? _cameraController;
  File? _capturedImage;
  bool _isCameraReady = false;

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _startFrontCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
    );

    _cameraController = CameraController(
      frontCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await _cameraController!.initialize();
    setState(() {
      _isCameraReady = true;
    });
  }

  String encodeImageToBase64(File imageFile) {
    List<int> imageBytes = imageFile.readAsBytesSync();
    return base64Encode(imageBytes);
  }

  Future<void> _captureSelfie() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized)
      return;

    final picture = await _cameraController!.takePicture();
    final tempDir = await getTemporaryDirectory();
    final imagePath = join(
      tempDir.path,
      'selfie_${DateTime.now().millisecondsSinceEpoch}.png',
    );
    final savedImage = await File(picture.path).copy(imagePath);

    setState(() {
      _capturedImage = savedImage;
    });

    Fluttertoast.showToast(msg: 'Selfie Captured! Uploading...');

    String encodedImage = encodeImageToBase64(savedImage);

    Navigator.pop(context, {'qr': _qrData, 'selfieBase64': encodedImage});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Qr Scanner')),
      body:
          _capturedImage != null
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('QR Code: $_qrData', style: TextStyle(fontSize: 16)),
                    SizedBox(height: 20),
                    Image.file(_capturedImage!),
                  ],
                ),
              )
              : !_isQRCodeDetected
              ? MobileScanner(
                onDetect: (barcodeCapture) async {
                  final String code =
                      barcodeCapture.barcodes.first.rawValue ?? 'Unknown';
                  print('Scanned QR Code: $code');
                  if (!code.startsWith("Updated Data:")) {
                    Fluttertoast.showToast(
                      msg:
                          'Invalid QR Code. Please scan the QR from the authorized source.',
                      backgroundColor: Colors.red,
                    );
                    return;
                  }
                  setState(() {
                    _qrData = code;
                    _isQRCodeDetected = true;
                  });

                  await _startFrontCamera();
                },
              )
              : _isCameraReady
              ? Stack(
                children: [
                  CameraPreview(_cameraController!),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.camera_alt),
                        label: Text('Capture Selfie'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 24,
                          ),
                        ),
                        onPressed: _captureSelfie,
                      ),
                    ),
                  ),
                ],
              )
              : Center(child: CircularProgressIndicator()),
    );
  }
}
