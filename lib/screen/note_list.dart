import 'package:flutter/material.dart';
import 'package:note_keeper/db/note_db.dart';
import 'package:note_keeper/model/note.dart';
import 'package:note_keeper/screen/note_detail.dart';

class NoteList extends StatefulWidget {
  @override
  State<NoteList> createState() => NoteListState();
}

class NoteListState extends State<NoteList> {
  final Databasehelper databaseHelper = Databasehelper.instance;
  List<NoteModel> noteList = [];

  @override
  void initState() {
    super.initState();
    updateListView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'NOTES',
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 5,
            fontWeight: FontWeight.bold,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff6a11cb), Color(0xff2575fc)],
            ),
          ),
        ),
      ),
      body: noteList.isEmpty
          ? const Center(child: Text('No Notes Found'))
          : _buildListView(),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add Note',
        child: const Icon(Icons.add),
        onPressed: () {
          navigateToDetail('Add Note', NoteModel('', '', 2));
        },
      ),
    );
  }

  Widget _buildListView() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ListView.builder(
        itemCount: noteList.length,
        itemBuilder: (context, index) {
          final note = noteList[index];
      
          return Card(
            elevation: 2,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: getColorPriority(note.priority),
                child: const Icon(Icons.keyboard_arrow_right,color: Colors.black,fontWeight: FontWeight.bold,),
              ),
              title: Text(note.title),
              subtitle: Text(note.date),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.grey),
                onPressed: () => _deleteNote(note),
              ),
              onTap: () => navigateToDetail('Edit Note', note),
            ),
          );
        },
      ),
    );
  }

  Future<void> _deleteNote(NoteModel note) async {
    if (note.id == null) return;

    final result = await databaseHelper.deleteNote(note.id!);

    if (result > 0) {
      _showSnackBar('Note deleted successfully');
      updateListView();
    }
  }

  Future<void> navigateToDetail(String title, NoteModel note) async {
  final updated = await Navigator.push<bool>(
    context,
    MaterialPageRoute(builder: (_) => NoteDetail(title, note)),
  );

  if (updated ?? false) {
    updateListView();
  }
}


  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> updateListView() async {
    final notes = await databaseHelper.getNotes();
    setState(() => noteList = notes);
  }

  Color getColorPriority(int priority) {
    return priority == 1 ? Colors.green : Colors.white54;
  }
}
