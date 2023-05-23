import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:groupe2/functions/note_echue_count.dart';
import 'package:groupe2/functions/note_en_cours_count.dart';
import 'package:groupe2/functions/note_pas_en_cours_count.dart';
import 'package:groupe2/functions/note_private_count.dart';
import 'package:groupe2/functions/note_public_count.dart';
import 'package:intl/intl.dart';
import 'package:groupe2/composants/cardTache.dart';
import 'package:groupe2/page/ajout_tache.dart';
import 'package:groupe2/page/signin.dart';
import 'package:groupe2/page/tacheDetails.dart';
import 'package:groupe2/services/auth-service.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class RepartPage extends StatefulWidget {
  const RepartPage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<RepartPage> {
  Service authClass = Service();
  firebase_auth.FirebaseAuth firebaseAuth = firebase_auth.FirebaseAuth.instance;
  List<Selectionner> selectionne = [];

  DateTime jour = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Liste des taches',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          CircleAvatar(
            backgroundImage: AssetImage('lib/images/honi.jpg'),
          ),
          SizedBox(
            height: 25,
          ),
          IconButton(
              onPressed: () async {
                await authClass.logOut();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (builder) => Login()),
                    (route) => false);
              },
              icon: Icon(
                Icons.logout,
              ))
        ],
        bottom: PreferredSize(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 22.0),
              child: Text(
                DateFormat('dd/MM/yyyy').format(jour),
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          preferredSize: Size.fromHeight(34),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 32,
              color: Colors.white,
            ),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (builder) => PageAjout()));
              },
              child: Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(colors: [
                      Color(0xff00aeef),
                      Color(0xff2d388a),
                    ])),
                child: Icon(
                  Icons.add,
                  size: 32,
                  color: Colors.white,
                ),
              ),
            ),
            label: 'Ajout',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
              size: 32,
              color: Colors.white,
            ),
            label: 'Réglages',
          ),
        ],
      ),
      body: Container(
        child: GridView.count(
          crossAxisCount: 2,
          padding: const EdgeInsets.all(20.0),
          childAspectRatio: 1.5,
          children: [
            FutureBuilder<int>(
              future: getPrivateNoteCount(firebaseAuth.currentUser!.uid),
              builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  int notePrivateCount = snapshot.data ?? 0;
                  return _buildCard(
                    'Nombre de tâches privées',
                    notePrivateCount,
                  );
                }
              },
            ),
            FutureBuilder<int>(
              future: getPublicNoteCount(firebaseAuth.currentUser!.uid),
              builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  int notePublicCount = snapshot.data ?? 0;
                  return _buildCard(
                    'Nombre de tâches publiques',
                    notePublicCount,
                  );
                }
              },
            ),
            FutureBuilder<int>(
              future: getNoteEnCoursCount(firebaseAuth.currentUser!.uid),
              builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  int noteEnCoursCount = snapshot.data ?? 0;
                  return _buildCard(
                    'Nombre de tâches en cours',
                    noteEnCoursCount,
                  );
                }
              },
            ),
            FutureBuilder<int>(
              future: getNotePasEnCoursCount(firebaseAuth.currentUser!.uid),
              builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  int notePasEnCoursCount = snapshot.data ?? 0;
                  return _buildCard(
                    'Nombre de tâches pas en cours',
                    notePasEnCoursCount,
                  );
                }
              },
            ),
            FutureBuilder<int>(
              future: getNoteEchueCount(firebaseAuth.currentUser!.uid),
              builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  int noteEchueCount = snapshot.data ?? 0;
                  return _buildCard(
                    'Nombre de tâches échues',
                    noteEchueCount,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void changementEtat(int index) {
    setState(() {
      selectionne[index].check = !selectionne[index].check;
    });
  }

  Widget _buildCard(String title, int count) {
    return Card(
      elevation: 3.0,
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              // Ajout du widget Expanded
              child: Text(
                title,
                style: const TextStyle(fontSize: 18.0),
              ),
            ),
            Text(
              count.toString(),
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
      color: Colors.white, // Ajout du fond bleu pour les cartes
    );
  }
}

class Selectionner {
  String id;
  bool check = false;
  Selectionner({required this.id, required this.check});
}
