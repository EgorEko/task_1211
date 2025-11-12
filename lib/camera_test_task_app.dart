import 'package:flutter/material.dart';
import 'features/home/screens/home_screen.dart';

class CameraTestTaskApp extends StatelessWidget {
  const CameraTestTaskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Camera test task',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomeScreen(),
    );
  }
}
