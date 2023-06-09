// ignore_for_file: unused_element

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groupe2/composants/button.dart';
import 'package:groupe2/composants/champDate.dart';
import 'package:groupe2/composants/chipBox.dart';
import 'package:groupe2/composants/label.dart';
import 'package:groupe2/composants/textfield.dart';
import 'package:groupe2/composants/texteArea.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:groupe2/functions/note_echue_count.dart';
import 'package:groupe2/functions/note_en_cours_count.dart';
import 'package:groupe2/functions/note_pas_en_cours_count.dart';
import 'package:groupe2/functions/note_private_count.dart';
import 'package:groupe2/functions/note_public_count.dart';
import 'package:groupe2/model/tache.dart';
import 'package:groupe2/serveur_distant/web_distant%20-%20Copie.dart';
import 'package:groupe2/services/tache_service.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class PageAjout extends StatefulWidget {
  PageAjout({super.key});

  @override
  State<PageAjout> createState() => _PageAjoutState();
}

class _PageAjoutState extends State<PageAjout> {
  final url = 'http://192.168.0.108:5000/taches';
  final _libelleControlleur = TextEditingController();
  final _dateDebutControl = TextEditingController();
  final _dateFinControl = TextEditingController();
  final _descriptionControlleur = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String tachePriorite = "";
  String tacheCategorie = "";
  final _dateFin = TextEditingController();
  final _dateDebut = TextEditingController();
  firebase_auth.FirebaseAuth firebaseAuth = firebase_auth.FirebaseAuth.instance;
  bool _checkDateValidity() {
    if (_dateDebut.text.isNotEmpty && _dateFin.text.isNotEmpty) {
      DateTime dateDebut = DateFormat('dd/MM/yyyy').parse(_dateDebut.text);
      DateTime dateFin = DateFormat('dd/MM/yyyy').parse(_dateFin.text);

      return dateDebut.isBefore(dateFin);
    }
    return true;
  }

  // void _Ajouter() async {
  //   print(_dateDebut.text);
  //   DateTime dateDebut = DateFormat('dd/MM/yyyy').parse(_dateDebut.text);
  //   print(dateDebut);
  //   DateTime dateFin = DateFormat('dd/MM/yyyy').parse(_dateFin.text);

  //   String status;
  //   DateTime currentDate = DateTime.now();

  //   if (dateDebut.isBefore(currentDate) && dateFin.isAfter(currentDate)) {
  //     status = 'en cours';
  //   } else if (dateDebut.isBefore(currentDate) &&
  //       dateFin.isBefore(currentDate)) {
  //     status = 'pas en cours';
  //   } else {
  //     status = 'échue';
  //   }

  //   TacheService().createTache(Tache(
  //       libelle: _libelleControlleur.text,
  //       description: _descriptionControlleur.text,
  //       categorie: tacheCategorie,
  //       dateDebut: dateDebut,
  //       dateFin: dateFin,
  //       status: status));

  //   Navigator.pop(context);
  // }

  void _Ajouter() async {
    if (!_checkDateValidity()) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Erreur de date'),
            content:
                Text('La date de début doit être antérieure à la date de fin.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }
    if (_libelleControlleur.text.isEmpty ||
        _descriptionControlleur.text.isEmpty ||
        tacheCategorie.isEmpty ||
        _dateDebut.text.isEmpty ||
        _dateFin.text.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Champs obligatoires'),
            content: Text('Veuillez remplir tous les champs obligatoires.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }
    DateTime dateDebut = DateFormat('dd/MM/yyyy').parse(_dateDebut.text);
    print(dateDebut);
    DateTime dateFin = DateFormat('dd/MM/yyyy').parse(_dateFin.text);

    String status;
    DateTime currentDate = DateTime.now();

    if (dateDebut.isBefore(currentDate) && dateFin.isAfter(currentDate)) {
      status = 'en cours';
    } else if (dateDebut.isBefore(currentDate) &&
        dateFin.isBefore(currentDate)) {
      status = 'échue';
    } else {
      status = 'pas en cours';
    }
    FirebaseFirestore.instance.collection('Tache').add({
      'date_fin': _dateDebut.text,
      'date_debut': _dateFin.text,
      'categorie': tacheCategorie,
      'description': _descriptionControlleur.text,
      'libelle': _libelleControlleur.text,
      'priorite': tachePriorite,
      'uid': firebaseAuth.currentUser!.uid,
      'status': status
    });

    updateNoteEchueCount(firebaseAuth.currentUser!.uid);
    updateNoteEnCoursCount(firebaseAuth.currentUser!.uid);
    updateNotePasEnCoursCount(firebaseAuth.currentUser!.uid);
    updatePrivateNoteCount(firebaseAuth.currentUser!.uid);
    updatePublicNoteCount(firebaseAuth.currentUser!.uid);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(),
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(height: 45),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    CupertinoIcons.arrow_left,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
                Text(
                  'Nouvelle tâche',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 25,
                vertical: 1,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  label('Libellé'),
                  SizedBox(height: 15),
                  ChampDeTexte(
                    hintText: 'Libellé de la tâche',
                    controlleur: _libelleControlleur,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  label('Priorité'),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      priorite('Urgent', 0XffFF3336),
                      SizedBox(
                        width: 12,
                      ),
                      priorite('Important', 0xff2664fa),
                      SizedBox(
                        width: 12,
                      ),
                      priorite('Plannifié', 0xfff4127ae),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  label('Description'),
                  SizedBox(
                    height: 12,
                  ),
                  TexteArea(
                    hintText: 'Description',
                    controlleur: _descriptionControlleur,
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  label('Catégorie'),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      categorie('Private', 0xff00FF00),
                      SizedBox(
                        width: 12,
                      ),
                      categorie('Public', 0xfff29732),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(height: 12),
                  label('Date début'),
                  SizedBox(height: 20),
                  champDate(
                    hintText: 'dd/mm/yyyy',
                    dateControlleur: _dateDebut,
                  ),
                  SizedBox(height: 40),
                  label('Date fin'),
                  SizedBox(height: 12),
                  champDate(
                    hintText: 'dd/mm/yyyy',
                    dateControlleur: _dateFin,
                  ),
                  SizedBox(height: 60),
                  buton(onTap: _Ajouter),
                  SizedBox(height: 15),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }

  Widget priorite(String label, int color) {
    return InkWell(
      onTap: () {
        setState(() {
          tachePriorite = label;
        });
      },
      child: Chip(
        backgroundColor: tachePriorite == label ? Colors.black : Color(color),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            10,
          ),
        ),
        label: Text(
          label,
          style: TextStyle(
            color: tachePriorite == label ? Colors.white : Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        labelPadding: EdgeInsets.symmetric(
          horizontal: 17,
          vertical: 3.8,
        ),
      ),
    );
  }

  Widget categorie(String label, int color) {
    return InkWell(
      onTap: () {
        setState(() {
          tacheCategorie = label;
        });
      },
      child: Chip(
        backgroundColor: tacheCategorie == label ? Colors.black : Color(color),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            10,
          ),
        ),
        label: Text(
          label,
          style: TextStyle(
            color: tacheCategorie == label ? Colors.white : Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        labelPadding: EdgeInsets.symmetric(
          horizontal: 17,
          vertical: 3.8,
        ),
      ),
    );
  }
}
