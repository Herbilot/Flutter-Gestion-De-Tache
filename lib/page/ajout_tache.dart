// ignore_for_file: unused_element

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tp2/composants/button.dart';
import 'package:tp2/composants/champDate.dart';
import 'package:tp2/composants/chipBox.dart';
import 'package:tp2/composants/label.dart';
import 'package:tp2/composants/textfield.dart';
import 'package:tp2/composants/texteArea.dart';
import 'package:intl/intl.dart';

class PageAjout extends StatefulWidget {
  PageAjout({super.key});

  @override
  State<PageAjout> createState() => _PageAjoutState();
}

class _PageAjoutState extends State<PageAjout> {
  final _libelleControlleur = TextEditingController();
  final _dateDebutControl = TextEditingController();
  final _dateFinControl = TextEditingController();
  final _descriptionControlleur = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String tachePriorite = "";
  String tacheCategorie = "";
  final _dateFin = TextEditingController();
  final _dateDebut = TextEditingController();
  void _Ajouter() {
    FirebaseFirestore.instance.collection('Tache').add({
      'date_fin': _dateFinControl.text,
      'date_debut': _dateDebutControl.text,
      'categorie': tacheCategorie,
      'description': _descriptionControlleur.text,
      'libelle': _libelleControlleur.text,
      'priorite': tachePriorite
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Color(0xff1040CC),
        ),
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
                      categorie('Divertissement', 0xff00FF00),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      categorie('Travail', 0Xffff6d6e),
                      SizedBox(
                        width: 12,
                      ),
                      categorie('Etude', 0xfff29732),
                      SizedBox(
                        width: 12,
                      ),
                      categorie('Famille', 0xff2bc8d9),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  SizedBox(height: 15),
                  label('Date début'),
                  SizedBox(height: 15),
                  champDate(
                    hintText: 'dd/mm/yyyy',
                    dateControlleur: _dateDebutControl,
                  ),
                  SizedBox(height: 15),
                  label('Date fin'),
                  SizedBox(height: 15),
                  champDate(
                    hintText: 'dd/mm/yyyy',
                    dateControlleur: _dateFinControl,
                  ),
                  SizedBox(height: 15),
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
