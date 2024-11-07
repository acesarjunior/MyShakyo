import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:string_similarity/string_similarity.dart';

var hannyashingyoEnglish =
    "The Heart of the Perfection of Great Wisdom Sutra ◎\n\nAvalokiteshvara Bodhisattva, Awakened One of Compassion,\nIn Prajna Paramita, the Deep Practice of Perfect Wisdom ◎\nPerceived the emptiness of all five conditions, and was free of suffering.\nOh Shariputra, form is no other than emptiness, emptiness no other than form;\nForm is precisely emptiness, emptiness precisely form.\nSensations, perceptions, formations and consciousness are also like this.\nOh Shariputra, all things are expressions of emptiness,\nNot born, not destroyed, not stained, not pure;\nNeither waxing nor waning.\nThus emptiness is not form; not sensation nor perception, not formation nor consciousness.\nNo eye, ear, nose, tongue, body, mind;\nNo sight, sound, smell, taste, touch, nor object of mind;\nNo realm of sight, no realm of consciousness;\nNo ignorance, no end to ignorance;\nNo old age and death, no cessation of old age and death;\nNo suffering, nor cause or end to suffering;\nNo path, no wisdom and no gain.\nNo gain – thus Bodhisattvas live this Prajna Paramita\n◎ With no hindrance of mind.\nNo hindrance, therefore no fear.\nFar beyond all delusion, Nirvana is already here.\nAll past, present and future Buddhas\nLive this Prajna Paramita ◎\nAnd realize supreme and complete enlightenment.\nTherefore know that Prajna Paramita is the sacred mantra, the luminous mantra,\nthe supreme mantra, the incomparable mantra by which all suffering is clear.\nThis is no other than Truth.\nTherefore set forth the Prajna Paramita mantra.\nSet forth this mantra and proclaim: Gate! Gate!\n● Paragate! Parasamgate!\n● Bodhi! Svaha! Hannya Shingyo";

var hannyashingyoJapanese =
    "Maka Hannya Haramita Shingyo ◎\n\n Kan ji zai bo satsu gyo jin han-nya ha ra mi ta ji sho ken ◎ go on kai ku do is-sai ku yaku sha ri shi shiki fu i ku ku fu i shiki shiki soku ze ku ku soku ze shiki ju so gyo shiki yaku bu nyo ze sha ri shi ze sho ho ku so fu sho fu metsu fu ku fu jo fu zo fu gen ze ko ku chu mu shiki mu ju so gyo shiki mu gen ni bi zes-shin ni mu shiki sho ko mi soku ho mu gen kai nai shi mu i shiki kai mu mu myo yaku mu mu myo jin nai shi mu ro shi yaku mu ro shi jin ku shu metsu do mu chi yaku mu toku i mu sho tok-ko bo dai sat-ta e han-nya ha ra mi ta ◎ ko shin mu kei ge mu kei ge ko mu u ku fu on ri is-sai ten do mu so ku gyo ne han san ze sho butsu e han-nya ha ra mi ta ◎ ko toku a noku ta ra san myaku san bo dai ko chi han-nya ha ra mi ta ze dai jin shu ze dai myo shu ze mu jo shu ze mu to do shu no jo is-sai ku shin jitsu fu ko ko setsu han-nya ha ra mi ta shu soku setsu shu watsu gya tei gya tei ● ha ra gya tei hara so gya tei ● bo ji sowa ka han-nya shin gyo";

class HannyashingyoScreen extends StatefulWidget {
  const HannyashingyoScreen({super.key});

  @override
  _HannyashingyoScreenState createState() => _HannyashingyoScreenState();
}

class _HannyashingyoScreenState extends State<HannyashingyoScreen> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = hannyashingyoEnglish;
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
        title: const Text('Hannya Shingyo'),
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
                  _text = language == 'English' ? hannyashingyoEnglish : hannyashingyoJapanese;
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
