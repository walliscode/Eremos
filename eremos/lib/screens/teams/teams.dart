// this page will allow us to see current teams
// create and delete teams
// open a team to add or remove members

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eremos/shared/base_app_bar.dart';
import 'package:eremos/shared/navigation_drawer.dart';
import 'package:eremos/shared/styled_button.dart';
import 'package:flutter/material.dart';

class Teams extends StatefulWidget {
  const Teams({super.key});

  @override
  State<Teams> createState() => _TeamsState();
}

class _TeamsState extends State<Teams> {
  // controllers
  final TextEditingController _teamNameController = TextEditingController();

  // store an instance of Firestore
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  List<Map<String, dynamic>> teams = [];

  // get all teams from Firestore
  Future<void> getTeams() async {
    // define query for all teams
    // note to self: await always returns a Future, equally you need await to define a type as a future

    _db.collection("teams").get().then((QuerySnapshot querySnapShot) {
      for (var doc in querySnapShot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        teams.add(data);
      }
    }, onError: (e) => print("Error getting teams: $e"));
  }

  // add Team to Firestore
  // this should take in a team name from a text field and have a submit button

  Future<void> addTeam(String teamName) async {
    // define the team to be added
    final Map<String, dynamic> team = {'name': teamName, 'members': []};
    // add the team to Firestore
    _db.collection("teams").add(team);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(titleText: "Teams"),
      drawer: NavDrawer(),
      body: Column(
        children: [
          // create a list view of teams, with each team being a button that navigates to the team page
          ListView.builder(
            shrinkWrap: true,
            itemCount: teams.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(teams[index]['name']),
                onTap: () {
                  // navigate to team page
                },
              );
            },
          ),
          const SizedBox(height: 16.0),

          // add team button
          SizedBox(
            width: 200.0,
            child: TextFormField(
              controller: _teamNameController,
              decoration: const InputDecoration(labelText: 'Team Name'),
            ),
          ),

          const SizedBox(height: 16.0),

          // submit button
          StyledButton(
            onPressed: () async {
              await addTeam(_teamNameController.text.trim());
              setState(() {
                _teamNameController.clear();
              });
            },
            child: const StyledButtonText("Add Team"),
          ),
        ],
      ),
    );
  }
}
