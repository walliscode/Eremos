import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StyledButton extends StatelessWidget {
  const StyledButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.isEnabled = true,
  });

  final void Function()? onPressed;
  final bool isEnabled;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        // change the background color of the button depending on the value of isEnabled
        backgroundColor: isEnabled ? Colors.blue : Colors.grey,
        foregroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
      ),
      onPressed: isEnabled ? onPressed : null,
      child: child,
    );
  }
}

class StyledButtonText extends StatelessWidget {
  const StyledButtonText(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        textStyle: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
