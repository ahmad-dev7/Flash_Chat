import 'package:flutter/material.dart';

class StyledTextField extends StatelessWidget {
  const StyledTextField({
    super.key,
    required this.obsecure,
    required this.text,
    required this.icon,
    required this.onChanged,
    required this.keyboardType,
  });
  final bool obsecure;
  final String text;
  final Icon icon;
  final Function(String) onChanged;
  final TextInputType? keyboardType;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 25, left: 20, right: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextFormField(
        keyboardType: keyboardType,
        onChanged: onChanged,
        obscureText: obsecure,
        style: const TextStyle(color: Colors.white, decorationThickness: 0),
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(20),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          hintText: text,
          hintStyle: const TextStyle(
            color: Colors.grey,
          ),
          prefixIcon: icon,
          prefixIconColor: const Color.fromARGB(255, 229, 250, 230),
        ),
      ),
    );
  }
}
