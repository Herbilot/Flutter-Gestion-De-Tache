import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tp2/composants/bouttonRestore.dart';
import 'package:tp2/page/signin.dart';
import 'package:tp2/services/auth-service.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../composants/champDeSaisie.dart';
import 'home.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  Service authClass = Service();
  firebase_auth.FirebaseAuth firebaseAuth = firebase_auth.FirebaseAuth.instance;
  final utilisateurControlleur = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Color.fromARGB(255, 28, 64, 115),
        child: Padding(
          padding: const EdgeInsets.only(top: 100),
          child: Column(
            children: [
              Text(
                "Réinitialiser mot de passe",
                style: TextStyle(
                  fontSize: 35,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 100),
              champDeSaisie(
                hintText: 'Entrez votre email',
                controlleur: utilisateurControlleur,
                obscureText: false,
              ),
              SizedBox(
                height: 50,
              ),
              bouttonRestore(onTap: () async {
                showDialog(
                  context: context,
                  builder: (context) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                );
                try {
                  await firebaseAuth.sendPasswordResetEmail(
                      email: utilisateurControlleur.text);
                  // ignore: use_build_context_synchronously
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (builder) => Login()),
                      (route) => false);
                } on FirebaseException catch (e) {
                  final snackbar = SnackBar(content: Text(e.toString()));
                  ScaffoldMessenger.of(context).showSnackBar(snackbar);
                }
              }),
              SizedBox(
                height: 8,
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (builder) => Login()),
                        (route) => false);
                  },
                  child: Text(
                    "Annuler",
                    style: TextStyle(fontSize: 24),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
