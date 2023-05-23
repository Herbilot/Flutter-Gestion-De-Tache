import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:groupe2/page/home.dart';
import 'package:groupe2/page/restore.dart';
import 'package:groupe2/page/signup.dart';
import 'package:groupe2/page/verification.dart';
import 'package:groupe2/services/auth-service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../composants/bouttounLogo.dart';
import '../composants/bouttonLogin.dart';
import '../composants/champDeSaisie.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Service authClass = Service();
  final utilisateurControlleur = TextEditingController();
  final mdpControlleur = TextEditingController();
  firebase_auth.FirebaseAuth firebaseAuth = firebase_auth.FirebaseAuth.instance;
  late String? authToken;

  @override
  void initState() {
    super.initState();
    checkAndAuthenticate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Color.fromARGB(255, 28, 64, 115),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Connexion",
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
                "Continuer avec",
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
              SizedBox(height: 25),
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  );
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (builder) => ResetPassword()),
                      (route) => false);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Mot de passe oublié?',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 50),
              butonL(
                onTap: connexionL,
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Pas encore de compte?",
                    style: TextStyle(fontSize: 16),
                  ),
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      );
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (builder) => Signup()),
                          (route) => false);
                    },
                    child: Text(
                      "Inscription",
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
                  color: const Color.fromARGB(255, 255, 255, 255),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> saveAuthToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('authToken', token);
  }

  Future<void> checkAndAuthenticate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('authToken');

    if (authToken != null) {
      try {
        firebase_auth.UserCredential userCredential =
            await firebaseAuth.signInWithCustomToken(authToken!);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (builder) =>
                  HomePage()), // Remplacez NextScreen par l'écran suivant de votre application
          (route) => false,
        );
      } catch (e) {
        // Une erreur s'est produite lors de la ré-authentification de l'utilisateur,
        // vous pouvez traiter l'erreur ou afficher un message d'erreur à l'utilisateur
      }
    }
  }

  Future<void> removeAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');
  }

  void connexionL() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    try {
      firebase_auth.UserCredential userCredential =
          await firebaseAuth.signInWithEmailAndPassword(
        email: utilisateurControlleur.text,
        password: mdpControlleur.text,
      );

      String token = userCredential.user?.uid ?? '';
      await saveAuthToken(token);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (builder) => VerificationEmail()),
        (route) => false,
      );
    } on FirebaseException catch (e) {
      final snackbar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }
}
