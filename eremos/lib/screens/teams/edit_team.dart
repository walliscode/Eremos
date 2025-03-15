import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eremos/models/app_user.dart';
import 'package:eremos/models/team.dart';
import 'package:eremos/shared/base_app_bar.dart';
import 'package:flutter/material.dart';

class EditTeamMembers extends StatefulWidget {
  final Team team;
  const EditTeamMembers({required this.team, super.key});

  @override
  EditTeamMembersState createState() => EditTeamMembersState();
}

class EditTeamMembersState extends State<EditTeamMembers> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(titleText: "Edit Teams"),
      body: Column(
        children: [
          const SizedBox(height: 20, child: Text("Delete Members")),

          Expanded(
            // using a FutureBuilder, get team users from database
            child: FutureBuilder<List<CloudbaseUser>>(
              future: widget.team.getUsers(_db),
              builder: (
                BuildContext context,
                AsyncSnapshot<List<CloudbaseUser>> snapshot,
              ) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No users found'));
                } else {
                  List<CloudbaseUser> users = snapshot.data!;
                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: SizedBox(
                          width: 200.0,
                          child: Card(
                            child: ListTile(
                              title: Text(users[index].displayName),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  // delete user from team
                                  // update the team in the database
                                  deleteUserFromTeam(
                                    users[index].uid,
                                    widget.team.id!,
                                  );
                                  setState(() {
                                    users.removeAt(index);
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),

          // using a Future builder, find all members without a team
          const SizedBox(height: 20.0, child: Text("Add Members")),
          Expanded(
            child: FutureBuilder<List<CloudbaseUser>>(
              future: getUnassignedUsers(),
              builder: (
                BuildContext context,
                AsyncSnapshot<List<CloudbaseUser>> snapshot,
              ) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No users found'));
                } else {
                  List<CloudbaseUser> users = snapshot.data!;
                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: SizedBox(
                          width: 200.0,
                          child: Card(
                            child: ListTile(
                              title: Text(users[index].displayName),
                              trailing: IconButton(
                                icon: const Icon(Icons.add),
                                // update teamId for User on press
                                onPressed: () async {
                                  await updateUserTeamId(
                                    users[index].uid,
                                    widget.team.id!,
                                  );
                                  setState(() {
                                    users.removeAt(index);
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // method to provide all users without a team

  Future<List<CloudbaseUser>> getUnassignedUsers() async {
    List<CloudbaseUser> users = [];
    QuerySnapshot querySnapshot =
        await _db.collection('users').where('teamId', isNull: true).get();
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

  // method to update the teamId for a user
  Future<void> updateUserTeamId(String userId, String teamId) async {
    await _db.collection('users').doc(userId).update({"teamId": teamId});
  }

  // method to delete a user from a team
  Future<void> deleteUserFromTeam(String userId, String teamId) async {
    await _db.collection('users').doc(userId).update({"teamId": null});
  }
}
