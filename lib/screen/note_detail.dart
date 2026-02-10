import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_keeper/db/note_db.dart';
import 'package:note_keeper/model/note.dart';

// ignore: must_be_immutable
class NoteDetail extends StatefulWidget {
  final String appbarTitle;
  final NoteModel note;
  NoteDetail(this.appbarTitle, this.note);

  @override
  State<StatefulWidget> createState() {
    return NoteDetailState(appBarTitle: this.appbarTitle, note: this.note);
  }
}

class NoteDetailState extends State<NoteDetail> {
  Databasehelper databasehelper = Databasehelper.instance;
  static var _priorities = ['High', 'Low'];
  String appBarTitle;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  NoteModel note;
  NoteDetailState({required this.appBarTitle, required this.note});
  void initState() {
    super.initState();
    titleController.text = note.title;
    descriptionController.text = note.description;
  } 
  @override
  Widget build(BuildContext context) {
    // TextStyle textStyle = Theme.of(context).textTheme.title;
    

    return Scaffold(
      appBar: AppBar(title: Text(appBarTitle)),

      body: Padding(
        padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
        child: ListView(
          children: <Widget>[
            // First element
            ListTile(
              title: DropdownButton(
                items: _priorities.map((String dropDownStringItem) {
                  return DropdownMenuItem<String>(
                    value: dropDownStringItem,
                    child: Text(dropDownStringItem),
                  );
                }).toList(),

                // style: textStyle,
                value: getPriorityAsString(note.priority),

                onChanged: (valueSelectedByUser) {
                  setState(() {
                    debugPrint('User selected $valueSelectedByUser');
                    updatePriorityAsInt(valueSelectedByUser!);
                  });
                },
              ),
            ),

            // Second Element
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextField(
                controller: titleController,
                // style: textStyle,
                onChanged: (value) {
                  debugPrint('Something changed in Title Text Field');
                  updateTitle();
                },
                decoration: InputDecoration(
                  labelText: 'Title',
                  // labelStyle: textStyle,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),

            // Third Element
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextField(
                controller: descriptionController,
                // style: textStyle,
                onChanged: (value) {
                  debugPrint('Something changed in Description Text Field');
                  updateDescription();
                },
                decoration: InputDecoration(
                  labelText: 'Description',
                  // labelStyle: textStyle,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),

            // Fourth Element
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xff6a11cb), Color(0xff2575fc)],
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.transparent,
                        ),
                        child: Text(
                          'Save',
                          textScaleFactor: 1.5,
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          setState(() {
                            debugPrint("Save button clicked");
                            _save();
                          });
                        },
                      ),
                    ),
                  ),

                  Container(width: 5.0),

                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xff6a11cb), Color(0xff2575fc)],
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.transparent,
                        ),
                        child: Text(
                          'Delete',
                          textScaleFactor: 1.5,
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          setState(() {
                            debugPrint("Delete button clicked");
                            _delete();
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void updatePriorityAsInt(String value) {
    switch (value) {
      case 'High':
        note.priority = 1;
        break;
      case 'Low':
        note.priority = 2;
        break;
    }
  }

  String getPriorityAsString(int value) {
    String priority = '';
    switch (value) {
      case 1:
        priority = _priorities[0];
        break;
      case 2:
        priority = _priorities[1];
        break;
    }
    return priority;
  }

  void updateTitle() {
    note.title = titleController.text;
  }

  void updateDescription() {
    note.description = descriptionController.text;
  }

 Future<void> _save() async {
  note.title = titleController.text;
  note.description = descriptionController.text;
  note.date = DateFormat.yMMMd().format(DateTime.now());

  try {
    final int result = note.id == null
        ? await databasehelper.insertNote(note.toMap())
        : await databasehelper.updateNote(note.toMap());

    if (result > 0) {
      Navigator.pop(context, true);
    } else {
      _showAlertDialog('Status', 'Problem saving note');
    }
  } catch (e) {
    _showAlertDialog('Error', 'Something went wrong');
  }
}


  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );

    showDialog(context: context, builder: (_) => alertDialog);
  }

  void movetoLastScreen() {
    Navigator.pop(context, true);
  }

  Future<void> _delete() async {
  if (note.id == null) {
    _showAlertDialog('Status', 'No note to delete');
    return;
  }

  final result = await databasehelper.deleteNote(note.id!);

  if (result > 0) {
    Navigator.pop(context, true);
  } else {
    _showAlertDialog('Status', 'Error deleting note');
  }
}

}
