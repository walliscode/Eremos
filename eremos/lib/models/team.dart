import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eremos/models/app_user.dart';

class Team {
  String? id;
  final String name;

  // drink tokens
  int toBeDrunk = 0;
  int toGive = 0;
  // chessPuzzle
  bool chessPuzzlePartOneSolved = false;
  bool chessPuzzlePartOneEasyHintUsed = false;
  bool chessPuzzlepartOneMediumHintUsed = false;
  bool chessPuzzlePartOneHardHintUsed = false;
  List<String?> chessPieces = List<String?>.filled(64, null);
  bool chessPuzzleSolved = false;

  // round table puzzle
  bool roundTablePuzzleSolved = false;
  bool seatOneUnlocked = false;
  bool seatOneSolved = false;
  bool seatTwoUnlocked = false;
  bool seatTwoSolved = false;
  bool seatThreeUnlocked = false;
  bool seatThreeSolved = false;
  bool seatFourUnlocked = false;
  bool seatFourSolved = false;
  bool seatFiveUnlocked = false;
  bool seatFiveSolved = false;
  bool seatSixUnlocked = false;
  bool seatSixSolved = false;

  Team({required this.name});

  Team.fromFirestore(Map<String, dynamic> data, this.id)
    : name = data['name'],
      toBeDrunk = data['toBeDrunk'],
      toGive = data['toGive'],
      chessPuzzleSolved = data['chessPuzzleSolved'],
      chessPuzzlePartOneSolved = data['chessPuzzlePartOneSolved'],
      chessPuzzlePartOneEasyHintUsed = data['chessPuzzlePartOneEasyHintUsed'],
      chessPuzzlepartOneMediumHintUsed =
          data['chessPuzzlePartOneMediumHintUsed'],
      chessPuzzlePartOneHardHintUsed = data['chessPuzzlePartOneHardHintUsed'],
      chessPieces = List<String?>.from(data['chessPieces']),

      roundTablePuzzleSolved = data['roundTablePuzzleSolved'],
      seatOneUnlocked = data['seatOneUnlocked'],
      seatOneSolved = data['seatOneSolved'],
      seatTwoUnlocked = data['seatTwoUnlocked'],
      seatTwoSolved = data['seatTwoSolved'],
      seatThreeUnlocked = data['seatThreeUnlocked'],
      seatThreeSolved = data['seatThreeSolved'],
      seatFourUnlocked = data['seatFourUnlocked'],
      seatFourSolved = data['seatFourSolved'],
      seatFiveUnlocked = data['seatFiveUnlocked'],
      seatFiveSolved = data['seatFiveSolved'],
      seatSixUnlocked = data['seatSixUnlocked'],
      seatSixSolved = data['seatSixSolved'];

  // Method to convert a Team to a Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      "name": name,
      "toBeDrunk": toBeDrunk,
      "toGive": toGive,
      "chessPuzzleSolved": chessPuzzleSolved,
      "chessPuzzlePartOneSolved": chessPuzzlePartOneSolved,
      "chessPuzzlePartOneEasyHintUsed": chessPuzzlePartOneEasyHintUsed,
      "chessPuzzlePartOneMediumHintUsed": chessPuzzlepartOneMediumHintUsed,
      "chessPuzzlePartOneHardHintUsed": chessPuzzlePartOneHardHintUsed,
      "chessPieces": chessPieces,
      "roundTablePuzzleSolved": roundTablePuzzleSolved,
      "seatOneUnlocked": seatOneUnlocked,
      "seatOneSolved": seatOneSolved,
      "seatTwoUnlocked": seatTwoUnlocked,
      "seatTwoSolved": seatTwoSolved,
      "seatThreeUnlocked": seatThreeUnlocked,
      "seatThreeSolved": seatThreeSolved,
      "seatFourUnlocked": seatFourUnlocked,
      "seatFourSolved": seatFourSolved,
      "seatFiveUnlocked": seatFiveUnlocked,
      "seatFiveSolved": seatFiveSolved,
      "seatSixUnlocked": seatSixUnlocked,
      "seatSixSolved": seatSixSolved,
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
