import 'package:eremos/shared/styled_button.dart';
import 'package:flutter/material.dart';

// the Puzzle "home" screen will contain access to all 3 puzzles
// successive puzzles will become available as the user completes the previous puzzle
// this will be done by using grayed out buttons for puzzles that are not yet available

class PuzzleScreen extends StatefulWidget {
  const PuzzleScreen({super.key});
  @override
  _PuzzleScreenState createState() => _PuzzleScreenState();
}

class _PuzzleScreenState extends State<PuzzleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Puzzles'),
        backgroundColor: Colors.blue[500],
        centerTitle: true,
      ),
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
                // navigate to puzzle 1 screen
              },
              child: const StyledButtonText('Puzzle 1'),
            ),
            const SizedBox(height: 16.0),
            // puzzle 2
            StyledButton(
              onPressed: () {
                // navigate to puzzle 2 screen
              },
              child: const StyledButtonText('Puzzle 2'),
            ),
            const SizedBox(height: 16.0),
            // puzzle 3
            StyledButton(
              onPressed: () {
                // navigate to puzzle 3 screen
              },
              child: const StyledButtonText('Puzzle 3'),
            ),
          ],
        ),
      ),
    );
  }
}
