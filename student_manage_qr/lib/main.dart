import 'package:flutter/material.dart';

import 'package:student_manage_qr/qrcodegenerator.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: QRCodeGenerator(),
    );
  }
}
