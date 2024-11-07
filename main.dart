import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Content.dart';
import 'Engine/Shakyo.dart';
import 'Engine/Timer.dart';
import 'Sutras/lotus_sutra.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';
import 'Engine/Chantbook.dart';

DateTime now = DateTime.now();
int year = now.year;

void main() {
  // Ensure the app is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Set the app to full screen
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(const MyApp());
}

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


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool shouldShowGreeting = true;
  bool isDarkMode = true;

  void toggleScheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: shouldShowGreeting
          ? GreetingView(onGreetingEnd: () {
        setState(() {
          shouldShowGreeting = false;
        });
      })
          : MenuView(toggleScheme: toggleScheme),
    );
  }
}

class GreetingView extends StatelessWidget {
  final VoidCallback onGreetingEnd;

  const GreetingView({super.key, required this.onGreetingEnd});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 7), onGreetingEnd);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Text(
              greetings[(greetings.length *
                  (DateTime.now().millisecondsSinceEpoch % 1000) /
                  1000)
                  .floor()],
              style: const TextStyle(fontSize: 32, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            Text(
              "© $year MyShakyo",
              style: const TextStyle(fontSize: 24, color: Colors.grey),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class MenuView extends StatefulWidget {
  final VoidCallback toggleScheme;

  const MenuView({super.key, required this.toggleScheme});

  @override
  _MenuViewState createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
  String selectedFont = 'Regular'; // Default font

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: widget.toggleScheme,
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TransparentButton(
              text: "Timer",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MainScreen()),
                );
              },
            ),
            const SizedBox(height: 16),
            TransparentButton(
              text: "Shakyo",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => KanjiListView(selectedFont: selectedFont),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            TransparentButton(
              text: "Chants",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChantView()),
                );
              },
            ),
            const SizedBox(height: 16),
            TransparentButton(
              text: "About",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DanaView()),
                );
              },
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                "© $year MyShakyo",
                style: const TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}




class KanjiListView extends StatelessWidget {
  final String selectedFont;

  const KanjiListView({super.key, required this.selectedFont});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text("Shakyo"),
      ),
      body: SingleChildScrollView(
        child: ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            ListTile(
              title: Center(
                child: TransparentButton(
                  text: "Heart Sutra",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => KanjiView(
                          kanjiList: hannyaShingyoKanjiList,
                          subtitles1: hannyaShingyoKanjiListSub,
                          subtitles2: hannyaShingyoSub2,
                          selectedFont: selectedFont,
                          sutraKey: 'HeartSutra', // Pass unique key for Heart Sutra
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            /*ListTile(
              title: Center(
                child: Text(
                  "Lankavatara Sutra",
                  style: TextStyle(fontSize: 54, color: Colors.grey),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => KanjiView(
                      kanjiList: LankavataraKanjiList,
                      subtitles1: LankavataraKanjiListSub,
                      subtitles2: LankavataraSub2,
                      selectedFont: selectedFont,
                      sutraKey: 'LankavataraSutra', // Pass unique key for Lankavatara Sutra
                    ),
                  ),
                );
              },
            ),*/
            const SizedBox(height: 16),
            Center(
              child: Text(
                "© $year MyShakyo",
                style: const TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}



  class DanaView extends StatelessWidget {
  const DanaView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //title: Text("About"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 24, color: Colors.grey),
            children: [
              const TextSpan(
                text:
                "This app was meticulously developed with the heartfelt intention of positively impacting individual's lives, particularly within the Buddhist community. It functions without relying on contributions and is entirely ad-free. My earnest aspiration is for this app to enhance your spiritual journey, bringing profound joy and happiness into your life.\n\nI extend my sincere gratitude to my family and friends, whose unwavering support made the creation of this app a reality. Special appreciation is extended to Sensei Jundo Cohen, also to my dear friend Bion for generously offer the audio for this app and the entire ",
              ),
              TextSpan(
                text: "Treeleaf Sangha",
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.grey,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    launch('https://www.treeleaf.org');
                  },
              ),
              TextSpan(
                text:
                " for their invaluable inspiration and guidance.\n\nGassho!\n\nSatLah\n\n© $year MyShakyo"
                    ,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MenuButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const MenuButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }
}






