import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:student_manage_datacollection/qrscncapture.dart';
import 'package:student_manage_datacollection/signup.dart';
import 'package:student_manage_datacollection/student_data.dart';
import 'custom_button.dart';
import 'custom_textfiled.dart';
import 'firebase_auth.dart';

class LoginScrren extends StatefulWidget {
  final String username;
  const LoginScrren({super.key, required this.username});

  @override
  State<LoginScrren> createState() => _LoginScrrenState();
}

class _LoginScrrenState extends State<LoginScrren> {
  final _auth = AuthService();
  final _emailcontroller = TextEditingController();
  final _passwordcontroller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            const Spacer(),
            Text(
              "Login",
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 50),
            CustomTextfield(
              hint: "Enter Email",
              label: "Email",
              controller: _emailcontroller,
            ),
            SizedBox(height: 20),
            CustomTextfield(
              hint: "Enter Password",
              isPassword: true,
              label: "Password",
              controller: _passwordcontroller,
            ),
            SizedBox(height: 30),
            CustomButton(label: "Login", onpressed: _login),
            SizedBox(height: 10),

            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an account"),
                SizedBox(width: 5),
                InkWell(
                  onTap: () => gotoSignup(context),
                  child: Text("Signup", style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  gotoSignup(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignupScreen()),
    );
  }

  gotoHome(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder:
            (context) => StudentManage(
              username: widget.username,
              email: _emailcontroller.text,
              qrData: '',
              selfieBase64: '',
            ),
      ),
      (route) => false,
    );
  }

  _login() async {
    try {
      final user = await _auth.loginUserWithEmailAndPassword(
        _emailcontroller.text,
        _passwordcontroller.text,
      );

      if (user != null) {
        log("User Logged In Successfully");

        final username = await _auth.getUsername(user.uid);

        if (username != null) {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const QRScanPage()),
          );

          if (result != null &&
              result['qr'] != null &&
              result['selfieBase64'] != null) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder:
                    (context) => StudentManage(
                      username: username,
                      email: _emailcontroller.text,
                      qrData: result['qr'],
                      selfieBase64: result['selfieBase64'],
                    ),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("QR Scan or Selfie not completed.")),
            );
          }
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Username not found")));
        }
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Invalid email or password")));
      }
    } catch (e) {
      log("Login Error: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error during login")));
    }
  }
}
