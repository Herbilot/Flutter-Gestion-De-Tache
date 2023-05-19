import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Groupe2/page/home.dart';
import 'package:Groupe2/page/signin.dart';
import 'package:Groupe2/services/auth-service.dart';
import '../composants/bouttonRestore.dart';
import '../composants/champDeSaisie.dart';

class VerificationEmail extends StatefulWidget {
  const VerificationEmail({super.key});

  @override
  State<VerificationEmail> createState() => _VerificationEmailState();
}

class _VerificationEmailState extends State<VerificationEmail> {
  bool emailVerifie = false;
  bool envoiMailPossible = false;
  Timer? chrono;
  Service authClass = Service();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailVerifie = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!emailVerifie) {
      envoiEmail();
      chrono = Timer.periodic(
        Duration(seconds: 3),
        (_) => checkEmailVerife(),
      );
    }
  }

  void stopChrono() {
    chrono?.cancel();
    super.dispose();
  }

  void checkEmailVerife() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      emailVerifie = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (emailVerifie) chrono!.cancel();
  }

  void envoiEmail() async {
    try {
      final utilisateur = FirebaseAuth.instance.currentUser!;
      await utilisateur.sendEmailVerification();

      setState(() {
        envoiMailPossible = false;
      });
      await Future.delayed(Duration(minutes: 10));
      setState(() {
        envoiMailPossible = true;
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) => emailVerifie
      ? HomePage()
      : Scaffold(
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Color.fromARGB(255, 28, 64, 115),
            child: Padding(
              padding: const EdgeInsets.only(top: 90),
              child: Column(
                children: [
                  Text(
                    "Veillez verifier votre adresse email",
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    "Un email de verification a été envoyé à votre adresse ",
                    style: TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 206, 206, 206),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 45,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size.fromHeight(50),
                      ),
                      icon: Icon(
                        Icons.email,
                        size: 32,
                      ),
                      label: Text(
                        "Renvoyez le mail",
                        style: TextStyle(fontSize: 24),
                      ),
                      onPressed: envoiEmail,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextButton(
                      onPressed: () async {
                        await authClass.logOut();
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