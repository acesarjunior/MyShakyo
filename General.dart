import 'package:flutter/material.dart';

class TransparentButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const TransparentButton({super.key, required this.text, required this.onPressed});
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth * 0.10; // 5% of screen width


    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        //primary: Colors.transparent, // No splash color
        backgroundColor: Colors.transparent, // Button background color
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: fontSize, color: Colors.grey),// Customize text style here
      ),
    );
  }
}