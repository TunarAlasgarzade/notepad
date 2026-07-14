import 'package:flutter/material.dart';

class MyTextfield extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final int? minLines;
  final int? maxLines;
  const MyTextfield({
    super.key,
    required this.controller,
    required this.hintText,
    this.minLines,
    this.maxLines
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      minLines: minLines,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Colors.green,
            width: 2
          )
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8)
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Colors.green,
            width: 2
          ),
        ),
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.grey
        )
      ),
    );
  }
}