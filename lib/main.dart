import 'package:flutter/material.dart';
import 'package:notes/consts/colors.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notes',
      theme: ThemeData(
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: scaffoldBackgroundColor,
      ),
      home: HomePage(),
    );
  }
}