import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

//ORIGINAL

class KanjiView extends StatefulWidget {
  final List<String> kanjiList;
  final List<String> subtitles1;
  final List<String> subtitles2;
  final String selectedFont;
  final String sutraKey;

  const KanjiView({super.key, 
    required this.kanjiList,
    required this.subtitles1,
    required this.subtitles2,
    required this.selectedFont,
    required this.sutraKey,
  });

  @override
  _KanjiViewState createState() => _KanjiViewState();
}

class _KanjiViewState extends State<KanjiView> {
  int currentKanjiIndex = 0;
  List<List<Offset>> strokes = [[]];
  bool shouldShowEndMessage = false;
  bool shouldShowStartMessage = true;
  int currentIndex = 0;
  late String selectedFont;

  List<String> messages = [
    "Fix your posture, \nregulate the breath, \ncalm your mind, \nput palms together, \nand recite...\n",
    "The Four Vows \n\nTo save all sentient beings, though beings numberless \nTo transform all delusions, though delusions inexhaustible \nTo perceive reality, tough reality is boundless \nTo attain the enlightened way, a way non-attainable\n",
    "The Heart of the Perfection of Great Wisdom Sutra\n\nAvalokiteshvara Bodhisattva, Awakened One of Compassion,\nIn Prajna Paramita, the Deep Practice of Perfect Wisdom\nPerceived the emptiness of all five conditions, and was free of suffering.\nOh Shariputra, form is no other than emptiness, emptiness no other than form;\nForm is precisely emptiness, emptiness precisely form.\nSensations, perceptions, formations and consciousness are also like this.\nOh Shariputra, all things are expressions of emptiness,\nNot born, not destroyed, not stained, not pure;\nNeither waxing nor waning.\nThus emptiness is not form; not sensation nor perception, not formation nor consciousness.\nNo eye, ear, nose, tongue, body, mind;\nNo sight, sound, smell, taste, touch, nor object of mind;\nNo realm of sight, no realm of consciousness;\nNo ignorance, no end to ignorance;\nNo old age and death, no cessation of old age and death;\nNo suffering, nor cause or end to suffering;\nNo path, no wisdom and no gain.\nNo gain – thus Bodhisattvas live this Prajna Paramita\nWith no hindrance of mind.\nNo hindrance, therefore no fear.\nFar beyond all delusion, Nirvana is already here.\nAll past, present and future Buddhas\nLive this Prajna Paramita\nAnd realize supreme and complete enlightenment.\nTherefore know that Prajna Paramita is the sacred mantra, the luminous mantra,\nthe supreme mantra, the incomparable mantra by which all suffering is clear.\nThis is no other than Truth.\nTherefore set forth the Prajna Paramita mantra.\nSet forth this mantra and proclaim: Gate! Gate!\nParagate! Parasamgate!\nBodhi! Svaha! Hannya Shingyo\n"
  ];

  void _continue() {
    setState(() {
      if (currentIndex < messages.length - 1) {
        currentIndex++;
      } else {
        shouldShowStartMessage = false;
      }
    });
  }

  void nextKanji() {
    setState(() {
      if (currentKanjiIndex < widget.kanjiList.length - 1) {
        strokes = [[]];
        currentKanjiIndex++;
      } else {
        strokes = [[]];
        shouldShowEndMessage = true;
        currentKanjiIndex = 0;
      }
      _saveCurrentIndex(); // Save the current index when it changes
    });
  }

  @override
  void initState() {
    super.initState();
    selectedFont = widget.selectedFont;
    _loadCurrentIndex(); // Load the last saved index when initializing
    Future.delayed(const Duration(seconds: 240), () {
      setState(() {
        shouldShowStartMessage = false;
      });
    });
  }

