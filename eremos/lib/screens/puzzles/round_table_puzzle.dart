import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eremos/models/app_user.dart';
import 'package:eremos/screens/home/home.dart';
import 'package:eremos/screens/providers/auth_provider.dart';
import 'package:eremos/screens/puzzles/puzzles.dart';
import 'package:eremos/shared/base_app_bar.dart';
import 'package:eremos/shared/navigation_drawer.dart';
import 'package:eremos/shared/styled_button.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RoundTablePuzzle extends StatefulWidget {
  const RoundTablePuzzle({super.key});

  @override
  RoundTablePuzzleState createState() => RoundTablePuzzleState();
}

class RoundTablePuzzleState extends State<RoundTablePuzzle> {
  final TextEditingController _seatOnePartOne = TextEditingController();
  final TextEditingController _seatOnePartTwo = TextEditingController();
  final TextEditingController _seatTwoPartOne = TextEditingController();
  final TextEditingController _seatTwoPartTwo = TextEditingController();
  final TextEditingController _seatThreePartOne = TextEditingController();
  final TextEditingController _seatThreePartTwo = TextEditingController();
  final TextEditingController _seatFourPartOne = TextEditingController();
  final TextEditingController _seatFourPartTwo = TextEditingController();
  final TextEditingController _seatFivePartOne = TextEditingController();
  final TextEditingController _seatFivePartTwo = TextEditingController();
  final TextEditingController _seatSixPartOne = TextEditingController();
  final TextEditingController _seatSixPartTwo = TextEditingController();

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

