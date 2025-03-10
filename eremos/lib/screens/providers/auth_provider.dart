import 'package:eremos/models/app_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// provide a stream for the app to consume
final authProvider = StreamProvider.autoDispose<AppUser?>((ref) async* {
  // subscribe to the auth state changes from firebase, this  will yield either a user or null
  final Stream<AppUser?> userStream = FirebaseAuth.instance
      .authStateChanges()
      .map((user) {
        if (user != null) {
          return AppUser(uid: user.uid, email: user.email!);
        }

        return null;
      });

  // YIELD that value whenever it changes
  await for (final user in userStream) {
    yield user;
  }
});
