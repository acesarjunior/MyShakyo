import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:string_similarity/string_similarity.dart';

var enmeijukkukannongyoEnglish = "Ten-Verse Sutra of Avalokiteshvara\n\nEnmei Jukku Kannon Gyo *\n\n(Chant 7 times)\n\nKanzeon!\nAt one with Buddha\nDirectly Buddha\nAlso indirectly Buddha\nAnd indirectly Buddha, Dharma, Sangha\nJoyful, pure eternal being!\nMorning mind is *Kanzeon\nEvening mind is *Kanzeon\nNen, nen arises from mind\nNen, nen is not separate from mind.";
//var enmeijukkukannongyoPortuguese = "The Four enmeijukkukannongyos\n\nSalvar todos os seres sencientes, apesar de seres serem inumeráveis\nTransformar todas as ilusões, apesar de as ilusões serem inesgotáveis\nPerceber a Realidade, apesar de a Realidade ser ilimitada\nAlcançar o Caminho Iluminado, um Caminho inalcançável";
var enmeijukkukannongyoJapanese = "Enmei Jukku Kannon Gyo *\n\n(Chant 7 times)\n\nKanzeon Namu Butsu Yo Butsu U In\nYo Butsu U En\nBup Po So En\nJo Raku Ga Jo\nCho Nen Kanzeon\nBo Nen Kanzeon\nNen Nen Ju Shin Ki\nNen Nen Fu Ri Shin";

class enmeijukkukannongyoScreen extends StatefulWidget {
  const enmeijukkukannongyoScreen({super.key});

  @override
  _enmeijukkukannongyoScreenState createState() => _enmeijukkukannongyoScreenState();
}

class _enmeijukkukannongyoScreenState extends State<enmeijukkukannongyoScreen> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = enmeijukkukannongyoEnglish;
  String _lastWords = '';
  String selectedLanguage = 'English';
  List<String> words = [];
  List<String> wordsForComparison = [];
  int currentWordIndex = 0;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    words = _text.split(RegExp(r'\s+|\n')).where((s) => s.isNotEmpty).toList();
    wordsForComparison = _cleanTextForComparison(_text).split(' ').where((s) => s.isNotEmpty).toList();
  }

  void _startListening() async {
    bool available = await _speech.initialize(
      onStatus: (val) => print('onStatus: $val'),
      onError: (val) => print('onError: $val'),
    );
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (val) => setState(() {
          _lastWords = val.recognizedWords;
          _highlightNextWord(_lastWords);
        }),
      );
    }
  }

  void _stopListening() async {
    await _speech.stop();
    setState(() => _isListening = false);
  }

  String _cleanTextForComparison(String text) {
    return text.replaceAll(RegExp(r'[^\w\s]'), '').toLowerCase();
  }

  void _highlightNextWord(String spokenText) {
    List<String> spokenWords = _cleanTextForComparison(spokenText).split(' ').where((s) => s.isNotEmpty).toList();

    for (String recognizedWord in spokenWords) {
      if (currentWordIndex < wordsForComparison.length) {
        String expectedWord = wordsForComparison[currentWordIndex];

        double similarity = recognizedWord.similarityTo(expectedWord);

        if (similarity > 0.2) {
          currentWordIndex++;
        }
      }
    }
    setState(() {}); // Forçar uma reconstrução para atualizar as palavras
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enmei Juku Kannon Gyo'),
      ),
      body: Container(
        color: Colors.black, // Fundo preto
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /*ElevatedButton(
              onPressed: _isListening ? _stopListening : _startListening,
              child: Text(_isListening ? 'Stop Listening' : 'Start Listening'),
            ),*/
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: RichText(
                  text: TextSpan(
                    children: _buildWordSpans(),
                  ),
                ),
              ),
            ),
            LanguageSelectorDropdown(
              selectedLanguage: selectedLanguage,
              onLanguageChanged: (language) {
                setState(() {
                  selectedLanguage = language;
                  _text = language == 'English' ? enmeijukkukannongyoEnglish : enmeijukkukannongyoJapanese;
                  words = _text.split(RegExp(r'\s+|\n')).where((s) => s.isNotEmpty).toList();
                  wordsForComparison = _cleanTextForComparison(_text).split(' ').where((s) => s.isNotEmpty).toList();
                  currentWordIndex = 0;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  List<TextSpan> _buildWordSpans() {
    List<TextSpan> spans = [];
    for (int i = 0; i < words.length; i++) {
      spans.add(
        TextSpan(
          text: '${words[i]} ',
          style: TextStyle(
            fontSize: 24,
            color: i < currentWordIndex ? Colors.red : Colors.white,
          ),
        ),
      );
    }
    return spans;
  }
}

class LanguageSelectorDropdown extends StatelessWidget {
  final ValueChanged<String> onLanguageChanged;
  final String selectedLanguage;

  const LanguageSelectorDropdown({super.key, required this.onLanguageChanged, required this.selectedLanguage});

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      onChanged: (String? newValue) {
        if (newValue != null) {
          onLanguageChanged(newValue);
        }
      },
      value: selectedLanguage,
      items: <String>['English', 'Japanese']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}