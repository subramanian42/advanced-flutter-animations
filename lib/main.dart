// import 'package:animations/simple_animations/example_1.dart';
import 'package:animations/simple_animations/example_2.dart';
import 'package:animations/simple_animations/example_3.dart';
import 'package:animations/simple_animations/example_4.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: HeroAnimation(),
    );
  }
}
