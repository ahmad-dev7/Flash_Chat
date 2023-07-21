// ignore_for_file: unnecessary_null_comparison, use_build_context_synchronously

import 'package:flash_chat_app/components/styled_text_field.dart';
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
  String userName = '';
  bool progress = false;
  final _auth = FirebaseAuth.instance;
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
                StyledTextField(
                  obsecure: false,
                  text: 'Enter your name',
                  icon: const Icon(Icons.person),
                  onChanged: (value) {
                    setState(() {
                      userName = value;
                    });
                  },
                  keyboardType: TextInputType.name,
                ),
                StyledTextField(
                  obsecure: false,
                  text: 'Enter your email',
                  icon: const Icon(Icons.email),
                  onChanged: (value) {
                    setState(() {
                      email = value;
                    });
                  },
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 10),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: TextFormField(
                    onChanged: (value) {
                      setState(() {
                        password = value;
                      });
                    },
                    style: KTextFieldTextStyle,
                    obscureText: hidePassword,
                    decoration: KTextFieldDecoration.copyWith(
                      hintText: 'Create password',
                      errorText: password.isNotEmpty
                          ? password.length < 6
                              ? 'Password must contain atleast 6 characters'
                              : null
                          : null,
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
                      setState(() {
                        confirmPassword = value;
                      });
                    },
                    style: KTextFieldTextStyle,
                    obscureText: true,
                    decoration: KTextFieldDecoration.copyWith(
                      errorText:
                          confirmPassword.isEmpty || confirmPassword.length < 4
                              ? null
                              : confirmPassword.isNotEmpty &&
                                      confirmPassword == password
                                  ? null
                                  : 'Password did\'nt matched',
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
                      if (password.length >= 6 &&
                          password == confirmPassword &&
                          userName.isNotEmpty) {
                        final newUser = await _auth
                            .createUserWithEmailAndPassword(
                                email: email, password: password)
                            .then((value) => _auth.currentUser);
                        _auth.currentUser!.updateDisplayName(userName);
                        if (newUser != null) {
                          Navigator.pushReplacementNamed(context, 'chat');
                        }
                      }
                      throw 'Something went wrong';
                    } catch (e) {
                      debugPrint('$e');
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
