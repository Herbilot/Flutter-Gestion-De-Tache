import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groupe2/composants/button.dart';
import 'package:groupe2/composants/buttonUpdate.dart';
import 'package:groupe2/composants/chipBox.dart';
import 'package:groupe2/composants/label.dart';
import 'package:groupe2/composants/textfield.dart';
import 'package:groupe2/composants/texteArea.dart';
import 'package:groupe2/functions/note_echue_count.dart';
import 'package:groupe2/functions/note_en_cours_count.dart';
import 'package:groupe2/functions/note_pas_en_cours_count.dart';
import 'package:groupe2/functions/note_private_count.dart';
import 'package:groupe2/functions/note_public_count.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../composants/champDate.dart';

class TacheDetails extends StatefulWidget {
  final Map<String, dynamic> tache;
  final String id;

  TacheDetails({super.key, required this.tache, required this.id});

  @override
  State<TacheDetails> createState() => _TacheDetails();
}

class _TacheDetails extends State<TacheDetails> {
  late TextEditingController _libelleControlleur;
  late TextEditingController _descriptionControlleur;
  late TextEditingController _dateDebutControl;
  late TextEditingController _dateFinControl;
  late String tachePriorite;
  late String tacheCategorie;
  bool modifier = false;
  firebase_auth.FirebaseAuth firebaseAuth = firebase_auth.FirebaseAuth.instance;

  @override
  void initState() {
    _libelleControlleur = TextEditingController(text: widget.tache['libelle']);
    _descriptionControlleur =
        TextEditingController(text: widget.tache['description']);
    tachePriorite = widget.tache['priorite'];
    tacheCategorie = widget.tache['categorie'];
    _dateFinControl = TextEditingController(text: widget.tache['date_fin']);
    _dateDebutControl = TextEditingController(text: widget.tache['date_debut']);

    super.initState();
  }

  void _Modifier() {
    FirebaseFirestore.instance.collection('Tache').doc(widget.id).update({
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
        decoration: BoxDecoration(),
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(height: 45),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection('Tache')
                            .doc(widget.id)
                            .delete()
                            .then((value) {
                          Navigator.pop(context);
                        });
                        updateNoteEchueCount(firebaseAuth.currentUser!.uid);
                        updateNoteEnCoursCount(firebaseAuth.currentUser!.uid);
                        updateNotePasEnCoursCount(
                            firebaseAuth.currentUser!.uid);
                        updatePrivateNoteCount(firebaseAuth.currentUser!.uid);
                        updatePublicNoteCount(firebaseAuth.currentUser!.uid);
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                        size: 26,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          modifier = !modifier;
                        });
                      },
                      icon: Icon(
                        Icons.edit,
                        color: modifier ? Colors.blue : Colors.white,
                        size: 26,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 25,
                vertical: 5,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    modifier ? 'Modification tâche' : 'Details de la tache',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  label('Libellé'),
                  SizedBox(height: 15),
                  ChampDeTexte(
                    hintText: 'Libellé de la tache',
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
                  modifier ? butonUpdate(onTap: _Modifier) : Container()
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
      onTap: modifier
          ? () {
              setState(() {
                tachePriorite = label;
              });
            }
          : null,
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
      onTap: modifier
          ? () {
              setState(() {
                tacheCategorie = label;
              });
            }
          : null,
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
