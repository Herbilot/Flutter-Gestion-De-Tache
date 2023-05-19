import 'package:flutter/material.dart';
import 'package:Groupe2/services/auth-service.dart';

class Bouton extends StatelessWidget {
  final String imagePath;

  const Bouton({super.key, required this.imagePath});
  @override
  Widget build(BuildContext context) {
    Service authClass = Service();
    return InkWell(
      onTap: () async => {await authClass.googleSignin(context)},
      child: Container(
        // ignore: prefer_const_constructors
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white,
            ),
            borderRadius: BorderRadius.circular(16),
            color: Colors.grey[200]),
        child: Image.asset(
          imagePath,
          height: 40,
        ),
      ),
    );
  }
}
