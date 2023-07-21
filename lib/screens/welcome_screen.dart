import 'package:flash_chat_app/components/styled_buttons.dart';
import 'package:flash_chat_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  double values = 0;
  @override
  void initState() {
    super.initState();
    AnimationController controller = AnimationController(
      duration: const Duration(seconds: 1),
      upperBound: 60,
      vsync: this,
    );
    controller.forward();
    controller.addListener(() {
      setState(() {
        values = controller.value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xff0e1621),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: 'icon',
                    child: Image.asset(
                      'assets/images/flash_chat_icon.png',
                      width: values,
                    ),
                  ),
                  const SizedBox(width: 15),
                  DefaultTextStyle(
                    style: KWelcomeTextStyle,
                    child: AnimatedTextKit(
                      pause: const Duration(seconds: 1),
                      totalRepeatCount: 1,
                      animatedTexts: [TyperAnimatedText('Flash Chat')],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 31),
              StyledButtons(
                text: 'Login',
                color: const Color(0xff2b5278),
                onPressed: () {
                  Navigator.pushNamed(context, 'login');
                },
              ),
              StyledButtons(
                text: 'Register',
                color: const Color(0xff1f2936),
                onPressed: () {
                  Navigator.pushNamed(context, 'register');
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
