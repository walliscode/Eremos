// this page will allow us to see current teams
// create and delete teams
// open a team to add or remove members

import 'package:eremos/shared/base_app_bar.dart';
import 'package:eremos/shared/navigation_drawer.dart';
import 'package:eremos/shared/styled_button.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Teams extends StatefulWidget {
  @override
  _TeamsState createState() => _TeamsState();
}

class _TeamsState extends State<Teams> {
  final TextEditingController _teamNameController = TextEditingController();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getTeams() async {
    QuerySnapshot querySnapshot = await _db.collection("teams").get();
    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  Future<void> addTeam(String teamName) async {
    final Map<String, dynamic> team = {'name': teamName, 'members': []};
    await _db.collection("teams").add(team);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(titleText: "Teams"),
      drawer: NavDrawer(),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: getTeams(),
              builder: (
                BuildContext context,
                AsyncSnapshot<List<Map<String, dynamic>>> snapshot,
              ) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No teams found'));
                } else {
                  List<Map<String, dynamic>> teams = snapshot.data!;
                  return ListView.builder(
                    itemCount: teams.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 200.0,
                          child: StyledButton(
                            onPressed: () {},
                            child: StyledButtonText(teams[index]["name"]),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          const SizedBox(height: 16.0),
          SizedBox(
            width: 200.0,
            child: TextFormField(
              controller: _teamNameController,
              decoration: const InputDecoration(labelText: 'Team Name'),
            ),
          ),
          const SizedBox(height: 16.0),
          StyledButton(
            onPressed: () async {
              await addTeam(_teamNameController.text.trim());
              setState(() {
                _teamNameController.clear();
              });
            },
            child: const StyledButtonText("Add Team"),
          ),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }
}
