import 'package:flutter/material.dart';
import 'package:image_text_extractor/models/note_collection.dart';
import 'package:image_text_extractor/models/note_item.dart';
import 'package:image_text_extractor/pages/camera_view_page.dart';
import 'package:image_text_extractor/pages/extract_text_page.dart';
import '../widgets/header_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (!NoteCollection.initialized) {
      NoteCollection.initialize().then((_) => setState(() {}));
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      NoteCollection.saveToStorage();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HeaderBar(title: 'Image Text Extractor'),
      body: SafeArea(
        child: Container(
          color: const Color(0xfff2f2f2),
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 80.0),
                  child: createBody(),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: createFloatingActionButton(context),
    );
  }

  Widget createBody() {
    return ListView(
      children: NoteCollection.notes.map((note) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(5),
          ),
          child: ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(note.title == '' ? 'No title' : note.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    _showConfirmationDialog(context, note);
                  },
                ),
              ],
            ),
            subtitle: Text(note.content),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ExtractTextPage(
                    imagePath: note.imagePath,
                    noteItem: note,
                  ),
                ),
              )
            },
          ),
        );
      }).toList(),
    );
  }

  void _showConfirmationDialog(BuildContext context, NoteItem note) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete the note "${note.title}"'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                NoteCollection.remove(note);
                setState(() {});
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

FloatingActionButton createFloatingActionButton(BuildContext context) {
  return FloatingActionButton(
    onPressed: () => {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CameraViewPage(),
        ),
      )
    },
    tooltip: 'Add new image',
    child: const Icon(Icons.add),
  );
}