import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'timer_screen.dart';

class TimeSelectionScreen extends StatefulWidget {
  final String modality;

  const TimeSelectionScreen({super.key, required this.modality});

  @override
  _TimeSelectionScreenState createState() => _TimeSelectionScreenState();
}

class _TimeSelectionScreenState extends State<TimeSelectionScreen> {
  int zazen1Time = 20; // Valor padrão inicial
  int kinhinTime = 0; // Valor padrão inicial seguro
  int zazen2Time = 0; // Valor padrão inicial seguro
  bool isLoading = true; // Estado de carregamento

  @override
  void initState() {
    super.initState();
    _loadTimes();
  }

  Future<void> _loadTimes() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      zazen1Time = prefs.getInt('zazen1Time') ?? 20;
      if (widget.modality == 'Zazen-Kinhin-Zazen') {
        kinhinTime = prefs.getInt('kinhinTime') ?? 21;
        zazen2Time = prefs.getInt('zazen2Time') ?? 30;
      }
      isLoading = false; // Dados carregados
    });
  }

  Future<void> _saveTimes() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('zazen1Time', zazen1Time);
    await prefs.setInt('kinhinTime', kinhinTime);
    await prefs.setInt('zazen2Time', zazen2Time);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      // Mostra um indicador de carregamento enquanto os dados são carregados
      return Scaffold(
        appBar: AppBar(title: const Text('Select Time')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Select Time')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.modality == 'Zazen' || widget.modality == 'Zazen-Kinhin-Zazen') ...[
            Text('Zazen: $zazen1Time minutes'),
            Slider(
              value: zazen1Time.toDouble().clamp(1.0, 60.0),
              min: 1,
              max: 60,
              divisions: 59,
              label: '$zazen1Time',
              onChanged: (value) {
                setState(() {
                  zazen1Time = value.toInt();
                });
                _saveTimes();
              },
            ),
          ],
          if (widget.modality == 'Zazen-Kinhin-Zazen') ...[
            Text('Kinhin: $kinhinTime minutes'),
            Slider(
              value: kinhinTime.toDouble().clamp(1.0, 60.0),
              min: 1,
              max: 60,
              divisions: 59,
              label: '$kinhinTime',
              onChanged: (value) {
                setState(() {
                  kinhinTime = value.toInt();
                });
                _saveTimes();
              },
            ),
            Text('Zazen 2: $zazen2Time minutes'),
            Slider(
              value: zazen2Time.toDouble().clamp(1.0, 60.0),
              min: 1,
              max: 60,
              divisions: 59,
              label: '$zazen2Time',
              onChanged: (value) {
                setState(() {
                  zazen2Time = value.toInt();
                });
                _saveTimes();
              },
            ),
          ],
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TimerScreen(
                    zazen1Time: zazen1Time,
                    kinhinTime: kinhinTime,
                    zazen2Time: zazen2Time,
                  ),
                ),
              );
            },
            child: const Text(
              'Start',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
