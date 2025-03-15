import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eremos/models/app_user.dart';
import 'package:eremos/models/puzzle_state.dart';

class Team {
  String? id;
  final String name;
  final List<PuzzleState> puzzles;

  Team({required this.name})
    : puzzles = [
        PuzzleState(
          puzzleName: "chessPuzzle",
          puzzleHints: [
            Hint(level: "easy"),
            Hint(level: "medium"),
            Hint(level: "hard"),
          ],
        ),
      ];

  Team.fromFirestore(Map<String, dynamic> data, this.id)
    : name = data['name'],
      puzzles = [for (var p in data['puzzles']) PuzzleState.fromFirestore(p)];

  // Method to convert a Team to a Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'puzzles': [
        {
          "puzzleName": "chessPuzzle",
          "puzzleHints": [
            {"level": "easy", "used": false},
            {"level": "medium", "used": false},
            {"level": "hard", "used": false},
          ],
        },
      ],
    };
  }

  // Get all users in this Team
  Future<List<CloudbaseUser>> getUsers(FirebaseFirestore db) async {
    List<CloudbaseUser> users = [];
    QuerySnapshot querySnapshot =
        await db.collection('users').where('teamId', isEqualTo: id).get();

    for (DocumentSnapshot doc in querySnapshot.docs) {
      final userData = doc.data() as Map<String, dynamic>;
      users.add(
        CloudbaseUser(
          uid: doc.id,
          displayName: userData['displayName'],
          teamId: userData['teamId'],
        ),
      );
    }
    return users;
  }
}
