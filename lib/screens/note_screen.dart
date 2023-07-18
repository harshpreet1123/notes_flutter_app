import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notes/components/csutom_textfield.dart';
import 'package:notes/db/notes_database.dart';
import 'package:notes/screens/home_screen.dart';
import 'package:sqflite/sqflite.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:path/path.dart';
import '../consts/colors.dart';
import '../models/note.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({Key? key}) : super(key: key);

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String? title;
  String? description;

  void updateTitle() {
    setState(() {
      title = titleController.text;
    });
  }

  void updateDescription() {
    setState(() {
      description = descriptionController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: primaryColor));

    final NotesDatabase _db = NotesDatabase.instance;

    void saveNote() async{
      final String title = titleController.text;
      final String description = descriptionController.text;

      final Note newNote = Note(
        title: title,
        description: description,
        createdTime: DateTime.now(),
      );

      await _db.create(newNote);
      Navigator.pop(context);

      print(_db);

    }

    void showNotes() async{
      final List<Note> notes = await _db.readAll();
      notes.forEach((note) {
        print('id: ${note.id}');
        print('Title: ${note.title}');
        print('Description: ${note.description}');
        print('Time: ${note.createdTime}');
      });
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 40,
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: scaffoldBackgroundColor),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => HomePage()),
            );
          },
        ),
        actions: [
          ElevatedButton(
            onPressed: (){saveNote();},
            child: "Save".text.make(),
            style: ElevatedButton.styleFrom(fixedSize: Size(100, 20)),
          ),
          ElevatedButton(
            onPressed: () {
              showNotes();
            },
            child: "Show".text.make(),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.more_vert_sharp,
              color: scaffoldBackgroundColor,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            20.heightBox,
            customTextField(
              26,
              FontWeight.w100,
              FontWeight.w300,
              "Title",
              primaryColorlight,
              titleController,
              true,
              1,
            )
                .box
                .padding(EdgeInsets.symmetric(horizontal: 16))
                .make(),
            const Divider(
              color: primaryColorlight,
              indent: 16,
              endIndent: 16,
            ),
            10.heightBox,
            customTextField(
              18,
              FontWeight.w100,
              FontWeight.w200,
              "Description",
              primaryColorlight,
              descriptionController,
              false,
              100,
            )
                .box
                .padding(EdgeInsets.symmetric(horizontal: 16))
                .make(),
          ],
        ),
      ),
    );
  }
}
