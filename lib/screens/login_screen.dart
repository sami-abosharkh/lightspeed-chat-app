import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:lightspeed_chat/screens/registration_screen.dart';
import '../components/rounded_button.dart';
import '../constants.dart';
import 'chat_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showSpinner = false;
  late String email;
  late String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ProgressHUD(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              const SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                decoration:
                    kTextFieldDecoration.copyWith(hintText: 'Enter your email'),
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your password'),
              ),
              const SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                title: 'Log In',
                color: Colors.lightBlueAccent,
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  try {
                    final UserCredential user =
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: email,
                      password: password,
                    );
                    if (user != null && context.mounted) {
                      Navigator.pushNamedAndRemoveUntil(
                          context, ChatScreen.id, (_) => false);
                    }
                  } on FirebaseAuthException catch (e) {
                    String errorMessage;
                    switch (e.code) {
                      case 'user-not-found':
                        errorMessage = 'No user found for that email.';
                        break;
                      case 'wrong-password':
                        errorMessage = 'Wrong password provided.';
                        break;
                      case 'invalid-email':
                        errorMessage = 'The email address is not valid.';
                        break;
                      default:
                        errorMessage = 'An unknown error occurred.';
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(errorMessage),
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('An unknown error occurred.'),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  } finally {
                    setState(() {
                      showSpinner = false;
                    });
                  }
                },
                textColor: Colors.white,
              ),
              RoundedButton(
                title: 'Register',
                color: Colors.white,
                onPressed: () {
                  Navigator.pushReplacementNamed(
                      context, RegistrationScreen.id);
                },
                textColor: Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
