import 'package:flutter/material.dart';
import 'package:image_text_extractor/models/note_collection.dart';
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
              // const HeaderBar(title: 'Image Text Extractor'),
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
        return ListTile(
          title: Text(note.title == '' ? 'No title' : note.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
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