  // Function to save the current index in shared preferences with a unique key
  void _saveCurrentIndex() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('${widget.sutraKey}_currentKanjiIndex', currentKanjiIndex);
  }

  // Function to load the last saved index from shared preferences with a unique key
  void _loadCurrentIndex() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? savedIndex = prefs.getInt('${widget.sutraKey}_currentKanjiIndex');
    if (savedIndex != null) {
      setState(() {
        currentKanjiIndex = savedIndex;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: shouldShowStartMessage
          ? SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                messages[currentIndex],
                style: const TextStyle(fontSize: 32, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              ElevatedButton(
                onPressed: _continue,
                style: ElevatedButton.styleFrom(
                  // primary: Colors.blue, // Background color of the button
                ),
                child: const Text(
                  "Continue",
                  style: TextStyle(
                    color: Colors.grey, // Text color of the button
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      )
          : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (shouldShowEndMessage)
              ...[
                SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "This was the last character...\nNow, put your hands together and recite... \n\nMay the merits of reciting these sutras permeate all beings in all places, so that all of us, sentient beings may realize together the way of the Buddha.",
                        style: TextStyle(fontSize: 32, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            shouldShowEndMessage = false;
                            currentKanjiIndex = 0; // Reset index
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          // primary: Colors.blue, // Background color of the button
                        ),
                        child: const Text(
                          "Restart",
                          style: TextStyle(
                            color: Colors.white, // Text color of the button
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ]
            else
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.80, // Set the height to cover the entire screen height
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.8, // Set a maximum width constraint
                              maxHeight: MediaQuery.of(context).size.height * 0.6, // Set a maximum height constraint
                            ),
                            child: FittedBox(
                              fit: BoxFit.contain, // Ensure the text scales to fit within the container
                              child: Text(
                                widget.kanjiList[currentKanjiIndex],
                                style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width * 0.6, // This is still important for initial size
                                  fontFamily: selectedFont,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onPanUpdate: (details) {
                        setState(() {
                          strokes.last.add(details.localPosition);
                        });
                      },
                      onPanEnd: (details) {
                        setState(() {
                          strokes.add([]);
                        });
                      },
                      child: CustomPaint(
                        painter: KanjiPainter(
                          strokes: strokes,
                          textSize: MediaQuery.of(context).size.width * 0.6,
                          context: context,
                          selectedFont: selectedFont, // Pass the selected font to the painter
                        ),
                        size: Size.infinite,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: SizedBox(
                        height: 87, // Set the height of the bottom bar
                        child: BottomAppBar(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.font_download, color: Colors.grey), // Font selection icon
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Select Font'),
                                        content: SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              ListTile(
                                                title: const Text('Font 1'),
                                                onTap: () {
                                                  setState(() {
                                                    selectedFont = 'Font1';
                                                  });
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              ListTile(
                                                title: const Text('Font 2'),
                                                onTap: () {
                                                  setState(() {
                                                    selectedFont = 'Font2';
                                                  });
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              // Add more font options here
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.arrow_back, color: Colors.grey), // Back icon
                                onPressed: () {
                                  setState(() {
                                    if (currentKanjiIndex > 0) {
                                      currentKanjiIndex--;
                                      strokes = [[]];
                                    }
                                  });
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.arrow_forward, color: Colors.grey), // Forward icon
                                onPressed: nextKanji,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (widget.subtitles1.isNotEmpty && widget.subtitles2.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '${widget.subtitles1[currentKanjiIndex]} - ${widget.subtitles2[currentKanjiIndex]}',
                  style: const TextStyle(fontSize: 24, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class KanjiPainter extends CustomPainter {
  final List<List<Offset>> strokes;
  final double textSize;
  final BuildContext context;
  final String selectedFont; // Add this line

  KanjiPainter({
    required this.strokes,
    required this.textSize,
    required this.context,
    required this.selectedFont, // Add this line
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (var stroke in strokes) {
      if (stroke.length > 1) {
        for (int i = 0; i < stroke.length - 1; i++) {
          final start = stroke[i];
          final end = stroke[i + 1];

          // Calcula a distância do início do traço
          double distance = start.distance;

          // Definir a espessura inicial e máxima do traço
          double initialThickness = 3.0;
          double maxThickness = 10.0;

          // Calcula a espessura com base na distância, mas sem voltar a afinar
          double thickness = initialThickness + (maxThickness - initialThickness) * (i / stroke.length);

          paint.strokeWidth = thickness;
          canvas.drawLine(start, end, paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
