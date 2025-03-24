// create a widget that takes in current team information
// it looks at the number of drink tokens that each team has
// these consist of toBeDrunk and toGive
// toBeDrunk is the number of drinks that the team has to drink and can be decreased by the team
// toGive is the number of drinks that the team has to give to another team
//

import 'package:cloud_firestore/cloud_firestore.dart'
    show
        DocumentReference,
        DocumentSnapshot,
        FieldValue,
        FirebaseFirestore,
        QuerySnapshot;
import 'package:eremos/models/app_user.dart';
import 'package:eremos/screens/home/home.dart';
import 'package:eremos/screens/providers/auth_provider.dart';
import 'package:eremos/shared/base_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ManageDrinks extends StatefulWidget {
  const ManageDrinks({super.key});
  @override
  _ManageDrinksState createState() => _ManageDrinksState();
}

class _ManageDrinksState extends State<ManageDrinks> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final AsyncValue<AppUser?> user = ref.watch(authProvider);

        return user.when(
          data: (value) {
            // return user to home screen if not logged in
            if (value == null) {
              return WelcomeScreen();
            }

            final db = FirebaseFirestore.instance;

            // get user data from Firestore (this is the Cloud store rather than the Auth data)
            final DocumentReference userRef = db
                .collection('users')
                .doc(value.uid);

            return FutureBuilder<DocumentSnapshot>(
              future: userRef.get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error loading user data.'));
                }

                if (!snapshot.hasData || snapshot.data == null) {
                  return Center(child: Text('No user data found.'));
                }

                final data = snapshot.data!.data() as Map<String, dynamic>;

                // if no teamId then return to home screen
                if (data['teamId'] == null) {
                  return WelcomeScreen();
                }

                final teamRef = db.collection('teams').doc(data['teamId']);

                return FutureBuilder<DocumentSnapshot>(
                  future: teamRef.get(),
                  builder: (context, teamSnapshot) {
                    if (teamSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (teamSnapshot.hasError) {
                      return Center(child: Text('Error loading team data.'));
                    }

                    if (!teamSnapshot.hasData || teamSnapshot.data == null) {
                      return Center(child: Text('No team data found.'));
                    }

                    final teamData =
                        teamSnapshot.data!.data() as Map<String, dynamic>;
                    int toBeDrunk = teamData['toBeDrunk'] ?? 0;
                    int toGive = teamData['toGive'] ?? 0;

                    return Scaffold(
                      appBar: BaseAppBar(titleText: 'Manage Drinks'),
                      body: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Drinks to be drunk: $toBeDrunk'),
                            ElevatedButton(
                              onPressed: () {
                                if (toBeDrunk > 0) {
                                  setState(() {
                                    toBeDrunk--;
                                  });
                                  teamRef.update({'toBeDrunk': toBeDrunk});
                                }
                              },
                              child: Text('Drink'),
                            ),
                            SizedBox(height: 20),
                            Text('Drinks to give: $toGive'),
                            Expanded(
                              child: StreamBuilder<QuerySnapshot>(
                                stream: db.collection('teams').snapshots(),
                                builder: (context, teamsSnapshot) {
                                  if (teamsSnapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }

                                  if (teamsSnapshot.hasError) {
                                    return Center(
                                      child: Text('Error loading teams.'),
                                    );
                                  }

                                  if (!teamsSnapshot.hasData ||
                                      teamsSnapshot.data == null) {
                                    return Center(
                                      child: Text('No teams found.'),
                                    );
                                  }

                                  final teams =
                                      teamsSnapshot.data!.docs
                                          .where(
                                            (doc) => doc.id != data['teamId'],
                                          )
                                          .toList();

                                  return ListView.builder(
                                    itemCount: teams.length,
                                    itemBuilder: (context, index) {
                                      final team = teams[index];
                                      final teamName =
                                          team['name'] ?? 'Unnamed Team';

                                      return ListTile(
                                        title: Text(teamName),
                                        onTap: () {
                                          if (toGive > 0) {
                                            setState(() {
                                              toGive--;
                                            });
                                            teamRef.update({'toGive': toGive});
                                            db
                                                .collection('teams')
                                                .doc(team.id)
                                                .update({
                                                  'toBeDrunk':
                                                      FieldValue.increment(1),
                                                });
                                          }
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
          error: (error, _) => Center(child: Text('Error loading user data.')),
          loading: () => Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
