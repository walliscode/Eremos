// implemenet a navigation drawer than can be used in all screens
//

import 'package:eremos/screens/home/home.dart';
import 'package:eremos/screens/puzzles/puzzles.dart';
import 'package:flutter/material.dart';

// create a destination class to hold the title and navigation route
// this will create ListTile for each destination

class Destination {
  final String title;
  final Widget destination;
  Destination({required this.title, required this.destination});
}

class NavDrawer extends StatelessWidget {
  static final List<Destination> allDestinations = <Destination>[
    Destination(title: 'Home', destination: WelcomeScreen()),
    Destination(title: 'Puzzles', destination: PuzzleScreen()),
  ];

  const NavDrawer({super.key});
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children:
            allDestinations.map((Destination destination) {
              return ListTile(
                title: Text(destination.title),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => destination.destination,
                    ),
                  );
                },
              );
            }).toList(),
      ),
    );
  }
}
