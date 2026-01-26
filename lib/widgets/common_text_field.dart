import 'package:flutter/material.dart';

class CommonTextField extends StatelessWidget {
  final String label;
  final bool obscureText;
  final Function(String)? onChanged;
  final TextEditingController? controller;

  const CommonTextField({
    super.key,
    required this.label,
    this.obscureText = false,
    this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 45),
      child: TextField(
        obscureText: obscureText,
        controller: controller,
        style: TextStyle(color: Colors.blueAccent[600]),
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          labelText: label,
          labelStyle: TextStyle(color: Colors.blueAccent[600]),
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueAccent, width: 1),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueAccent, width: 1),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueAccent, width: 2),
          ),
        ),
      ),
    );
  }
}
