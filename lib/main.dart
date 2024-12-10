import 'package:flutter/material.dart';
import 'loginpage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Removes the debug banner
      title: 'Safe Space App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const LoginPage(), // Set the initial screen
    );
  }
}
