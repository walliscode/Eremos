class Hint {
  final String level;
  final bool used;

  Hint({required this.level, this.used = false});

  Hint.fromFirestore(Map<String, dynamic> data)
    : level = data['level'],
      used = data['used'];
}

class PuzzleState {
  final String puzzleName;
  final bool solved = false;
  List<Hint> puzzleHints;

  PuzzleState({required this.puzzleName, required this.puzzleHints});

  PuzzleState.fromFirestore(Map<String, dynamic> data)
    : puzzleName = data['puzzleName'],
      puzzleHints = [for (var h in data['puzzleHints']) Hint.fromFirestore(h)];
}
