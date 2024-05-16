import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class Authentication {
  static Future<User?> signInWithGoogle(BuildContext context) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential =
            await auth.signInWithPopup(authProvider);

        user = userCredential.user;
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            _customSnackBar(
              context: context,
              content: 'Something went wrong...',
            ),
          );
        }
      }
    } else {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        try {
          final UserCredential userCredential =
              await auth.signInWithCredential(credential);

          user = userCredential.user;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                _customSnackBar(
                  context: context,
                  content:
                      'The account already exists with a different credential.',
                ),
              );
            }
          } else if (e.code == 'invalid-credential') {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                _customSnackBar(
                  context: context,
                  content:
                      'Error occurred while accessing credentials. Try again.',
                ),
              );
            }
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              _customSnackBar(
                context: context,
                content: 'Error occurred using Google Sign-In. Try again.',
              ),
            );
          }
        }
      }
    }

    return user;
  }

  static Future<User?> signInWithEmail(
      BuildContext context, String email, String password) async {
    User? user;
    try {
      final userCred = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      user = userCred.user;
    } on FirebaseAuthException catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          _customSnackBar(
            context: context,
            content: 'Wrong email or password.',
          ),
        );
      }
    }
    return user;
  }

  static Future<User?> signUpWithEmail(
      BuildContext context, String email, String password) async {
    User? user;
    try {
      final newUserCred = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      user = newUserCred.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            _customSnackBar(
              context: context,
              content: 'The password provided is too weak.',
            ),
          );
        }
      } else if (e.code == 'email-already-in-use') {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            _customSnackBar(
              context: context,
              content: 'The account already exists for that email.',
            ),
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            _customSnackBar(
              context: context,
              content: 'Not an email address.',
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          _customSnackBar(
            context: context,
            content: 'Error signing up. Try again.',
          ),
        );
      }
    }
    return user;
  }

  static Future<void> signOut(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      if (!kIsWeb) {
        await googleSignIn.signOut();
      }
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          _customSnackBar(
            context: context,
            content: 'Error signing out. Try again.',
          ),
        );
      }
    }
  }

  static SnackBar _customSnackBar(
      {required String content, required BuildContext context}) {
    return SnackBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      content: Text(
        content,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
      ),
    );
  }
}
