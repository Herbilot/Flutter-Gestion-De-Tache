import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:groupe2/functions/ThemeModal.dart';
import 'package:groupe2/page/ajout_tache.dart';
import 'package:groupe2/page/home.dart';
import 'package:groupe2/page/signin.dart';
import 'package:groupe2/page/signup.dart';
import 'package:groupe2/serveur_distant/web_distant.dart';
import 'package:groupe2/services/auth-service.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.light);
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

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
        valueListenable: MyApp.themeNotifier,
        builder: (_, ThemeMode currentMode, __) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                colorScheme: ColorScheme.fromSwatch().copyWith(
                  primary: Color(0xff1040CC),
                ),
                scaffoldBackgroundColor: Color(0xff1040CC),
                bottomNavigationBarTheme: BottomNavigationBarThemeData(
                    backgroundColor: Color(0xff1040CC))),
            darkTheme: ThemeData.dark(),
            themeMode: currentMode,
            home: currentPage,
          );
        });
  }
}
