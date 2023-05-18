// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:tp2/page/signin.dart';
import '../composants/bouttounLogo.dart';
import '../composants/bouttonSignUp.dart';
import '../composants/champDeSaisie.dart';
import 'home.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final utilisateurControlleur = TextEditingController();
  final mdpControlleur = TextEditingController();
  firebase_auth.FirebaseAuth firebaseAuth = firebase_auth.FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Color.fromARGB(255, 30, 119, 36),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            Text(
              "Inscription",
              style: TextStyle(
                fontSize: 35,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 100,
            ),
            Text(
              "Continuer  avec",
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,

              // ignore: prefer_const_literals_to_create_immutables
              children: [
                Center(child: Bouton(imagePath: 'lib/images/search.png')),
              ],
            ),
            SizedBox(height: 100),
            champDeSaisie(
              hintText: 'Nom d\'utilisateur',
              controlleur: utilisateurControlleur,
              obscureText: false,
            ),
            SizedBox(height: 20),
            champDeSaisie(
              hintText: 'Mot de passe',
              controlleur: mdpControlleur,
              obscureText: true,
            ),
            SizedBox(height: 50),
            buton(
              onTap: connexion,
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                Text(
                  "Vous avez déjà un compte?",
                  style: TextStyle(fontSize: 16),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (builder) => Login()),
                        (route) => false);
                  },
                  child: Text(
                    "Connexion",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 17,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 50,
            ),
            Text(
              "Copyright@DreamTeam2023",
              style: TextStyle(
                  fontSize: 12,
                  color: const Color.fromARGB(255, 255, 255, 255)),
            )
          ],
        ),
      )),
    );
  }

  void connexion() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
        email: utilisateurControlleur.text,
        password: mdpControlleur.text,
      );
      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (builder) => Login()),
        (route) => false,
      );
    } on FirebaseException catch (e) {
      final snackbar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }
}
