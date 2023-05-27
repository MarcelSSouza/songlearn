class Note {
  final String name;
  final double frequency;

  Note({
    required this.name,
    required this.frequency,
  });
}

final List<Note> notes = [
  Note(name: 'E', frequency: 82.41),
  Note(name: 'A', frequency: 110.0),
  Note(name: 'D', frequency: 146.83),
  Note(name: 'G', frequency: 196.0),
  Note(name: 'B', frequency: 246.94),
  Note(name: 'E', frequency: 329.63),
];
