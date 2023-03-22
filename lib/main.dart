import 'package:cardproject/screens/homeScreen.dart';
import 'package:cardproject/utils/ColrosConstants.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: COLORPRIMERY,
        scaffoldBackgroundColor: COLORBACKGROUND,
        fontFamily: 'Poppins',
        textTheme: const TextTheme(
          bodyText1: TextStyle(color: COLORTEXT),
          bodyText2: TextStyle(color: COLORTEXT),
        ),
      ),
      home: const HomePage(),
    );
  }
}
