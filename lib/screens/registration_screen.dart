import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import '../components/rounded_button.dart';
import '../constants.dart';
import 'chat_screen.dart';
import 'login_screen.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';

  const RegistrationScreen({super.key});
  @override
  RegistrationScreenState createState() => RegistrationScreenState();
}

class RegistrationScreenState extends State<RegistrationScreen> {
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
                  child: SizedBox(
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
                title: 'Register',
                color: Colors.blueAccent,
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  try {
                    final UserCredential newUser = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                      email: email,
                      password: password,
                    );
                    if (newUser != null && context.mounted) {
                      Navigator.pushNamedAndRemoveUntil(
                          context, ChatScreen.id, (_) => false);
                    }
                  } on FirebaseAuthException catch (e) {
                    String errorMessage;
                    switch (e.code) {
                      case 'email-already-in-use':
                        errorMessage = 'The email address is already in use.';
                        break;
                      case 'invalid-email':
                        errorMessage = 'The email address is not valid.';
                        break;
                      case 'weak-password':
                        errorMessage = 'The password is too weak.';
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
                title: 'Log In',
                color: Colors.white,
                onPressed: () {
                  Navigator.pushReplacementNamed(context, LoginScreen.id);
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
