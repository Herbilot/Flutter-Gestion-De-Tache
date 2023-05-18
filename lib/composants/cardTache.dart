import 'package:flutter/material.dart';

class CardTache extends StatelessWidget {
  final String libelleTache;
  final IconData icon;
  final Color couleurIcon;
  final Color bgIcon;
  final String heure;
  final bool coche;
  final Function? changementEtat;
  final Function? onChanged;
  final int index;

  const CardTache(
      {super.key,
      required this.libelleTache,
      required this.icon,
      required this.couleurIcon,
      required this.heure,
      required this.bgIcon,
      required this.coche,
      this.changementEtat,
      required this.index,
      this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Theme(
            child: Transform.scale(
              scale: 1.5,
              child: Checkbox(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    5,
                  ),
                ),
                activeColor: Color(0xffffffff),
                checkColor: Color(0xff000000),
                value: coche,
                onChanged: (bool? value) {
                  changementEtat!(index);
                },
              ),
            ),
            data: ThemeData(
              primarySwatch: Colors.blue,
              unselectedWidgetColor: Color(0xffffffff),
            ),
          ),
          Expanded(
            child: Container(
              height: 72,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: Color(0xff181823),
                child: Row(
                  children: [
                    SizedBox(
                      width: 15,
                    ),
                    Container(
                      height: 33,
                      width: 36,
                      decoration: BoxDecoration(
                        color: bgIcon,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(icon),
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    Expanded(
                      child: Text(
                        libelleTache,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    Text(
                      heure,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
