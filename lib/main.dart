import 'package:flutter/material.dart';
import 'package:wallscreeny/home_page.dart';

void main() => runApp(WallScreeny());

class WallScreeny extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wall Screeny App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: HomePage(),
    );
  }
}

