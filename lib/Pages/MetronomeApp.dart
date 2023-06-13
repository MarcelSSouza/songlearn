import 'dart:math';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';
import 'package:audioplayers/audioplayers.dart';

class MetronomeScreen extends StatefulWidget {
  @override
  _MetronomeScreenState createState() => _MetronomeScreenState();
}

class _MetronomeScreenState extends State<MetronomeScreen> {
  bool _isPlaying = false;
  int _currentTempo = 120;
  TextEditingController _bpmController = TextEditingController();
  List<bool> _noteSelections = List.generate(6, (index) => false);
  List<String> _notes = ['E', 'A', 'D', 'G', 'B', 'LE'];
  List<AudioPlayer> _audioPlayers = List.generate(6, (index) => AudioPlayer());

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
    return (60000 / _currentTempo).round();
  }

  void _selectTempo(int tempo) {
    setState(() {
      _currentTempo = tempo;
      _bpmController.text = tempo.toString();
    });
  }

  void _setCustomTempo() {
    setState(() {
      _currentTempo = int.tryParse(_bpmController.text) ?? 120;
    });
  }

  void _selectNoteIndex(int index) {
    _playNoteSound(index);
    setState(() {
      if (_noteSelections[index]) {
        _noteSelections[index] = false;
      } else {
        _noteSelections = List.generate(6, (i) => i == index);
        _playNoteSound(index);
      }
    });
  }

  void _playNoteSound(int index) async {
    AudioPlayer audioPlayer = AudioPlayer();
    await audioPlayer.play(AssetSource('notes/${_notes[index]}.mp3'));
  }

  @override
  void initState() {
    super.initState();
    _bpmController.text = _currentTempo.toString();
  }

  @override
  void dispose() {
    for (var player in _audioPlayers) {
      player.release();
    }
    _bpmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                color: Colors.grey[900],
                child: Center(
                  child: Text(
                    'Metronome & Tuner',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF64FEDA),
                    ),
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(top: 60),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Card(
                        color: Colors.grey[900],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Text(
                                'Tempo - $_currentTempo BPM',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF64FEDA),
                                ),
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
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
                                  ElevatedButton(
                                    onPressed: _setCustomTempo,
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.grey[800],
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    child: Text(
                                      'Set BPM',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Container(
                                    width: 100,
                                    child: TextFormField(
                                      controller: _bpmController,
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 10,
                                        ),
                                        filled: true,
                                        fillColor: Colors.grey[800],
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(Icons.play_arrow),
                                    onPressed:
                                        _isPlaying ? null : _startMetronome,
                                    iconSize: 32,
                                    color: _isPlaying
                                        ? Color(0xFF64FEDA)
                                        : Colors.white,
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.stop),
                                    onPressed: _stopMetronome,
                                    iconSize: 32,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Card(
                        color: Colors.grey[900],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(32),
                          child: Column(
                            children: [
                              Text(
                                'Tuning Fork',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF64FEDA),
                                ),
                              ),
                              SizedBox(height: 20),
                              Wrap(
                                alignment: WrapAlignment.center,
                                children: _buildNoteButtons(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildNoteButtons() {
    List<Widget> buttons = [];
    for (int i = 0; i < _notes.length; i++) {
      buttons.add(
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: InkWell(
            onTap: () => _selectNoteIndex(i),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color:
                    _noteSelections[i] ? Color(0xFF64FEDA) : Colors.grey[800],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                _notes[i],
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      );
    }
    return buttons;
  }
}

class TempoButton extends StatelessWidget {
  final int tempo;
  final bool isSelected;
  final Function(int) onPressed;

  const TempoButton({
    required this.tempo,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onPressed(tempo),
      style: ElevatedButton.styleFrom(
        primary: isSelected ? Color(0xFF64FEDA) : Colors.grey[800],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Text(
        tempo.toString(),
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 18,
        ),
      ),
    );
  }
}
