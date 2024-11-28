import 'dart:io';
import 'package:flutter/material.dart';

class DisplayPicturePage extends StatefulWidget {
  const DisplayPicturePage({super.key, required this.imagePath});

  final String imagePath;

  @override
  State<DisplayPicturePage> createState() => _DisplayPicturePageState();
}

class _DisplayPicturePageState extends State<DisplayPicturePage> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    _textEditingController.text = 'Extracted text';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Display Picture'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.file(File(widget.imagePath), fit: BoxFit.cover),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Retake picture'),
              ),
              ElevatedButton(
                onPressed: () {
                  //TODO go to next page, extract text, display extracted text with option to save as note and copy to clipboard....
                },
                child: const Text('Extract text'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
