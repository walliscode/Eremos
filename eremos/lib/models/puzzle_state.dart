class Hint {
  final String level;
  final bool used;

  Hint({required this.level, this.used = false});

  Hint.fromFirestore(Map<String, dynamic> data)
    : level = data['level'],
      used = data['used'];

  Map<String, dynamic> toFirestore(Hint hint) {
    return {"level": hint.level, "used": hint.used};
  }
}

class PuzzlePart {
  final String partName;
  final bool solved = false;
  List<Hint> puzzleHints;

  PuzzlePart({required this.partName, required this.puzzleHints});
  PuzzlePart.fromFirestore(Map<String, dynamic> data)
    : partName = data['partName'],
      puzzleHints = [for (var h in data['puzzleHints']) Hint.fromFirestore(h)];

  Map<String, dynamic> toFirestore(PuzzlePart part) {
    return {
      "partName": part.partName,
      "solved": part.solved,
      "puzzleHints": [for (var h in part.puzzleHints) h.toFirestore(h)],
    };
  }
}

class PuzzleState {
  final String puzzleName;
  List<PuzzlePart> puzzleParts;
  final bool solved = false;

  PuzzleState({required this.puzzleName, required this.puzzleParts});

  PuzzleState.fromFirestore(Map<String, dynamic> data)
    : puzzleName = data['puzzleName'],
      puzzleParts = [
        for (var p in data['puzzleParts']) PuzzlePart.fromFirestore(p),
      ];

  Map<String, dynamic> toFirestore(PuzzleState puzzle) {
    return {
      "puzzleName": puzzle.puzzleName,
      "puzzleParts": [for (var p in puzzle.puzzleParts) p.toFirestore(p)],
    };
  }
}
