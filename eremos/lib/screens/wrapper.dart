import 'package:flutter/material.dart';
import 'package:eremos/screens/home/home.dart';

// the Wrapper class is a StatelessWidget because it does not change based on user input
class Wrapper extends StatelessWidget {
  const Wrapper({super.key});
  @override
  Widget build(BuildContext context) {
    // return either Home or Authenticate widget
    // TODO: add logic to determine which widget to return
    return WelcomeScreen();
  }
}
