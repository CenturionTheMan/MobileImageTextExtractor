import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:image_text_extractor/models/note_item.dart';

class NoteCollection {
  static late String path;
  static List<NoteItem> notes = [];
  static bool initialized = false;

  NoteCollection();

  static Future<void> initialize() async {
    final directory = await getApplicationDocumentsDirectory();
    path = '${directory.path}/notes.json';
    loadFromStorage();
    initialized = true;
  }

  static void add(NoteItem note) {
    notes.add(note);
  }

  static void remove(NoteItem note) {
    notes.remove(note);
  }

  static void removeAt(int index) {
    notes.removeAt(index);
  }

  static void update(int index, NoteItem note) {
    if (index >= 0 && index < notes.length) {
      notes[index] = note;
    }
  }

  static Future<void> saveToStorage() async {
    if (!initialized) return;
    if (notes.isEmpty) {
      return;
    }
    try {
      final file = File(path);
      final json = jsonEncode(notes.map((e) => e.toJson()).toList());
      await file.writeAsString(json);
    } catch (e) {
      print('Error saving notes: $e');
    }
  }

  static void loadFromStorage() {
    try {
      final file = File(path);
      if (file.existsSync()) {
        final json = file.readAsStringSync();
        final List<dynamic> data = jsonDecode(json);
        notes = data.map((e) => NoteItem.fromJson(e)).toList();
      }
      initialized = true;
    } catch (e) {
      print('Error loading notes: $e');
    }
  }
}
