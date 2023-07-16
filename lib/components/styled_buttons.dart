import 'package:flutter/material.dart';

import '../constants.dart';

class StyledButtons extends StatelessWidget {
  const StyledButtons({
    super.key,
    required this.text,
    required this.color,
    required this.onPressed,
  });
  final String text;
  final Color color;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 30),
      height: 55,
      width: double.maxFinite,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: color,
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: KButtonTextStyle,
        ),
      ),
    );
  }
}
