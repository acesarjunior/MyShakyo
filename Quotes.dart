import 'package:flutter/material.dart';
import '../Content.dart';
import '../Sutras/lotus_sutra.dart';

class ZenQuotesApp extends StatelessWidget {
  const ZenQuotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zen Quotes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ZenQuotesScreen(),
    );
  }
}

class ZenQuotesScreen extends StatefulWidget {
  const ZenQuotesScreen({super.key});

  @override
  _ZenQuotesScreenState createState() => _ZenQuotesScreenState();
}

class _ZenQuotesScreenState extends State<ZenQuotesScreen> {
  String currentQuote = greetings[0];
  bool isJapanese = false;

  void toggleLanguage() {
    setState(() {
      isJapanese = !isJapanese;
    });
  }

  void getNextQuote() {
    setState(() {
      if (isJapanese) {
        currentQuote = hannyaShingyoKanjiListSub.join("\n");
      } else {
        currentQuote = greetings[DateTime.now().millisecondsSinceEpoch % greetings.length];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zen Quotes'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: toggleLanguage,
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Text(
              currentQuote,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18.0),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getNextQuote,
        tooltip: 'Next Quote',
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }
}

void main() {
  runApp(const ZenQuotesApp());
}