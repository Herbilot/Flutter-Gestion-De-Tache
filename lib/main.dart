import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:tp2/page/ajout_tache.dart';
import 'package:tp2/page/home.dart';
import 'package:tp2/page/signin.dart';
import 'package:tp2/page/signup.dart';
import 'package:tp2/services/auth-service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // firebase_auth.FirebaseAuth firebaseAuth = firebase_auth.FirebaseAuth.instance;
  Widget currentPage = Login();
  Service authClass = Service();
  @override
  void initState() {
    checkLogin();
    super.initState();
  }

  void checkLogin() async {
    String? token = await authClass.getToken();
    if (token != null) {
      currentPage = HomePage();
    }
  }
  // void connexion() async {
  //   try {
  //     await firebaseAuth.createUserWithEmailAndPassword(
  //         email: 'mamadev@herbidev.com', password: 'password123');

  //     await firebaseAuth.createUserWithEmailAndPassword(
  //         email: 'herbilot@herbidev.com', password: 'password123');

  //     await firebaseAuth.createUserWithEmailAndPassword(
  //         email: 'papadev@herbidev.com', password: 'password123');
  //   } on FirebaseException catch (e) {
  //     print(e);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: currentPage,
    );
  }
}
