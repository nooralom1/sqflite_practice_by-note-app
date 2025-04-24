import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqflite_note_project/helper/database_helper.dart';
import 'package:sqflite_note_project/model/note_model.dart';
import 'dart:io';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final db = DatabaseHelper();
  List<Note> notes = [];
  String? _pickedImagePath;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  void _loadNotes() async {
    final data = await db.getNotes();
    setState(() => notes = data);
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _pickedImagePath = picked.path;
      });
    }
  }

  void _saveNote() async {
    if (_titleController.text.isNotEmpty) {
      await db.insertNote(Note(
        title: _titleController.text,
        content: _contentController.text,
        imagePath: _pickedImagePath,
      ));
      _titleController.clear();
      _contentController.clear();
      _pickedImagePath = null;
      _loadNotes();
    }
  }

  void _deleteNote(int id) async {
    await db.deleteNote(id);
    _loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Notes')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                TextField(controller: _titleController, decoration: const InputDecoration(labelText: 'Title')),
                TextField(controller: _contentController, decoration: const InputDecoration(labelText: 'Content')),
                Row(
                  children: [
                    ElevatedButton(onPressed: _pickImage, child: const Text('Pick Image')),
                    const SizedBox(width: 10),
                    if (_pickedImagePath != null)
                      Image.file(File(_pickedImagePath!), width: 50, height: 50, fit: BoxFit.cover),
                  ],
                ),
                ElevatedButton(onPressed: _saveNote, child: const Text('Add Note')),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return ListTile(
                  leading: note.imagePath != null
                      ? Image.file(File(note.imagePath!), width: 50, height: 50, fit: BoxFit.cover)
                      : null,
                  title: Text(note.title),
                  subtitle: Text(note.content),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteNote(note.id!),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
