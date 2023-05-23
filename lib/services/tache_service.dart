import 'dart:convert';

import 'package:groupe2/model/tache.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class TacheService {
  final String apiUrl = "http://192.168.0.106:8080/api/v1";

  Future<List<Tache>> getTaches() async {
    var response = await http.get(Uri.parse("$apiUrl/taches"));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Tache> taches =
          body.map((dynamic item) => Tache.fromJson(item)).toList();
      return taches;
    } else {
      throw "Impossible de récupérer la liste des tâches.";
    }
  }

  Future<Tache> getTacheById(int id) async {
    var response = await http.get(Uri.parse("$apiUrl/taches/$id"));
    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      Tache tache = Tache.fromJson(body);
      return tache;
    } else {
      throw "Impossible de récupérer la tâche.";
    }
  }

  // Future<Tache> createTache(Tache tache) async {
  //   final response = await http.post(
  //     Uri.parse("$apiUrl/taches"),
  //     headers: {'Content-Type': 'application/json'},
  //     body: json.encode(tache.toJson()),
  //   );
  //   if (response.statusCode == 200) {
  //     Map<String, dynamic> body = jsonDecode(response.body);
  //     Tache createdTache = Tache.fromJson(body);
  //     return createdTache;
  //   } else {
  //     throw "Impossible de créer la tâche.";
  //   }
  // }

  Future<Tache> createTache(Tache tache) async {
    try {
      String formattedDateDebut = DateFormat('yyyy-MM-dd HH:mm:ss')
          .format(tache.dateDebut)
          .replaceAll(".000", "");
      String formattedDateFin = DateFormat('yyyy-MM-dd HH:mm:ss')
          .format(tache.dateFin)
          .replaceAll(".000", "");
      Map<String, dynamic> requestBody = {
        'libelle': tache.libelle,
        'description': tache.description,
        'categorie': tache.categorie,
        'status': tache.status,
        'date_debut': formattedDateDebut,
        'date_fin': formattedDateFin
      };
      print("***${requestBody['date_debut']}");

      final response = await http.post(
        Uri.parse("$apiUrl/taches"),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        Tache createdTache = Tache.fromJson(responseBody);
        updatePublicTachesCount();
        updatePrivateTachesCount();
        updatePasEnCoursTachesCount();
        updateEchueTachesCount();
        updateEnCoursTachesCount();

        return createdTache;
      } else {
        throw Exception("Impossible de créer la tâche.");
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Tache> updateTache(int id, Tache tache) async {
    final response = await http.put(
      Uri.parse("$apiUrl/taches/$id"),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(tache.toJson()),
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      Tache updatedTache = Tache.fromJson(body);
      return updatedTache;
    } else {
      throw "Impossible de mettre à jour la tâche.";
    }
  }

  Future<void> deleteTache(int id) async {
    final response = await http.delete(Uri.parse("$apiUrl/taches/$id"));
    if (response.statusCode != 204) {
      throw "Impossible de supprimer la tâche.";
    }
  }

  Future<int> updatePublicTachesCount() async {
    List<Tache> taches = await getTaches();

    int publicTachesCount =
        taches.where((tache) => tache.categorie == "public").toList().length;

    // Mettre à jour le compteur de tâches publiques dans la base de données
    // Si nécessaire, vous pouvez utiliser une requête HTTP pour effectuer la mise à jour.

    return publicTachesCount;
  }

  Future<int> getPublicTachesCount() async {
    List<Tache> taches = await getTaches();

    int publicTachesCount =
        taches.where((tache) => tache.categorie == "public").toList().length;

    return publicTachesCount;
  }

  Future<int> updatePrivateTachesCount() async {
    List<Tache> taches = await getTaches();

    int privateTachesCount =
        taches.where((tache) => tache.categorie == "private").toList().length;

    // Mettre à jour le compteur de tâches privées dans la base de données
    // Si nécessaire, vous pouvez utiliser une requête HTTP pour effectuer la mise à jour.

    return privateTachesCount;
  }

  Future<int> getPrivateTachesCount() async {
    List<Tache> taches = await getTaches();

    int privateTachesCount =
        taches.where((tache) => tache.categorie == "private").toList().length;

    return privateTachesCount;
  }

  Future<int> updatePasEnCoursTachesCount() async {
    List<Tache> taches = await getTaches();

    int pasEnCoursTachesCount =
        taches.where((tache) => tache.status == "pas en cours").toList().length;

    // Mettre à jour le compteur de tâches "pas en cours" dans la base de données
    // Si nécessaire, vous pouvez utiliser une requête HTTP pour effectuer la mise à jour.

    return pasEnCoursTachesCount;
  }

  Future<int> getPasEnCoursTachesCount() async {
    List<Tache> taches = await getTaches();

    int pasEnCoursTachesCount =
        taches.where((tache) => tache.status == "pas en cours").toList().length;

    return pasEnCoursTachesCount;
  }

  Future<int> updateEchueTachesCount() async {
    List<Tache> taches = await getTaches();

    int echueTachesCount =
        taches.where((tache) => tache.status == "échue").toList().length;

    // Mettre à jour le compteur de tâches "échue" dans la base de données
    // Si nécessaire, vous pouvez utiliser une requête HTTP pour effectuer la mise à jour.

    return echueTachesCount;
  }

  Future<int> getEchueTachesCount() async {
    List<Tache> taches = await getTaches();

    int echueTachesCount =
        taches.where((tache) => tache.status == "échue").toList().length;

    return echueTachesCount;
  }

  Future<int> updateEnCoursTachesCount() async {
    List<Tache> taches = await getTaches();

    int enCoursTachesCount =
        taches.where((tache) => tache.status == "en cours").toList().length;

    // Mettre à jour le compteur de tâches "en cours" dans la base de données
    // Si nécessaire, vous pouvez utiliser une requête HTTP pour effectuer la mise à jour.

    return enCoursTachesCount;
  }

  Future<int> getEnCoursTachesCount() async {
    List<Tache> taches = await getTaches();

    int enCoursTachesCount =
        taches.where((tache) => tache.status == "en cours").toList().length;

    return enCoursTachesCount;
  }

  //Rcuperer toutes les taches privates

  Future<List<Tache>> getPrivateTaches() async {
    List<Tache> taches = await getTaches();
    List<Tache> privateTaches =
        taches.where((tache) => tache.categorie == "private").toList();
    return privateTaches;
  }

//Rcuperer toutes les taches public

  Future<List<Tache>> getPublicTaches() async {
    List<Tache> taches = await getTaches();
    List<Tache> publicTaches =
        taches.where((tache) => tache.categorie == "public").toList();
    return publicTaches;
  }
}
