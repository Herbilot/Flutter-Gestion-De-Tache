import 'package:flutter/material.dart';

class butonL extends StatelessWidget {
  final Function()? onTap;

  const butonL({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          padding: EdgeInsets.all(25),
          margin: EdgeInsets.symmetric(horizontal: 25.0),
          decoration: BoxDecoration(
              color: Colors.black, borderRadius: BorderRadius.circular(8)),
          child: Center(
            child: Text(
              'Login',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          )),
    );
  }
}
