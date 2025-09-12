import 'package:flutter/material.dart';
import 'home_page.dart';

void main() {
  runApp(const SecuritySimApp());
}

class SecuritySimApp extends StatelessWidget {
  const SecuritySimApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Security Simulator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        fontFamily: 'Inter',
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}