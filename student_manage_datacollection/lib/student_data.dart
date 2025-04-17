import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart' as loc;
import 'package:random_string/random_string.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:student_manage_datacollection/qrscncapture.dart';

class StudentManage extends StatefulWidget {
  final String username;
  final String email;
  final String qrData;
  final String selfieBase64;
  const StudentManage({
    super.key,
    required this.username,
    required this.email,
    required this.qrData,
    required this.selfieBase64,
  });

  @override
  State<StudentManage> createState() => _StudentState();
}

class _StudentState extends State<StudentManage> {
  TextEditingController ageController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  String? qrCodeData;
  String? selfieBase64;
  String currentTime = '';

  Future<void> _getCurrentLocation() async {
    loc.Location location = loc.Location();

    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return;
    }

    loc.PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != loc.PermissionStatus.granted) return;
    }

    loc.LocationData locationData = await location.getLocation();
    double? lat = locationData.latitude;
    double? lon = locationData.longitude;

    if (lat != null && lon != null) {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);
      Placemark place = placemarks[0];
      String address =
          "${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}";

      setState(() {
        locationController.text = address;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    usernameController.text = widget.username;
    currentTime = DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.now());
    qrCodeData = widget.qrData;
    selfieBase64 = widget.selfieBase64;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Welcome",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 20, top: 30, right: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => QRScanPage()),
                    );

                    if (result != null) {
                      setState(() {
                        qrCodeData = result['qr'];
                        selfieBase64 = result['selfieBase64'];
                      });
                    }
                  },
                  child: CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.grey[300],
                    backgroundImage:
                        selfieBase64 != null
                            ? MemoryImage(base64Decode(selfieBase64!))
                            : null,
                    child:
                        selfieBase64 == null
                            ? Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.grey[700],
                            )
                            : null,
                  ),
                ),
              ),
              const Text(
                "Name",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),

              TextField(
                readOnly: true,
                controller: usernameController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 10,
                  ),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(color: Colors.grey, width: 1),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                "Email",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              TextField(
                controller: TextEditingController(text: widget.email),
                readOnly: true,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(color: Colors.grey, width: 1),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              const Text(
                "Location",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              TextField(
                controller: locationController,
                readOnly: true,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 10,
                  ),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(color: Colors.grey, width: 1),
                  ),
                ),
              ),

              const SizedBox(height: 14),
              const Text(
                "Current Time",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              TextField(
                controller: TextEditingController(text: currentTime),
                readOnly: true,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(color: Colors.grey, width: 1),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const SizedBox(height: 20),

              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 10,
                    ),
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: () async {
                    if (locationController.text.isEmpty ||
                        qrCodeData == null ||
                        selfieBase64 == null) {
                      Fluttertoast.showToast(
                        msg: "Please fill in all details and scan QR",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                      return;
                    }

                    String id = randomAlphaNumeric(10);

                    Map<String, dynamic> employeeInfoMap = {
                      "Name": usernameController.text,

                      "Age": ageController.text,
                      "Location": locationController.text,
                      "Id": id,
                      "QRCode": qrCodeData,
                      "SelfieBase64": selfieBase64,
                      "Timestamp": FieldValue.serverTimestamp(),
                      "Email": widget.email,
                    };

                    await FirebaseFirestore.instance
                        .collection("Student")
                        .doc(id)
                        .set(employeeInfoMap)
                        .then((value) {
                          Fluttertoast.showToast(
                            msg: "Student details uploaded successfully",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        })
                        .catchError((e) {
                          Fluttertoast.showToast(
                            msg: "Error uploading details: $e",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        });
                    Navigator.pop(context);

                  },
                  child: const Text(
                    "Add",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
