import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eremos/services/auth_service.dart';
import 'package:eremos/shared/styled_button.dart';
import 'package:flutter/material.dart';
import 'package:eremos/shared/styled_text.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // intro text
            const Center(
              child: StyledBodyText("Sign up to solve some puzzles!"),
            ),
            const SizedBox(height: 16.0),

            // username/email
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                return null;
              },
            ),
            // give some space with size box
            const SizedBox(height: 16.0),

            // password
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please make a password';
                }
                if (value.length < 8) {
                  return 'Password must be at least 8 chars long';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),

            // submit button
            StyledButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {}

                final String email = _emailController.text.trim();
                final String password = _passwordController.text.trim();

                final user = await AuthService.signUp(email, password);

                if (user != null) {
                  // create user object to add to cloud firestore
                  final dbUser = <String, dynamic>{
                    'teamId': null,
                    'displayName': null,
                  };
                  await _db
                      .collection('users')
                      .doc(user.uid)
                      .set(dbUser)
                      .onError(
                        (error, stackTrace) =>
                            print('Error adding user: $error'),
                      );
                }
              },
              child: const StyledButtonText('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
