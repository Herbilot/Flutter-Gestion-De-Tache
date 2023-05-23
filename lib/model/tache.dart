import 'package:intl/intl.dart';

class Tache {
  int? id;
  String libelle;
  String description;
  String categorie;
  DateTime dateDebut;
  DateTime dateFin;
  String status;

  Tache({
    this.id,
    required this.libelle,
    required this.description,
    required this.categorie,
    required this.dateDebut,
    required this.dateFin,
    required this.status,
  });

  factory Tache.fromJson(Map<String, dynamic> json) {
    return Tache(
      id: json['id'],
      libelle: json['libelle'],
      description: json['description'],
      categorie: json['categorie'],
      dateDebut: DateFormat('yyyy-MM-dd HH:mm:ss').parse(json['date_debut']),
      dateFin: DateFormat('yyyy-MM-dd HH:mm:ss').parse(json['date_fin']),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'libelle': libelle,
        'description': description,
        'categorie': categorie,
        'date_debut': DateFormat('yyyy-MM-dd HH:mm:ss').format(dateDebut),
        'date_fin': DateFormat('yyyy-MM-dd HH:mm:ss').format(dateFin),
        'status': status,
      };
}