                // set the solved status for each seat
                teamRef.get().then((DocumentSnapshot doc) {
                  final teamData = doc.data() as Map<String, dynamic>;
                  roundTablePuzzleSolved = teamData['roundTablePuzzleSolved'];
                  seatOneUnlocked = teamData['seatOneUnlocked'];
                  seatOneSolved = teamData['seatOneSolved'];
                  seatTwoUnlocked = teamData['seatTwoUnlocked'];
                  seatTwoSolved = teamData['seatTwoSolved'];
                  seatThreeUnlocked = teamData['seatThreeUnlocked'];
                  seatThreeSolved = teamData['seatThreeSolved'];
                  seatFourUnlocked = teamData['seatFourUnlocked'];
                  seatFourSolved = teamData['seatFourSolved'];
                  seatFiveUnlocked = teamData['seatFiveUnlocked'];
                  seatFiveSolved = teamData['seatFiveSolved'];
                  seatSixUnlocked = teamData['seatSixUnlocked'];
                  seatSixSolved = teamData['seatSixSolved'];
                });
              });
            });

            return Scaffold(
              appBar: BaseAppBar(titleText: "Round Table Puzzle"),
              drawer: NavDrawer(isBenLoggedIn: value.isBenLoggedIn),
              body: Center(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double centerX =
                        constraints.maxWidth / 2; // Get center of the widget

                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // King Arthur at the center
                        Positioned(
                          left: centerX - 60,
                          top: 120,
                          child: Column(
                            children: [
                              const Text(
                                "Son of Uther",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Seats arranged in a circle
                        Positioned(
                          left: centerX - 150,
                          top: 60,
                          child: Row(
                            children: [
                              if (!seatOneUnlocked) ...[
                                SizedBox(
                                  width: 100.0,
                                  child: TextFormField(
                                    controller: _seatOnePartOne,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: '...',
                                    ),
                                  ),
                                ),
                                StyledButton(
                                  onPressed: () {
                                    if (_seatOnePartOne.text == "Excalibur") {
                                      // update the part to solved
                                      final DocumentReference teamRef = db
                                          .collection('teams')
                                          .doc(cbUser.teamId);

                                      teamRef.update({"seatOneUnlocked": true});
                                    } else {
                                      _dialogBuilder(context, "Wrong Answer");
                                    }
                                  },
                                  child: const StyledButtonText("Try"),
                                ),
                              ],
                              if (seatOneUnlocked & !seatOneSolved) ...[
                                StyledButton(
                                  onPressed: () {
                                    _dialogBuilder(
                                      context,
                                      "A blade I wield, yet love cuts deeper,\n"
                                      "Bound by duty, yet fate is steeper.\n"
                                      "Across the sea, my heart was lost,\n"
                                      "In poisoned bliss, I paid the cost.",
                                    );
                                  },
                                  child: const StyledButtonText("?"),
                                ),
                                SizedBox(
                                  width: 100.0,
                                  child: TextFormField(
                                    controller: _seatOnePartTwo,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: '...',
                                    ),
                                  ),
                                ),
                                StyledButton(
                                  onPressed: () {
                                    if (_seatOnePartTwo.text == "Tristan") {
                                      // update the part to solved
                                      final DocumentReference teamRef = db
                                          .collection('teams')
                                          .doc(cbUser.teamId);
                                      teamRef.update({"seatOneSolved": true});
                                    } else {
                                      _dialogBuilder(context, "Wrong Answer");
                                    }
                                  },
                                  child: const StyledButtonText("Try"),
                                ),
                              ],
                              if (seatOneSolved) ...[const Text("Tristan")],
                            ],
                          ),
                        ),
                        Positioned(
                          left: centerX + 90,
                          top: 60,
                          child: Row(
                            children: [
                              if (!seatTwoUnlocked) ...[
                                SizedBox(
                                  width: 100.0,
                                  child: TextFormField(
                                    controller: _seatTwoPartOne,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: '...',
                                    ),
                                  ),
                                ),
                                StyledButton(
                                  onPressed: () {
                                    if (_seatTwoPartOne.text == "Grail") {
                                      // update the part to solved
                                      final DocumentReference teamRef = db
                                          .collection('teams')
                                          .doc(cbUser.teamId);

                                      teamRef.update({"seatTwoUnlocked": true});
                                    } else {
                                      _dialogBuilder(context, "Wrong Answer");
                                    }
                                  },
                                  child: const StyledButtonText("Try"),
                                ),
                              ],
                              if (seatTwoUnlocked & !seatTwoSolved) ...[
                                StyledButton(
                                  onPressed: () {
                                    _dialogBuilder(
                                      context,
                                      "A challenge was made, my honor at stake,\n"
                                      "With an axe I struck, but a debt I must take.\n"
                                      "Green was my foe, and courage my test,\n"
                                      "Among Arthur’s kin, I’m one of the best. Who am I?",
                                    );
                                  },
                                  child: const StyledButtonText("?"),
                                ),
                                SizedBox(
                                  width: 100.0,
                                  child: TextFormField(
                                    controller: _seatTwoPartTwo,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: '...',
                                    ),
                                  ),
                                ),
                                StyledButton(
                                  onPressed: () {
                                    if (_seatTwoPartTwo.text == "Gawain") {
                                      // update the part to solved
                                      final DocumentReference teamRef = db
                                          .collection('teams')
                                          .doc(cbUser.teamId);
                                      teamRef.update({"seatTwoSolved": true});
                                    } else {
                                      _dialogBuilder(context, "Wrong Answer");
                                    }
                                  },
                                  child: const StyledButtonText("Try"),
                                ),
                              ],
                              if (seatTwoSolved) ...[const Text("Gawain")],
                            ],
                          ),
                        ),
                        Positioned(
                          left: centerX + 120,
                          top: 120,
                          child: Row(
                            children: [
                              if (!seatThreeUnlocked) ...[
                                SizedBox(
                                  width: 100.0,
                                  child: TextFormField(
                                    controller: _seatThreePartOne,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: '...',
                                    ),
                                  ),
                                ),
                                StyledButton(
                                  onPressed: () {
                                    if (_seatThreePartOne.text == "Dragon") {
                                      // update the part to solved
                                      final DocumentReference teamRef = db
                                          .collection('teams')
                                          .doc(cbUser.teamId);

                                      teamRef.update({
                                        "seatThreeUnlocked": true,
                                      });
                                    } else {
                                      _dialogBuilder(context, "Wrong Answer");
                                    }
                                  },
                                  child: const StyledButtonText("Try"),
                                ),
                              ],
                              if (seatThreeUnlocked & !seatThreeSolved) ...[
                                StyledButton(
                                  onPressed: () {
                                    _dialogBuilder(
                                      context,
                                      "I was the strongest in deed and in heart,\n"
                                      "But love and betrayal tore me apart.\n"
                                      "Though Arthur’s right hand, I caused him great strife,\n"
                                      "For I loved his queen more than my life. Who am I?",
                                    );
                                  },
                                  child: const StyledButtonText("?"),
                                ),
                                SizedBox(
                                  width: 100.0,
                                  child: TextFormField(
                                    controller: _seatThreePartTwo,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: '...',
                                    ),
                                  ),
                                ),
                                StyledButton(
                                  onPressed: () {
                                    if (_seatThreePartTwo.text == "Lancelot") {
                                      // update the part to solved
                                      final DocumentReference teamRef = db
                                          .collection('teams')
                                          .doc(cbUser.teamId);
                                      teamRef.update({"seatThreeSolved": true});
                                    } else {
                                      _dialogBuilder(context, "Wrong Answer");
                                    }
                                  },
                                  child: const StyledButtonText("Try"),
                                ),
                              ],
                              if (seatThreeSolved) ...[const Text("Lancelot")],
                            ],
                          ),
                        ),

                        Positioned(
                          left: centerX + 60,
                          top: 180,
                          child: Row(
                            children: [
                              if (!seatFourUnlocked) ...[
                                SizedBox(
                                  width: 100.0,
                                  child: TextFormField(
                                    controller: _seatFourPartOne,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: '...',
                                    ),
                                  ),
                                ),
                                StyledButton(
                                  onPressed: () {
                                    if (_seatFourPartOne.text == "Staff") {
                                      final DocumentReference teamRef = db
                                          .collection('teams')
                                          .doc(cbUser.teamId);
                                      teamRef.update({
                                        "seatFourUnlocked": true,
                                      });
                                    } else {
                                      _dialogBuilder(context, "Wrong Answer");
                                    }
                                  },
                                  child: const StyledButtonText("Try"),
                                ),
                              ],
                              if (seatFourUnlocked & !seatFourSolved) ...[
                                StyledButton(
                                  onPressed: () {
                                    _dialogBuilder(
                                      context,
                                      "Raised in the wild, I knew little of men,\n"
                                      "But with purest intent, I set forth again.\n"
                                      "A cup I did seek, of legend and might,\n"
                                      "Yet only the worthy would see it in sight. Who am I?",
                                    );
                                  },
                                  child: const StyledButtonText("?"),
                                ),
                                SizedBox(
                                  width: 100.0,
                                  child: TextFormField(
                                    controller: _seatFourPartTwo,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: '...',
                                    ),
                                  ),
                                ),
                                StyledButton(
                                  onPressed: () {
                                    if (_seatFourPartTwo.text == "Percival") {
                                      final DocumentReference teamRef = db
                                          .collection('teams')
                                          .doc(cbUser.teamId);
                                      teamRef.update({"seatFourSolved": true});
                                    } else {
                                      _dialogBuilder(context, "Wrong Answer");
                                    }
                                  },
                                  child: const StyledButtonText("Try"),
                                ),
                              ],
                              if (seatFourSolved) ...[const Text("Percival")],
                            ],
                          ),
                        ),
                        Positioned(
                          left: centerX - 180,
                          top: 180,
                          child: Row(
                            children: [
                              if (!seatFiveUnlocked) ...[
                                SizedBox(
                                  width: 100.0,
                                  child: TextFormField(
                                    controller: _seatFivePartOne,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: '...',
                                    ),
                                  ),
                                ),
                                StyledButton(
                                  onPressed: () {
                                    if (_seatFivePartOne.text == "Stone") {
                                      final DocumentReference teamRef = db
                                          .collection('teams')
                                          .doc(cbUser.teamId);
                                      teamRef.update({
                                        "seatFiveUnlocked": true,
                                      });
                                    } else {
                                      _dialogBuilder(context, "Wrong Answer");
                                    }
                                  },
                                  child: const StyledButtonText("Try"),
                                ),
                              ],
                              if (seatFiveUnlocked & !seatFiveSolved) ...[
                                StyledButton(
                                  onPressed: () {
                                    _dialogBuilder(
                                      context,
                                      "In my hands, a blade of power,\n"
                                      "Cast to the lake in Arthur’s final hour.\n"
                                      "The last who remained, I saw him away,\n"
                                      "On Avalon’s shores, he sleeps to this day. Who am I?",
                                    );
                                  },
                                  child: const StyledButtonText("?"),
                                ),
                                SizedBox(
                                  width: 100.0,
                                  child: TextFormField(
                                    controller: _seatFivePartTwo,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: '...',
                                    ),
                                  ),
                                ),
                                StyledButton(
                                  onPressed: () {
                                    if (_seatFivePartTwo.text == "Bevidere") {
                                      final DocumentReference teamRef = db
                                          .collection('teams')
                                          .doc(cbUser.teamId);
                                      teamRef.update({"seatFiveSolved": true});
                                    } else {
                                      _dialogBuilder(context, "Wrong Answer");
                                    }
                                  },
                                  child: const StyledButtonText("Try"),
                                ),
                              ],
                              if (seatFiveSolved) ...[const Text("Bevidere")],
                            ],
                          ),
                        ),
                        Positioned(
                          left: centerX - 240,
                          top: 120,
                          child: Row(
                            children: [
                              if (!seatSixUnlocked) ...[
                                SizedBox(
                                  width: 100.0,
                                  child: TextFormField(
                                    controller: _seatSixPartOne,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: '...',
                                    ),
                                  ),
                                ),
                                StyledButton(
                                  onPressed: () {
                                    if (_seatSixPartOne.text == "Table") {
                                      final DocumentReference teamRef = db
                                          .collection('teams')
                                          .doc(cbUser.teamId);
                                      teamRef.update({"seatSixUnlocked": true});
                                    } else {
                                      _dialogBuilder(context, "Wrong Answer");
                                    }
                                  },
                                  child: const StyledButtonText("Try"),
                                ),
                              ],
                              if (seatSixUnlocked & !seatSixSolved) ...[
                                StyledButton(
                                  onPressed: () {
                                    _dialogBuilder(
                                      context,
                                      "A father of fame, but his sin was not mine,\n"
                                      "My virtue was strong, my heart was divine.\n"
                                      "The holiest relic was mine to claim,,\n"
                                      "The purest of knights, forever my name. Who am I?",
                                    );
                                  },
                                  child: const StyledButtonText("?"),
                                ),
                                SizedBox(
                                  width: 100.0,
                                  child: TextFormField(
                                    controller: _seatSixPartTwo,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: '...',
                                    ),
                                  ),
                                ),
                                StyledButton(
                                  onPressed: () {
                                    if (_seatSixPartTwo.text == "Galahad") {
                                      final DocumentReference teamRef = db
                                          .collection('teams')
                                          .doc(cbUser.teamId);
                                      teamRef.update({"seatSixSolved": true});
                                    } else {
                                      _dialogBuilder(context, "Wrong Answer");
                                    }
                                  },
                                  child: const StyledButtonText("Try"),
                                ),
                              ],
                              if (seatSixSolved) ...[const Text("Galahad")],
                            ],
                          ),
                        ),
                        // all seats solved
                        if (seatOneSolved &
                            seatTwoSolved &
                            seatThreeSolved &
                            seatFourSolved &
                            seatFiveSolved &
                            seatSixSolved) ...[
                          Positioned(
                            left: centerX - 60,
                            top: 250,
                            child: StyledButton(
                              onPressed: () {
                                final DocumentReference teamRef = db
                                    .collection('teams')
                                    .doc(cbUser.teamId);
                                teamRef.update({
                                  "roundTablePuzzleSolved": true,
                                });
                              },
                              child: const StyledButtonText("Solve"),
                            ),
                          ),
                        ],
                        if (roundTablePuzzleSolved) ...[
                          Positioned(
                            left: centerX - 60,
                            top: 300,
                            child: const Text("Round Table Puzzle Solved!"),
                          ),
                        ],
                      ],
                    );
                  },
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

  Future<void> _dialogBuilder(BuildContext context, String hintText) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hint'),
          content: Text(hintText),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
