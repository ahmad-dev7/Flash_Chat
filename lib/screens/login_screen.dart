import 'package:flash_chat_app/components/styled_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat_app/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email = '';
  String password = '';
  bool progress = false;
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0e1621),
      body: ModalProgressHUD(
        inAsyncCall: progress,
        blur: 100,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Hero(
                  tag: 'icon',
                  child: Image.asset(
                    'assets/images/flash_chat_icon.png',
                    width: 130,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.all(20),
                child: TextFormField(
                  style: KTextFieldTextStyle,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    setState(() {
                      email = value;
                    });
                  },
                  decoration: KTextFieldDecoration.copyWith(
                      hintText: 'Enter your email',
                      prefixIcon: const Icon(Icons.email_outlined)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: TextFormField(
                  style: KTextFieldTextStyle,
                  onChanged: (value) {
                    setState(() {
                      password = value;
                    });
                  },
                  obscureText: true,
                  decoration: KTextFieldDecoration.copyWith(
                    hintText: 'Enter your password',
                    prefixIcon: const Icon(Icons.lock_clock_outlined),
                  ),
                ),
              ),
              StyledButtons(
                text: 'Login',
                color: Colors.blueAccent,
                onPressed: () async {
                  setState(() {
                    progress = true;
                  });
                  try {
                    final user = await _auth.signInWithEmailAndPassword(
                        email: email, password: password);
                    // ignore: unnecessary_null_comparison
                    if (user != null) {
                      // ignore: use_build_context_synchronously
                      Navigator.pushNamed(context, 'chat');
                    }
                  } catch (e) {
                    print(e);
                  }
                  setState(() {
                    progress = false;
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
