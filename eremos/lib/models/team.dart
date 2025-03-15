import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eremos/models/app_user.dart';

class Team {
  final String id;
  final String name;

  Team({required this.id, required this.name});

  // Factory constructor to create a Team from a Firestore document
  factory Team.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Team(id: doc.id, name: data['name'] ?? '');
  }

  // Method to convert a Team to a Firestore document
  Map<String, dynamic> toFirestore() {
    return {'name': name};
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
