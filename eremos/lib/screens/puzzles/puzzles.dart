import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eremos/models/app_user.dart';
import 'package:eremos/screens/home/home.dart';
import 'package:eremos/screens/providers/auth_provider.dart';
import 'package:eremos/screens/puzzles/buried_treasure_puzzle.dart';
import 'package:eremos/screens/puzzles/chess_puzzle.dart';
import 'package:eremos/screens/puzzles/round_table_puzzle.dart';
import 'package:eremos/shared/base_app_bar.dart';
import 'package:eremos/shared/navigation_drawer.dart';
import 'package:eremos/shared/styled_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// the Puzzle "home" screen will contain access to all 3 puzzles
// successive puzzles will become available as the user completes the previous puzzle
// this will be done by using grayed out buttons for puzzles that are not yet available

class PuzzleScreen extends StatefulWidget {
  const PuzzleScreen({super.key});
  @override
  _PuzzleScreenState createState() => _PuzzleScreenState();
}

class _PuzzleScreenState extends State<PuzzleScreen> {
  bool chessPuzzleSolved = false;
  bool roundTablePuzzleSolved = false;
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
                    MaterialPageRoute(builder: (context) => WelcomeScreen()),
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

                // set the part one solved status
                teamRef.get().then((DocumentSnapshot doc) {
                  final teamData = doc.data() as Map<String, dynamic>;

                  chessPuzzleSolved = teamData['chessPuzzleSolved'];
                  roundTablePuzzleSolved = teamData['roundTablePuzzleSolved'];
                });
              });
            });

            return Scaffold(
              appBar: BaseAppBar(titleText: "puzzles"),
              drawer: NavDrawer(isBenLoggedIn: value.isBenLoggedIn),
              body: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Puzzles'),
                    const SizedBox(height: 16.0),
                    // puzzle 1
                    StyledButton(
                      onPressed: () {
                        // navigate to chess puzzle screen
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ChessPuzzle(),
                          ),
                        );
                      },
                      child: const StyledButtonText('Puzzle 1'),
                    ),
                    const SizedBox(height: 16.0),
                    // puzzle 2
                    StyledButton(
                      isEnabled: chessPuzzleSolved,
                      onPressed: () {
                        // navgiate to round table puzzle screen
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const RoundTablePuzzle(),
                          ),
                        );
                      },
                      child: const StyledButtonText('Puzzle 2'),
                    ),
                    const SizedBox(height: 16.0),
                    // puzzle 3
                    StyledButton(
                      isEnabled: roundTablePuzzleSolved,
                      onPressed: () {
                        // navigate to puzzle 3 screen
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => BuriedTreasurePuzzle(),
                          ),
                        );
                      },
                      child: const StyledButtonText('Puzzle 3'),
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
