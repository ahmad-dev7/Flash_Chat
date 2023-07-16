// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

TextStyle KWelcomeTextStyle = const TextStyle(
  fontSize: 35,
  fontWeight: FontWeight.bold,
  color: Colors.white,
  fontFamily: 'sans-serif',
  letterSpacing: 2,
);

TextStyle KButtonTextStyle = const TextStyle(
  fontSize: 23,
  fontWeight: FontWeight.bold,
  color: Colors.white,
);

InputDecoration KTextFieldDecoration = InputDecoration(
  enabledBorder: OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.grey),
    borderRadius: BorderRadius.circular(20),
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(20),
  ),
  hintText: 'Enter value',
  hintStyle: const TextStyle(
    color: Colors.grey,
  ),
  prefixIcon: const Icon(Icons.chat),
  prefixIconColor: const Color.fromARGB(255, 229, 250, 230),
);

TextStyle KTextFieldTextStyle = const TextStyle(
  color: Colors.white,
  decorationThickness: 0,
);

BorderRadius KMessageBorder = const BorderRadius.only(
  bottomLeft: Radius.circular(30),
  bottomRight: Radius.circular(30),
);
