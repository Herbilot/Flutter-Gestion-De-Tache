import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/widgets.dart';
import 'package:switcher_button/switcher_button.dart';

import 'ThemeModal.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ThemeModal themeNotifier, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text(themeNotifier.isDark ? "DarkTheme" : "Light Theme"),
        ),
        body: Center(
            child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SwitcherButton(
              value: themeNotifier.isDark ? false : true,
              onChange: (value) {
                themeNotifier.isDark
                    ? themeNotifier.isDark = false
                    : themeNotifier.isDark = true;
              },
            ),
            Text('',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline4),
          ],
        )),
      );
    });
  }
}
