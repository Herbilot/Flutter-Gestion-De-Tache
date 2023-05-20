import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

const url = 'http://192.168.0.108:5000/taches';

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

void ajout(String libelle, String description, String categorie,
    String priorite, String date_debut, String date_fin) async {
  final response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; chartset=UTF-8'
      },
      body: jsonEncode(<String, String>{
        'libelle': libelle,
        'description': description,
        'categorie': categorie,
        'priorite': priorite,
        'date_debut': date_debut,
        'date_fin': date_fin
      }));
}

class ServeurDistant extends StatefulWidget {
  const ServeurDistant({super.key});

  @override
  State<ServeurDistant> createState() => _ServeurDistantState();
}

class _ServeurDistantState extends State<ServeurDistant> {
  late Future<Taches> listeDesTaches;
  @override
  void initState() {
    super.initState();
    listeDesTaches = list();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Serveur Distant'),
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            FutureBuilder(
                future: listeDesTaches,
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        final item = snapshot.data?.taches[index]['libelle'];
                        return Dismissible(
                          key: UniqueKey(),
                          onDismissed: (direction) {
                            snapshot.data?.taches
                                .remove(snapshot.data?.taches[index]);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('$item a été supprimé'),
                            ));
                          },
                          background: Container(
                            color: Colors.red,
                          ),
                          child: ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  item,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                    snapshot.data!.taches[index]['description'])
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return CircularProgressIndicator();
                }),
            // Align(child: FloatingActionButton(onPressed: () async{
            //   Navigator.push(context, MaterialPageRoute(builder: (context)=>AjoutDistant())).then((value)=> SetState()){
            //     listeDesTaches = list();
            //   };
            // }),)
          ],
        ),
      ),
    );
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
