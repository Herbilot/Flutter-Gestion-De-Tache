import 'package:flutter/material.dart';
import 'package:groupe2/page/home.dart';

class Splash extends StatefulWidget {
  Splash({super.key});

  @override
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    // _versPageHome();
  }

  _versPageHome() async {
    await Future.delayed(Duration(milliseconds: 1500), () {});
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 100,
              width: 100,
              color: Colors.white,
            ),
            Container(
              child: Text(
                "Powered by Groupe 2",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
