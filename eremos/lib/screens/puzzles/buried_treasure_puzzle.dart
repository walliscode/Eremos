import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eremos/models/app_user.dart';
import 'package:eremos/screens/home/home.dart';
import 'package:eremos/screens/providers/auth_provider.dart';
import 'package:eremos/screens/puzzles/puzzles.dart';
import 'package:eremos/shared/base_app_bar.dart';
import 'package:eremos/shared/navigation_drawer.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BuriedTreasurePuzzle extends StatefulWidget {
  const BuriedTreasurePuzzle({super.key});

  @override
  BuriedTreasurePuzzleState createState() => BuriedTreasurePuzzleState();
}

class BuriedTreasurePuzzleState extends State<BuriedTreasurePuzzle> {
  late CloudbaseUser cbUser;
  late DocumentReference teamRef;

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

            userRef.get().then((DocumentSnapshot documentSnapshot) {
              final data = documentSnapshot.data() as Map<String, dynamic>;

              // if no teamId then return to main puzzles screens
              if (data['teamId'] == null) {
                // Navigate to the PuzzleScreen
                return WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => PuzzleScreen()),
                  );
                });
              }

              setState(() {
                // set the user data
                cbUser = CloudbaseUser(
                  uid: documentSnapshot.id,
                  displayName: data['displayName'],
                  teamId: data['teamId'],
                );

                // set the team data
                teamRef = db.collection('teams').doc(cbUser.teamId);
              });
            });

            return Scaffold(
              appBar: BaseAppBar(titleText: "Round Table Puzzle"),
              drawer: NavDrawer(isBenLoggedIn: value.isBenLoggedIn),
              body: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      "Where the limping beast leaves its trace,\n"
                      "And golden fields in name embrace.\n"
                      "Where moorland whispers to the breeze,\n"
                      "A crossing waits beneath the trees.\n\n"
                      "The finest man, his duty sworn,\n"
                      "Has laid the prize where paths are torn.\n"
                      "Three roads converge—your fate is spun,\n"
                      "Dig where the journey is undone.",
                    ),
                  ],
                ),
              ),
            );
          },
          error: (error, _) => Center(child: Text('Error loading user data.')),
          loading: () => Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
