// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trekkingmap/constants/routes.dart';
import 'package:trekkingmap/services/auth/auth_service.dart';
import 'package:trekkingmap/services/auth/auth_user.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('verify email page ...'),
      ),
      body: Column(
        children: [
          const Text(
              "We've sent you an email verification. Please open it to verify your account."),
          const Text(
              "If you haven't received a verification email yet, press the button below"),
              TextButton(onPressed: () async{
                // final user = FirebaseAuth.instance.currentUser;
                await AuthService.firebase().sendEmailVerification();


              }, child: Text('send verification email')),
              TextButton(onPressed: ()async {
                await AuthService.firebase().logOut();
                Navigator.of(context).pushNamedAndRemoveUntil(registerRoute, (route) => false,);
              }, child: Text('restart'))
        ],
      ),
    );
  }
}
