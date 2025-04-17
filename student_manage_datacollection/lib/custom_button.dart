import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final void Function()? onpressed;
  const CustomButton({super.key, required this.label, this.onpressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 42,
      child: ElevatedButton(
        onPressed: onpressed,
        child: Text(label, style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
