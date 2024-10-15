// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart'; // {sn= @immutable annotation or class Immutable in material.dart}
import 'package:flutter/foundation.dart'; // isn {sn= @immutable annotation or class Immutable in foundation.dart}

@immutable
class AuthUser {
  final String id;
  final String email;

  final bool isEmailVerified;
  // const bool isEmailVerified = false; // error if "const" put --- vscode -->  Only static fields can be declared as const. // declaring the filed as final or add "static" keyword ..

  const AuthUser({
    required this.id,
    required this.email,
    required this.isEmailVerified,
  });

  factory AuthUser.fromFirebase(User user) => AuthUser(
        id: user.uid,
        email: user.email!,
        isEmailVerified: user.emailVerified,
      );

  // const AuthUser({
  //    this.isEmailVerified,  //  error if "named parameter" put --- vscode -->    The parameter 'isEmailVerified' can't have a value of 'null' because of it type, but the implicit default value is 'null'. default value or 'required' modifier
  // });
}
