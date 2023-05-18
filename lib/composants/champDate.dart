import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class champDate extends StatelessWidget {
  final dateControlleur;
  final String hintText;
  const champDate({
    super.key,
    required this.hintText,
    required this.dateControlleur,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: dateControlleur,
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.black,
            fontSize: 17,
          ),
        ),
        readOnly: true,
        onTap: () async {
          final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2022),
              lastDate: DateTime(2100));
          if (picked != null) {
            String formattedDate = DateFormat('dd/MM/yyyy').format(picked);
            dateControlleur.text = formattedDate;
          }
        },
      ),
    );
  }
}
