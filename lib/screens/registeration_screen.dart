import 'package:flutter/material.dart';
import '../components/styled_buttons.dart';
import 'package:flash_chat_app/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegisterationScreen extends StatefulWidget {
  const RegisterationScreen({super.key});

  @override
  State<RegisterationScreen> createState() => _RegisterationScreenState();
}

class _RegisterationScreenState extends State<RegisterationScreen> {
  Icon passwordVisibility = const Icon(Icons.visibility_off);
  Icon visibilityOff = const Icon(Icons.visibility_off);
  Icon visibilityOnn = const Icon(Icons.remove_red_eye);
  bool hidePassword = true;
  bool confirmPasswordEnabled = false;
  String errorText = '';
  String email = '';
  String password = '';
  String confirmPassword = '';
  bool progress = false;
  final _auth = FirebaseAuth.instance;

  // Future<void> registeration() async {
  //   final auth = FirebaseAuth.instance;
  //   auth.createUserWithEmailAndPassword(email: email, password: password);
  // }

  void togglePassword() {
    setState(() {
      if (hidePassword == true) {
        hidePassword = false;
        passwordVisibility = visibilityOnn;
      } else {
        hidePassword = true;
        passwordVisibility = visibilityOff;
      }
    });
  }

  bool checkPassword() {
    if (confirmPassword != '' && confirmPassword == password) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xff0e1621),
        body: ModalProgressHUD(
          inAsyncCall: progress,
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      email = value;
                    },
                    style: KTextFieldTextStyle,
                    decoration: KTextFieldDecoration.copyWith(
                      hintText: 'Enter your email',
                      prefixIcon: const Icon(Icons.email),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: TextFormField(
                    onChanged: (value) {
                      password = value;
                    },
                    style: KTextFieldTextStyle,
                    obscureText: hidePassword,
                    decoration: KTextFieldDecoration.copyWith(
                      hintText: 'Create password',
                      prefixIcon: const Icon(Icons.lock_outline_rounded),
                      suffixIcon: InkWell(
                        child: passwordVisibility,
                        onTap: () {
                          setState(() {
                            togglePassword();
                          });
                        },
                      ),
                      suffixIconColor: Colors.grey,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: TextFormField(
                    onChanged: (value) {
                      confirmPassword = value;
                    },
                    style: KTextFieldTextStyle,
                    obscureText: true,
                    decoration: KTextFieldDecoration.copyWith(
                      errorStyle: const TextStyle(
                        fontSize: 20,
                      ),
                      hintText: 'Confirm password',
                      prefixIcon: const Icon(Icons.lock),
                    ),
                  ),
                ),
                StyledButtons(
                  text: 'Register',
                  color: Colors.blueAccent,
                  onPressed: () async {
                    setState(() {
                      progress = true;
                    });
                    try {
                      final newUser =
                          await _auth.createUserWithEmailAndPassword(
                              email: email, password: password);
                      // ignore: unnecessary_null_comparison
                      if (newUser != null) {
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
      ),
    );
  }
}
