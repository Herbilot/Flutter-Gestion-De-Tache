import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:groupe2/main.dart';
import 'package:groupe2/page/repart.dart';
import 'package:groupe2/page/signin.dart';
import 'package:groupe2/reserve/web_distant.dart';
import 'package:groupe2/services/auth-service.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    Service authClass = Service();
    firebase_auth.FirebaseAuth firebaseAuth =
        firebase_auth.FirebaseAuth.instance;

    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(''),
            accountEmail: Text(firebaseAuth.currentUser!.email.toString()),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image(
                  image: AssetImage(
                    'lib/images/honi.jpg',
                  ),
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.computer),
            title: Text('Serveur distant'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (builder) => ServeurDistant()));
            },
          ),
          ListTile(
            leading: Icon(Icons.numbers),
            title: Text('Compteurs'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (builder) => RepartPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notifications'),
            onTap: () {},
            trailing: ClipOval(
                child: Container(
              color: Colors.red,
              width: 20,
              height: 20,
              child: Center(
                child: Text(
                  '11',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            )),
          ),
          ListTile(
            leading: Icon(MyApp.themeNotifier.value == ThemeMode.light
                ? Icons.dark_mode
                : Icons.light_mode),
            title: Text(MyApp.themeNotifier.value == ThemeMode.light
                ? ('Mode sombre')
                : ('Mode light')),
            onTap: () {
              MyApp.themeNotifier.value =
                  MyApp.themeNotifier.value == ThemeMode.light
                      ? ThemeMode.dark
                      : ThemeMode.light;
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Se déconnecter'),
            onTap: () async {
              await authClass.logOut();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (builder) => Login()),
                  (route) => false);
            },
          ),
        ],
      ),
    );
  }
}
