import 'package:flutter/material.dart';

class bouttonRestore extends StatelessWidget {
  final Function()? onTap;

  const bouttonRestore({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          padding: EdgeInsets.all(15),
          margin: EdgeInsets.symmetric(horizontal: 25.0),
          decoration: BoxDecoration(
              color: Colors.black, borderRadius: BorderRadius.circular(15)),
          child: Center(
            child: Text(
              'Réinitialiser',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          )),
    );
  }
}
