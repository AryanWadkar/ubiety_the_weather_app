import 'package:flutter/material.dart';
import 'package:ubiety_the_weather_app/screens/loading_screen.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData().copyWith(
        colorScheme: ThemeData().colorScheme.copyWith(
          primary: Colors.black,
        ),
      ),
      home: LoadingScreen(),
    );
  }
}