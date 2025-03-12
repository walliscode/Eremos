// implement a base app bar for the app
// This can be used to create a consistent app bar across the app
// it will also contain a dropdown list of widgets to navigate to
//
//

import 'package:eremos/services/auth_service.dart';
import 'package:flutter/material.dart';

class BaseAppBar extends AppBar {
  // variables to pass to AppBar
  final String titleText;
  BaseAppBar({super.key, required this.titleText})
    : super(
        title: Text(titleText),
        backgroundColor: Colors.blue[500],
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              // sign out the user
              await AuthService.signOut();
            },
          ),
        ],
      );
}
