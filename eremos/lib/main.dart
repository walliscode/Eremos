import 'package:eremos/models/app_user.dart';

import 'package:eremos/screens/profile/profile.dart';
import 'package:eremos/screens/providers/auth_provider.dart';
import 'package:eremos/screens/puzzles/puzzles.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Eremos",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: Consumer(
        builder: (context, ref, child) {
          final AsyncValue<AppUser?> user = ref.watch(authProvider);

          return user.when(
            data: (value) {
              if (value == null) {
                return const PuzzleScreen();
              }
              return ProfileScreen(user: value);
            },
            error: (error, _) => const Text("error loading auth status...."),
            loading: () => const Text("loading..."),
          );
        },
      ),
    );
  }
}
