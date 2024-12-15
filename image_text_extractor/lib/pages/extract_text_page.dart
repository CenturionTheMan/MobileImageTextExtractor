
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image_text_extractor/models/note_collection.dart';
import 'package:image_text_extractor/models/note_item.dart';
import 'package:image_text_extractor/pages/display_picture_page.dart';
import 'package:image_text_extractor/pages/home_page.dart';
import 'package:image_text_extractor/widgets/header_bar.dart';

import '../utilities/ocr_utils.dart' as ocr;

class ExtractTextPage extends StatefulWidget {
  const ExtractTextPage({super.key, required this.imagePath, this.noteItem});
  final String imagePath;
  final NoteItem? noteItem;

  @override
  State<ExtractTextPage> createState() => _ExtractTextPageState();
}

class _ExtractTextPageState extends State<ExtractTextPage> {
  TextEditingController textEditingController = TextEditingController();
  NoteItem? noteItem;
  bool isLoading = true;
  bool noTextDetected = false;

  void _loadData() async {
    String extractedText = await ocr.requestImageToText(
        widget.imagePath, "pol"
    );

    if (extractedText.isEmpty) {
      setState(() {
        noTextDetected = true;
      });
      return;
    }

    setState(() {
      noteItem = NoteItem(
        title: '',
        content: extractedText,
        imagePath: widget.imagePath,
      );
      isLoading = false;
    });
    NoteCollection.add(noteItem!);
  }

  @override
  void initState() {
    super.initState();

    if (widget.noteItem == null) {
      _loadData();
    } else {
      noteItem = widget.noteItem!;
      textEditingController.text = noteItem!.title;
      isLoading = false;
    }

    textEditingController.addListener(() {
      noteItem!.title = textEditingController.text;
    });
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (noTextDetected) {
        File(widget.imagePath).delete();
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("No text detected!"))
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
            (route) => false,
        );
      }
    });
    if (isLoading) {
      return const Center(
          child: CircularProgressIndicator()
      );
    }

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
              (route) => false,
        );
      },
      canPop: false,
      child: Scaffold(
        appBar: HeaderBar(
          title: 'Extracted Text',
          actions: createNavigationButtons(context),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              createTitle(context),
              const SizedBox(height: 10),
              createTextSection(context),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox createTitle(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.95,
      child: TextField(
        controller: textEditingController,
        decoration: const InputDecoration(
          hintText: 'Title ...',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  List<Widget> createNavigationButtons(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          Clipboard.setData(ClipboardData(text: noteItem!.content));
          ScaffoldMessenger.of(context).showSnackBar(
            snackBarAnimationStyle: AnimationStyle(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            ),
            const SnackBar(
              content: Text('Text copied to clipboard'),
            ),
          );
        },
        icon: const Icon(Icons.copy),
      ),
      IconButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    DisplayPicturePage(imagePath: widget.imagePath)),
          );
        },
        icon: const Icon(Icons.image),
      )
    ];
  }

  Expanded createTextSection(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(5),
        ),
        child: SingleChildScrollView(
          child: Text(
            noteItem!.content,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
