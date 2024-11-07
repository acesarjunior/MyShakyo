import 'package:flutter/material.dart';
import '../Chants/enmeijukkukannongyo.dart';
import '../Chants/fourvows.dart';
import '../Chants/fueko.dart';
import '../Chants/hannyashingyo.dart';
import '../Chants/jihosanshi.dart';
import '../Chants/kaikyoge.dart';
import '../Chants/sankiraimon.dart';
import '../Chants/tissarana.dart';

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

class ChantView extends StatelessWidget {
  String selectedFont = 'Regular';

  ChantView({super.key}); // Default font

  @override
  Widget build(BuildContext context) {
    // Retrieve the screen width and height
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Calculate font size dynamically based on screen width
    double baseFontSize = screenWidth * 0.05; // Example: 5% of screen width

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TransparentButton(
              text: "Sanki Raimon",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const sankiraimonScreen()),
                );
              },
            ),
            const SizedBox(height: 16),
            TransparentButton(
              text: "Kaikyo Ge",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const kaikyogeScreen()),
                );
              },
            ),
            const SizedBox(height: 16),
            TransparentButton(
              text: "Lotus Sutra",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HannyashingyoScreen()),
                );
              },
            ),
            const SizedBox(height: 16),
            TransparentButton(
              text: "Fueko",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const fuekoScreen()),
                );
              },
            ),
            const SizedBox(height: 16),
            TransparentButton(
              text: "Jihin Sanshi",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const jihonsanshiScreen()),
                );
              },
            ),
            const SizedBox(height: 16),
            TransparentButton(
              text: "Kannon Gyo",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const enmeijukkukannongyoScreen()),
                );
              },
            ),
            const SizedBox(height: 16),
            TransparentButton(
              text: "4 Vows",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const vowScreen()),
                );
              },
            ),
            const SizedBox(height: 16),
            TransparentButton(
              text: "Tissarana",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TissaranaScreen()),
                );
              },
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                "© 2024 MyShakyo",
                style: TextStyle(fontSize: baseFontSize * 0.4, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
