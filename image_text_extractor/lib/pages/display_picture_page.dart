import 'dart:io';
import 'package:flutter/material.dart';

class DisplayPicturePage extends StatefulWidget {
  const DisplayPicturePage({super.key, required this.imagePath});

  final String imagePath;

  @override
  State<DisplayPicturePage> createState() => _DisplayPicturePageState();
}

class _DisplayPicturePageState extends State<DisplayPicturePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Display Picture'),
      ),
      body: Image.file(File(widget.imagePath)),
    );
  }
}
