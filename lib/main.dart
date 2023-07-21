// ignore_for_file: use_build_context_synchronously

import 'package:firebase_core/firebase_core.dart';
import 'package:flash_chat_app/screens/chat_screen.dart';
import 'package:flash_chat_app/screens/login_screen.dart';
import 'package:flash_chat_app/screens/registeration_screen.dart';
import 'package:flash_chat_app/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        'welcome': (context) => const WelcomeScreen(),
        'login': (context) => const LoginScreen(),
        'register': (context) => const RegisterationScreen(),
        'chat': (context) => const ChatScreen(),
      },
    ),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  double values = 0;
  @override
  void initState() {
    super.initState();
    AnimationController controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      upperBound: 80,
      vsync: this,
    );
    controller.forward();
    controller.addListener(() {
      setState(() {
        values = controller.value;
      });
    });
    Future.delayed(
      const Duration(milliseconds: 1001),
      () {
        checkCurrentUser();
      },
    );
  }

  void checkCurrentUser() async {
    User? user = await _auth.currentUser;
    if (user != null) {
      Navigator.pushReplacementNamed(context, 'chat');
    } else {
      Navigator.pushReplacementNamed(context, 'welcome');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        'assets/images/flash_chat_icon.png',
        width: values,
      ),
    );
  }
}
