import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:wakelock/wakelock.dart';

class TimerScreen extends StatefulWidget {
  final int zazen1Time;
  final int kinhinTime;
  final int zazen2Time;

  const TimerScreen({super.key, required this.zazen1Time, required this.kinhinTime, required this.zazen2Time});

  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  late int currentTime;
  String currentPhase = 'Preparation';
  late int totalDuration;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isRunning = false;

  @override
  void initState() {
    super.initState();
    Wakelock.enable();
    totalDuration = widget.zazen1Time + widget.kinhinTime + widget.zazen2Time;
    currentTime = 20; // Initial preparation time in seconds
    _startMeditation();
  }

  void _startMeditation() async {
    setState(() {
      isRunning = true;
    });

    // Countdown for Preparation Phase
    currentPhase = 'Preparation';
    currentTime = 20; // Preparation time in seconds
    await _countDown(); // Wait for preparation countdown to finish

    if (widget.zazen1Time > 0) {
      playKesuZazenStart(1);
      currentPhase = 'Zazen';
      currentTime = widget.zazen1Time * 60;
      await _countDown();
    }
    if (widget.kinhinTime > 0) {
      currentPhase = 'Kinhin';
      currentTime = widget.kinhinTime * 60;
      playSmallBellDoubleHit(1);
      await _countDown();
    }
    if (widget.zazen2Time > 0) {
      currentPhase = 'Zazen 2';
      currentTime = widget.zazen2Time * 60;
      playSmallBellDoubleHit(1);
      await _countDown();
    }
    playKesuHit(1);
    setState(() {
      isRunning = false;
    });
  }

  Future<void> _countDown() async {
    while (currentTime > 0) {
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        currentTime--;
      });
    }
  }

  Future<void> playSmallBellDoubleHit(int times) async {
    for (int i = 0; i < times; i++) {
      await _audioPlayer.play(AssetSource('sounds/SmallBellDoubleHit.mp3'));
      await _audioPlayer.onPlayerComplete.first;
    }
  }

  Future<void> playKesuHit(int times) async {
    for (int i = 0; i < times; i++) {
      await _audioPlayer.play(AssetSource('sounds/KesuHit.mp3'));
      await _audioPlayer.onPlayerComplete.first;
    }
  }

  Future<void> playKesuZazenStart(int times) async {
    for (int i = 0; i < times; i++) {
      await _audioPlayer.play(AssetSource('sounds/KesuZazenStart.mp3'));
      await _audioPlayer.onPlayerComplete.first;
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    Wakelock.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Timer')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(currentPhase, style: const TextStyle(fontSize: 30)),
            Text(
              '${currentTime ~/ 60}:${(currentTime % 60).toString().padLeft(2, '0')}',
              style: const TextStyle(fontSize: 60),
            ),
            if (!isRunning)
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Back',
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
