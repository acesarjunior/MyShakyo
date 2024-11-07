import 'package:flutter/material.dart';
import 'time_selection_screen.dart';

class TransparentButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double maxFontSize;

  const TransparentButton({super.key, required this.text, required this.onPressed, this.maxFontSize = 72.0});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        //primary: Colors.transparent, // Transparent background
        overlayColor: Colors.grey,
        foregroundColor: Colors.grey,
        backgroundColor: Colors.transparent,//onPrimary: Colors.black, // Text color
        shadowColor: Colors.transparent, // Remove shadow
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(fontSize: maxFontSize <= 36.0 ? maxFontSize : 36.0), // Limiting font size to 36
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  String selectedFont = 'Regular';

  MainScreen({super.key}); // Default font

  @override
  Widget build(BuildContext context) {
  return Scaffold(
  appBar: AppBar(

  ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            const SizedBox(height: 16),
            TransparentButton(
              text: "Zazen",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TimeSelectionScreen(modality: 'Zazen')),
                );
              },
            ),
            const SizedBox(height: 16),
            TransparentButton(
              text: "Full Session",
              onPressed: () {
                Navigator.push(
                  context,
                   MaterialPageRoute(builder: (context) => const TimeSelectionScreen(modality: 'Zazen-Kinhin-Zazen')),

                );
              },
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                "© 2024 MyShakyo",
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),

          ],
        ),
      ),
    );
  }
}

