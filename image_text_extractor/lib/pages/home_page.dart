import 'package:flutter/material.dart';
import 'package:image_text_extractor/models/note_collection.dart';
import 'package:image_text_extractor/models/note_item.dart';
import 'package:image_text_extractor/pages/camera_view_page.dart';
import 'package:image_text_extractor/pages/extract_text_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  List<NoteItem> notes = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (!NoteCollection.initialized) {
      NoteCollection.initialize().then((_) => setState(() {
            notes = NoteCollection.notes;
          }));
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        notes = NoteCollection.notes;
      });
    });
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
      appBar: AppBar(
        title: const Text('Image Text Extractor'),
      ),
      body: createBody(),
      floatingActionButton: createFloatingActionButton(context),
    );
  }

  Center createBody() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: notes.map((note) {
          return ListTile(
            title: Text(note.title == '' ? 'No title' : note.title),
            subtitle: Text(note.content),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                NoteCollection.remove(note);
                setState(() {});
              },
            ),
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
          );
        }).toList(),
      ),
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
