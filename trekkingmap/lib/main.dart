import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:trekkingmap/constants/routes.dart';
import 'package:trekkingmap/firebase_options.dart';
import 'package:trekkingmap/services/auth/auth_service.dart';
import 'package:trekkingmap/views/login_view.dart';
import 'package:trekkingmap/views/notes/create_update_note_view.dart';
import 'package:trekkingmap/views/notes/notes_view.dart';
import 'package:trekkingmap/views/register_view.dart';
import 'package:trekkingmap/views/verify_email_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
        notesRoute: (context) => const NotesView(),
                createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),

      },
    ),
  );
}


// #############        HOME PAGE         #############
// #############        HOME PAGE         #############
//.
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  // @override
  // Widget build(BuildContext context) {  sn= ======
  // return RegisterView();


  @override
  Widget build(BuildContext context) {
    print(' ------- homepage ------- ');
    return FutureBuilder(
        future: AuthService.firebase().initialize(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
            final user = AuthService.firebase().currentUser;

            if (user != null){
              if (user.isEmailVerified){
                return const NotesView();
              } else {
                return const VerifyEmailView();
              }

            }else {
              return const LoginView();
            }
            default:
              return const CircularProgressIndicator();
          }
        });
  }
}

// #############        MENU ACTION        #############
// #############        MENU ACTION        #############
//.
enum MenuAction { logout }


// #############        SHOW LOGOUT DIALOG         #############
// #############        SHOW LOGOUT DIALOG         #############
//.

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sign out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('Cancel')),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Log out'),
            ),
          ],
        );
      }).then((value) => value ?? false);
}
