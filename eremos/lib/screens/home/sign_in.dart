import 'package:eremos/models/app_user.dart';
import 'package:eremos/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:eremos/shared/styled_text.dart';
import 'package:eremos/shared/styled_button.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _errorFeedback;

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
            const Center(child: StyledBodyText("Sign in with your User Name!")),
            const SizedBox(height: 16.0),

            // email address
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'User Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a user name';
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
                  return 'Please enter your password';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            // error feedback
            if (_errorFeedback != null)
              Text(_errorFeedback!, style: const TextStyle(color: Colors.red)),

            // submit button
            StyledButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    _errorFeedback = null;
                  });

                  final String email = _emailController.text.trim();
                  final String password = _passwordController.text.trim();

                  final AppUser? user = await AuthService.signIn(
                    email,
                    password,
                  );

                  if (user == null) {
                    setState(() {
                      _errorFeedback = 'Invalid credentials';
                    });
                  }
                }
              },
              child: const StyledButtonText('Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}
