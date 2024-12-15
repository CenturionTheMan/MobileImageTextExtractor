import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_text_extractor/pages/extract_text_page.dart';
import '../widgets/header_bar.dart';

class DisplayPicturePreExtractionPage extends StatefulWidget {
  const DisplayPicturePreExtractionPage({super.key, required this.imagePath});

  final String imagePath;

  @override
  State<DisplayPicturePreExtractionPage> createState() =>
      _DisplayPicturePreExtractionPageState();
}

class _DisplayPicturePreExtractionPageState
    extends State<DisplayPicturePreExtractionPage> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    _textEditingController.text = 'Extracted text';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HeaderBar(title: 'Confirm Picture'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Image.file(
                File(widget.imagePath),
                fit: BoxFit.scaleDown,
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ExtractTextPage(
                              imagePath: widget.imagePath,
                            ),
                      ),
                    );
                  },
                  child: const Text('Extract text'),
                ),
              ],
            ),
          ),
          ],
        ),
      ),
    );
  }
}