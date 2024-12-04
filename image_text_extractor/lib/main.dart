import 'package:flutter/material.dart';
import 'package:image_text_extractor/pages/home_page.dart';
import 'package:image_text_extractor/utilities/camera_utils.dart';

void main() {
  CameraUtils.initializeCamera();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Image text extractor',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const HomePage(),
    );
  }
}
