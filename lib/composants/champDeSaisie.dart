import 'package:flutter/material.dart';

class champDeSaisie extends StatelessWidget {
  final controlleur;
  final String hintText;
  final bool obscureText;
  const champDeSaisie({
    super.key,
    required this.hintText,
    required this.controlleur,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: controlleur,
        obscureText: obscureText,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueGrey),
            ),
            fillColor: Colors.white,
            filled: true,
            hintText: hintText,
            helperStyle: TextStyle(color: Colors.grey[500])),
      ),
    );
  }
}
