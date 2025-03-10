import 'package:eremos/shared/styled_button.dart';
import 'package:flutter/material.dart';

class ChessPuzzle extends StatefulWidget {
  const ChessPuzzle({super.key});

  @override
  _ChessPuzzleState createState() => _ChessPuzzleState();
}

class _ChessPuzzleState extends State<ChessPuzzle> {
  final TextEditingController _answerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Puzzle 1'),
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
            const SizedBox(height: 16.0),
            // hint button
            StyledButton(
              onPressed: () {
                // display floating hint text
                _dialogBuilder(context);
              },
              child: const StyledButtonText('Hint'),
            ),
            const SizedBox(height: 16.0),
            // chess board
            const SizedBox(
              width: 300, // Adjust the size to scale down the chessboard
              height: 300,
              child: ChessBoard(),
            ),
            const SizedBox(height: 16.0),
            // text field for answer
            TextField(
              controller: _answerController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter your answer',
              ),
            ),
            const SizedBox(height: 16.0),
            // submit button
            StyledButton(
              onPressed: () {
                // Handle answer submission
                print('Answer submitted: ${_answerController.text}');
              },
              child: const StyledButtonText('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _dialogBuilder(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Hint'),
        content: const Text(
          "The wise see many moves ahead, yet even the greatest must bow when their final hour arrives",
        ),
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

class ChessBoard extends StatefulWidget {
  const ChessBoard({super.key});
  @override
  _ChessBoardState createState() => _ChessBoardState();
}

class _ChessBoardState extends State<ChessBoard> {
  // list of chess pieces in ascii characters
  final List<String> _pieces = [
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

  // 64 elements to represent the currently selected piece for each tile
  final List<String?> _selectedPieces = List<String?>.filled(64, null);

  void _selectPiece(BuildContext context, int index) {
    // display dropdown with pieces
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
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // use GridView to create the 8x8 grid
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 8,
      ),
      itemBuilder: (BuildContext context, int index) {
        final int row = index ~/ 8;
        final int col = index % 8;
        final bool isWhite = (row + col) % 2 == 0;
        final String? piece = _selectedPieces[index];

        return GestureDetector(
          onTap: () {
            // display dropdown with pieces
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
      itemCount: 64,
    );
  }
}
