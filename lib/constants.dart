// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

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

TextStyle KAlertButtonTextStyle = const TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontSize: 15,
);

AlertStyle KAlertStyle = AlertStyle(
  alertElevation: 5,
  alertPadding: const EdgeInsets.all(0),
  alertAlignment: Alignment.center,
  isCloseButton: false,
  isOverlayTapDismiss: false,
  backgroundColor: const Color(0xff001522),
  titleStyle: const TextStyle(color: Colors.blueGrey),
  descStyle: TextStyle(color: Colors.blue[700]),
  animationType: AnimationType.grow,
);

Icon KEyeClose = const Icon(Icons.visibility_off, color: Colors.grey);
Icon KEyeOpen = const Icon(Icons.remove_red_eye, color: Colors.grey);

Alert KAlertDialogBox({
  required context,
  required String titleText,
  required String descriptionText,
  required String buttonText,
  required Function() onPressed,
  required Color buttonColor,
}) {
  return Alert(
    style: KAlertStyle,
    context: context,
    title: titleText,
    desc: descriptionText,
    buttons: [
      DialogButton(
        color: Colors.blueGrey,
        child: Text('Cancel', style: KAlertButtonTextStyle),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      DialogButton(
        color: buttonColor,
        onPressed: onPressed,
        child: Text(buttonText, style: KAlertButtonTextStyle),
      )
    ],
  );
}

Container drawerButtons({
  required String text,
  required Function() onPressed,
  Color? color,
}) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 15),
    width: double.maxFinite,
    height: 45,
    child: ElevatedButton(
      style:
          ElevatedButton.styleFrom(backgroundColor: color ?? Colors.blueGrey),
      onPressed: onPressed,
      child: Text(text),
    ),
  );
}
