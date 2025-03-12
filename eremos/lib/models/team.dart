import 'package:cloud_firestore/cloud_firestore.dart';

class Team {
  final String id;
  final String name;
  final List<String> members;

  Team({required this.id, required this.name, required this.members});

  // Factory constructor to create a Team from a Firestore document
  factory Team.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Team(
      id: doc.id,
      name: data['name'] ?? '',
      members: List<String>.from(data['members'] ?? []),
    );
  }

  // Method to convert a Team to a Firestore document
  Map<String, dynamic> toFirestore() {
    return {'name': name, 'members': members};
  }
}
