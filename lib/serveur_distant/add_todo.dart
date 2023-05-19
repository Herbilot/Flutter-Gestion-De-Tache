import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class AddTodoPage extends StatefulWidget {
  final Map? todo;
  const AddTodoPage({
    super.key,
    this.todo
  });

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  DateTime selectedDateTime = DateTime.now();
  TextEditingController _libelleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _date_debutController = TextEditingController();
  final TextEditingController _date_finController = TextEditingController();
  TextEditingController _categorieController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if(todo != null){
      isEdit = true;
      final title = todo['title'];
      final description = todo['description'];
      final libelle = todo['libelle'];
      final date_debut = todo['date_debut'];
      final date_fin = todo['date_fin'];
      final categorie = todo['categorie'];
      _libelleController.text = libelle;
      _descriptionController.text = description;
      _date_debutController.text =  DateFormat('dd-MM-yyyy').format(DateTime.parse(todo['date_debut']));
      _date_finController.text =  DateFormat('dd-MM-yyyy').format(DateTime.parse(todo['date_fin']));
      _categorieController.text = categorie;
    }
  }

  // DateTime selectedDateTime = DateTime.now();
  // TextEditingController _dateEcheanceController = TextEditingController();
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
      elevation: 0.1,
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        title: Text(
          isEdit ? 'Modification' : 'Ajout de tâche'
        )
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            controller: _libelleController,
            decoration: InputDecoration(
              hintText: "Titre"
            ),
          ),  
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(
              hintText: "Description"
            ),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 5,
          ),
          TextField(
            controller: _categorieController,
            decoration: InputDecoration(
              hintText: "Categorie"
            ),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 5,
          ),
          SizedBox(height: 20,),
          TextFormField(
                  readOnly: true,
                  controller: _date_debutController,
                  decoration: InputDecoration(
                    labelText: 'Date debut',
                  ),
                  onTap: () async {
                    await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2015),
                      lastDate: DateTime(2025),
                    ).then((selectedDate) {
                      if (selectedDate != null) {
                        selectedDateTime = selectedDate;
                        _date_debutController.text =
                          DateFormat('dd-MM-yyyy').format(selectedDate);
                      }
                    }
                  );
                },
              ),
              TextFormField(
                  readOnly: true,
                  controller: _date_finController,
                  decoration: InputDecoration(
                    labelText: 'Date fin',
                  ),
                  onTap: () async {
                    await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2015),
                      lastDate: DateTime(2025),
                    ).then((selectedDate) {
                      if (selectedDate != null) {
                        selectedDateTime = selectedDate;
                        _date_finController.text =
                          DateFormat('dd-MM-yyyy').format(selectedDate);
                      }
                    }
                  );
                },
              ),
              const SizedBox(
                height: 20,
              ),
          ElevatedButton(
            onPressed: isEdit ? updateData : submitData, 
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                isEdit ? "Modifier" : "Enregistrer"
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
              textStyle: TextStyle(
                fontSize: 20.0,
              )
            ),            
          ),
        ],
      ),
    );
  }

  Future<void> updateData() async{
    final todo = widget.todo;
    if(todo == null){
      return;
    }
    final id = todo['id'];
    final titre = _libelleController.text;
    final description = _descriptionController.text;
    final categorie = _categorieController.text;
    final date_debut = _date_debutController.text;
    final date_fin = _date_finController.text;
    final body = {
      "libelle" : libelle,
      "description" : description,
      "is_completed" : false,
      "dateEcheance" : dateEcheance,
    };
    final url = 'http://172.22.80.1:8000/api/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.put(
      uri, 
      body: jsonEncode(body),
      headers: {
        "Content-Type": "application/json"
      },
    );
      // Show success or fail
    if(response.statusCode == 200){
      showSuccessMessage("Modification réussie");
    }
    else{
      showErrorMessage("Modification echouée");
    }
  }

  Future<void> submitData() async{
    // Get data
    final titre = _titreController.text;
    final description = _descriptionController.text;
    final dateEcheance = _dateEcheanceController.text;
    final body = {
      "title" : titre,
      "description" : description,
      "is_completed" : false,
      "dateEcheance" : dateEcheance,
    };
    // Submit data
    final url = 'http://172.22.80.1:8000/api/v1/todos';
    final uri = Uri.parse(url);
    final response = await http.post(
      uri, 
      body: jsonEncode(body),
      headers: {
        "Content-Type": "application/json"
      },
    );

    // Show success or fail
    if(response.statusCode == 201){
      showSuccessMessage("Creation réussie");
      _titreController.text = '';
      _descriptionController.text = '';
      _dateEcheanceController.text = '';
    }
    else{
      showErrorMessage("Creation echouée");
    }
  }

  void showSuccessMessage(String message)
  {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  
  void showErrorMessage(String message)
  {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
} 