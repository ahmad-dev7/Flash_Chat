import 'package:firebase_core/firebase_core.dart';
import 'package:flash_chat_app/screens/chat_screen.dart';
import 'package:flash_chat_app/screens/login_screen.dart';
import 'package:flash_chat_app/screens/registeration_screen.dart';
import 'package:flash_chat_app/screens/welcome_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        'login': (context) => const LoginScreen(),
        'register': (context) => const RegisterationScreen(),
        'chat': (context) => const ChatScreen(),
      },
    ),
  );
}
