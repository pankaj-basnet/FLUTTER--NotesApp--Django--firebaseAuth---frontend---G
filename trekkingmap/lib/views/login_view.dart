// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:trekkingmap/constants/routes.dart';
import 'package:trekkingmap/services/auth/auth_exceptions.dart';
import 'package:trekkingmap/services/auth/auth_service.dart';
import 'package:trekkingmap/services/auth/auth_user.dart';
import 'package:trekkingmap/utilities/show_error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('login page ...#@#');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page..'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'email',
            ),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: InputDecoration(
              hintText: 'password',
            ),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;

              try {
                print(
                    '-------------------- try block --- after FirebaseAuth.instance.signInWithEmailAndPassword');

                await AuthService.firebase().logIn(
                  email: email,
                  password: password,
                );
                final user = AuthService.firebase().currentUser;
                print('--- ${user?.isEmailVerified} ---');

                if (user?.isEmailVerified ?? false) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    notesRoute,
                    (route) => false,
                  );
                } else {
                  print('going to verify email page  ...#@##');

                  Navigator.of(context).pushNamedAndRemoveUntil(
                      verifyEmailRoute, (route) => false);
                }
                // self --------- code
                print(
                    'end of try block --- after FirebaseAuth.instance.signInWithEmailAndPassword');
              }on UserNotFoundAuthException{
                 await showErrorDialog(
                    context,
                    'User not found / invalid credential ...',
                  );
              } on WrongPasswordAuthException {
                await showErrorDialog(
                    context,
                    'Wrong credentials',
                  );

              } on GenericAuthException{
                await showErrorDialog(context, 'Authentication error');
              }
            },
            child: Text('Login here'),
          ),
          TextButton(
            onPressed: () {
              print('notesview try... #@#');
              Navigator.of(context).pushNamedAndRemoveUntil(
                registerRoute,
                (route) => false,
              );
            },
            child: const Text('Not registered yet? Register here!'),
          )
        ],
      ),
    );
  }
}

// login can take few minutes with firebase {mb= due to slow internet } amt=
