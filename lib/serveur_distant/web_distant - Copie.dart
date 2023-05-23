import 'package:flutter/material.dart';
import 'package:groupe2/composants/cardTache.dart';
import 'package:groupe2/page/home.dart';
import 'package:groupe2/page/tacheDetails.dart';
import 'package:groupe2/serveur_distant/ajout_distant.dart';
import 'package:groupe2/services/tache_service.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

const url = 'http://192.168.0.106:5000/taches';

class Taches {
  final List taches;
  Taches({required this.taches});

  factory Taches.FromJson(Map<String, dynamic> json) {
    return Taches(taches: json['taches']);
  }
}

Future<Taches> list() async {
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    return Taches.FromJson(json.decode(response.body));
  } else {
    throw Exception("Une Erreur est survenue lors du chargement des taches");
  }
}

// void ajoutServeurDistant(String libelle, String description, String categorie,
//     String priorite, String date_debut, String date_fin) async {
//   final response = await http.post(
//     Uri.parse(url),
//     headers: <String, String>{
//       'Content-Type': 'application/json; chartset=UTF-8'
//     },
//     body: jsonEncode(<String, dynamic>{
//       'libelle': libelle,
//       'description': description,
//       'categorie': categorie,
//       'priorite': priorite,
//       'date_debut': date_debut,
//       'date_fin': date_fin
//     }),
//   );
// }

class ServeurDistant extends StatefulWidget {
  const ServeurDistant({super.key});

  @override
  State<ServeurDistant> createState() => _ServeurDistantState();
}

class _ServeurDistantState extends State<ServeurDistant> {
  late Future<Taches> listeDesTaches;
  List<Selectionner> selectionne = [];
  @override
  void initState() {
    super.initState();
    listeDesTaches = list();
    print("ceci es le print $listeDesTaches");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Serveur Distant'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (builder) => HomePage()));
              },
              child: Icon(
                Icons.home,
                size: 32,
                color: Colors.white,
              ),
            ),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => PageAjoutDistant()));
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
      body: FutureBuilder(
          future: TacheService().getTaches(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                final tache = snapshot.data?[index];
                IconData icon;
                Color couleurIcon;
                switch (tache?.categorie) {
                  case 'public':
                    icon = Icons.movie;
                    couleurIcon = Color(0xff35DA00);
                    break;
                  case 'Private':
                    icon = Icons.business;
                    couleurIcon = Color(0xffFB6E72);
                    break;

                  default:
                    icon = Icons.task;
                    couleurIcon = Color(0xffffffff);
                }
                selectionne.add(Selectionner(
                    id: snapshot.data![index].id.toString(), check: false));
                return InkWell(
                  onTap: () {},
                  child: CardTache(
                    libelleTache: tache!.libelle,
                    heure: '',
                    icon: icon,
                    couleurIcon: Colors.white,
                    bgIcon: couleurIcon,
                    coche: selectionne[index].check,
                    index: index,
                    changementEtat: changementEtat,
                  ),
                );
              },
            );
          }),
      // body: Container(
      //   child: Stack(
      //     children: <Widget>[
      //       FutureBuilder(
      //           future: listeDesTaches,
      //           builder: (context, AsyncSnapshot snapshot) {
      //             if (snapshot.hasData) {
      //               return ListView.builder(
      //                 shrinkWrap: true,
      //                 itemCount: snapshot.data.taches.length,
      //                 itemBuilder: (context, index) {
      //                   final item = snapshot.data?.taches[index]['libelle'];
      //                   return Dismissible(
      //                     key: UniqueKey(),
      //                     onDismissed: (direction) {
      //                       snapshot.data?.taches
      //                           .remove(snapshot.data?.taches[index]);
      //                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //                         content: Text('$item a été supprimé'),
      //                       ));
      //                       setState(() {
      //                         listeDesTaches = list();
      //                       });
      //                     },
      //                     background: Container(
      //                       color: Colors.red,
      //                     ),
      //                     child: ListTile(
      //                       title: Column(
      //                         crossAxisAlignment: CrossAxisAlignment.start,
      //                         children: <Widget>[
      //                           Text(
      //                             item,
      //                             style: TextStyle(fontWeight: FontWeight.bold),
      //                           ),
      //                           Text(
      //                               snapshot.data!.taches[index]['description'])
      //                         ],
      //                       ),
      //                     ),
      //                   );
      //                 },
      //               );
      //             } else if (snapshot.hasError) {
      //               return Text("${snapshot.error}");
      //             }
      //             return CircularProgressIndicator();
      //           }),
      //       // Align(child: FloatingActionButton(onPressed: () async{
      //       //   Navigator.push(context, MaterialPageRoute(builder: (context)=>AjoutDistant())).then((value)=> SetState()){
      //       //     listeDesTaches = list();
      //       //   };
      //       // }),)
      //     ],
      //   ),
      // ),
    );
  }

  void changementEtat(int index) {
    setState(() {
      selectionne[index].check = !selectionne[index].check;
    });
  }
}

class AjoutDistant extends StatefulWidget {
  const AjoutDistant({super.key});

  @override
  State<AjoutDistant> createState() => _AjoutDistantState();
}

class _AjoutDistantState extends State<AjoutDistant> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
