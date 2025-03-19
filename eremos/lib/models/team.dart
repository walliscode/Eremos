import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eremos/models/app_user.dart';

class Team {
  String? id;
  final String name;

  // chessPuzzle
  bool chessPuzzlePartOneSolved = false;
  bool chessPuzzlePartOneEasyHintUsed = false;
  bool chessPuzzlepartOneMediumHintUsed = false;
  bool chessPuzzlePartOneHardHintUsed = false;

  List<String?> chessPieces = List<String?>.filled(64, null);

  bool chessPuzzleSolved = false;

  Team({required this.name});

  Team.fromFirestore(Map<String, dynamic> data, this.id)
    : name = data['name'],
      chessPuzzleSolved = data['chessPuzzleSolved'],
      chessPuzzlePartOneSolved = data['chessPuzzlePartOneSolved'],
      chessPuzzlePartOneEasyHintUsed = data['chessPuzzlePartOneEasyHintUsed'],
      chessPuzzlepartOneMediumHintUsed =
          data['chessPuzzlePartOneMediumHintUsed'],
      chessPuzzlePartOneHardHintUsed = data['chessPuzzlePartOneHardHintUsed'],
      chessPieces = List<String?>.from(data['chessPieces']);

  // Method to convert a Team to a Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      "name": name,
      "chessPuzzleSolved": chessPuzzleSolved,
      "chessPuzzlePartOneSolved": chessPuzzlePartOneSolved,
      "chessPuzzlePartOneEasyHintUsed": chessPuzzlePartOneEasyHintUsed,
      "chessPuzzlePartOneMediumHintUsed": chessPuzzlepartOneMediumHintUsed,
      "chessPuzzlePartOneHardHintUsed": chessPuzzlePartOneHardHintUsed,
      "chessPieces": chessPieces,
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
