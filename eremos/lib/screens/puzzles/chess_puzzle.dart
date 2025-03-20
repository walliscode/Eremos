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

class ChessPuzzle extends StatefulWidget {
  const ChessPuzzle({super.key});

  @override
  _ChessPuzzleState createState() => _ChessPuzzleState();
}

class _ChessPuzzleState extends State<ChessPuzzle> {
  final TextEditingController _partOneAnswerController =
      TextEditingController();
  final TextEditingController _partTwoAnswerController =
      TextEditingController();
  bool partOneSolved = false;
  bool puzzleSolved = false;

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

                // set the part one solved status
                teamRef.get().then((DocumentSnapshot doc) {
                  final teamData = doc.data() as Map<String, dynamic>;
                  partOneSolved = teamData['chessPuzzlePartOneSolved'];
                  puzzleSolved = teamData['chessPuzzleSolved'];
                });
              });
            });

            return Scaffold(
              appBar: BaseAppBar(titleText: "Puzzle 1"),
              drawer: NavDrawer(isBenLoggedIn: value.isBenLoggedIn),
              body: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 16.0),
                    // display hints for first part of the puzzle
                    if (!partOneSolved) ...[
                      const Text(
                        'Tell me what game we are playing! the harder the hint the better the reward',
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 16.0),
                      StyledButton(
                        onPressed: () {
                          final hintText = "1<<6";
                          // display floating hint text
                          _dialogBuilder(context, hintText);
                        },
                        child: const StyledButtonText('Hard Hint'),
                      ),
                      const SizedBox(height: 15.0),
                      StyledButton(
                        onPressed: () {
                          final hintText = "The game of kings";
                          // display floating hint text
                          _dialogBuilder(context, hintText);
                        },
                        child: const StyledButtonText('Medium Hint'),
                      ),
                      const SizedBox(height: 15.0),
                      StyledButton(
                        onPressed: () {
                          final hintText =
                              "it's chess.....you're playing chess";
                          // display floating hint text
                          _dialogBuilder(context, hintText);
                        },
                        child: const StyledButtonText('Easy Hint'),
                      ),
                      const SizedBox(height: 16.0),
                      // text field for answer
                      SizedBox(
                        width: 200.0,
                        child: TextFormField(
                          controller: _partOneAnswerController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Enter your answer',
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),

                      // submit button
                      StyledButton(
                        onPressed: () async {
                          // Handle answer submission
                          final answer = _partOneAnswerController.text.trim();

                          if (answer.toLowerCase() == 'chess') {
                            // update the part to solved
                            final DocumentReference teamRef = db
                                .collection('teams')
                                .doc(cbUser.teamId);

                            teamRef.update({"chessPuzzlePartOneSolved": true});
                          }
                          // return a wrong answer message
                          else {
                            final hintText = "That's not the right answer";
                            // display floating hint text
                            _dialogBuilder(context, hintText);
                          }
                        },
                        child: const StyledButtonText('Submit'),
                      ),
                    ],

                    if (partOneSolved & !puzzleSolved) ...[
                      // hint button
                      StyledButton(
                        onPressed: () {
                          final hintText =
                              "The wise see many moves ahead, yet even the greatest must bow when their final hour arrives. Speak to me the killing blow";
                          // display floating hint text
                          _dialogBuilder(context, hintText);
                        },
                        child: const StyledButtonText('Hint'),
                      ),
                      const SizedBox(height: 16.0),

                      // chess board
                      SizedBox(
                        width:
                            300, // Adjust the size to scale down the chessboard
                        height: 300,
                        child: ChessBoard(teamRef: teamRef),
                      ),
                      const SizedBox(height: 16.0),

                      // text field for answer
                      SizedBox(
                        width: 200.0,
                        child: TextFormField(
                          controller: _partTwoAnswerController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Enter your answer',
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),

                      // submit button
                      StyledButton(
                        onPressed: () async {
                          // part two answer submission, if correct then the chess puzzle is solved
                          final answer = _partTwoAnswerController.text.trim();

                          if (answer.toLowerCase() == 'checkmate') {
                            // update the part to solved
                            final DocumentReference teamRef = db
                                .collection('teams')
                                .doc(cbUser.teamId);
                            teamRef.update({"chessPuzzleSolved": true});

                            setState(() {
                              puzzleSolved = true;
                            });
                          }
                          // return a wrong answer message
                          else {
                            final hintText = "That's not the right answer";
                            // display floating hint text
                            _dialogBuilder(context, hintText);
                          }
                        },
                        child: const StyledButtonText('Submit'),
                      ),
                    ],
                    if (puzzleSolved) ...[
                      const SizedBox(height: 16.0),
                      const Text('Proceed: ', style: TextStyle(fontSize: 20)),
                    ],
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

class ChessBoard extends StatefulWidget {
  final DocumentReference teamRef;

  const ChessBoard({super.key, required this.teamRef});

  @override
  _ChessBoardState createState() => _ChessBoardState();
}

class _ChessBoardState extends State<ChessBoard> {
  final List<String> _pieces = [
    '',
    '♔',
    '♕',
    '♖',
    '♗',
    '♘',
    '♙',
    '♚',
    '♛',
    '♜',
    '♝',
    '♞',
    '♟',
  ];
  final List<String?> _selectedPieces = List<String?>.filled(64, null);
  late Future<void> _loadFuture;

  @override
  void initState() {
    super.initState();
    _loadFuture = _loadChessBoardState();
  }

  Future<void> _loadChessBoardState() async {
    try {
      print("Fetching chessboard state from: ${widget.teamRef.path}");
      final DocumentSnapshot documentSnapshot = await widget.teamRef.get();

      if (documentSnapshot.exists) {
        final data = documentSnapshot.data() as Map<String, dynamic>;
        print(
          "Document Data: $data",
        ); // Debugging: Print Firestore document contents

        if (data.containsKey('chessPieces')) {
          final List<String?> loadedPieces = List<String?>.from(
            data['chessPieces'],
          );
          setState(() {
            for (int i = 0; i < _selectedPieces.length; i++) {
              _selectedPieces[i] = loadedPieces[i];
            }
          });
        } else {
          print("Error: 'pieces' field is missing in Firestore document.");
        }
      } else {
        print("Error: Document does not exist.");
      }
    } catch (e) {
      print("Firestore Error: $e");
    }
  }

  Future<void> _saveChessBoardState() async {
    try {
      await widget.teamRef.update({'chessPieces': _selectedPieces});
      print("Chessboard state saved successfully.");
    } catch (e) {
      print("Error saving chessboard state: $e");
    }
  }

  void _selectPiece(BuildContext context, int index) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select a Piece'),
          content: DropdownButton<String>(
            items:
                _pieces.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
            onChanged: (String? value) {
              setState(() {
                _selectedPieces[index] = value;
              });
              _saveChessBoardState(); // Save the state to Firestore
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _loadFuture,
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 8,
            ),
            itemCount: 64,
            itemBuilder: (BuildContext context, int index) {
              final int row = index ~/ 8;
              final int col = index % 8;
              final bool isWhite = (row + col) % 2 == 0;
              final String? piece = _selectedPieces[index];

              return GestureDetector(
                onTap: () {
                  _selectPiece(context, index);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isWhite ? Colors.white : Colors.black,
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Center(
                    child: Text(
                      piece ?? '',
                      style: TextStyle(
                        color: isWhite ? Colors.black : Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
