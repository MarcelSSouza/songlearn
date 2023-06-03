import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';
class MetronomeScreen extends StatefulWidget {
  @override
  _MetronomeScreenState createState() => _MetronomeScreenState();
}

class _MetronomeScreenState extends State<MetronomeScreen> {
  bool _isPlaying = false;
  int _currentTempo = 120; // Default tempo

  void _startMetronome() {
    setState(() {
      _isPlaying = true;
    });
    _playTick();
  }

  void _stopMetronome() {
    setState(() {
      _isPlaying = false;
    });
  }

  void _playTick() async {
    while (_isPlaying) {
      Vibration.vibrate(duration: 100);
      await Future.delayed(Duration(milliseconds: _calculateDelay()));
    }
  }

  int _calculateDelay() {
    // Adjust the delay based on the tempo
    switch (_currentTempo) {
      case 120:
        return 500; // Allegro
      case 90:
        return 670; // Moderato
      case 60:
        return 1000; // Andante
      default:
        return 1000; // Default delay
    }
  }

  void _selectTempo(int tempo) {
    setState(() {
      _currentTempo = tempo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Metronome'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Tempo: $_currentTempo BPM',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TempoButton(
                tempo: 120,
                isSelected: _currentTempo == 120,
                onPressed: _selectTempo,
              ),
              TempoButton(
                tempo: 90,
                isSelected: _currentTempo == 90,
                onPressed: _selectTempo,
              ),
              TempoButton(
                tempo: 60,
                isSelected: _currentTempo == 60,
                onPressed: _selectTempo,
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.play_arrow),
                onPressed: _isPlaying ? null : _startMetronome,
              ),
              IconButton(
                icon: Icon(Icons.stop),
                onPressed: _stopMetronome,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TempoButton extends StatelessWidget {
  final int tempo;
  final bool isSelected;
  final Function(int) onPressed;

  TempoButton({
    required this.tempo,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: isSelected
              ? MaterialStateProperty.all(Colors.blue)
              : null,
        ),
        onPressed: () => onPressed(tempo),
        child: Text(tempo.toString()),
      ),
    );
  }
}