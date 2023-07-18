import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notes/components/csutom_textfield.dart';
import 'package:notes/db/notes_database.dart';
import 'package:velocity_x/velocity_x.dart';
import '../consts/colors.dart';
import '../models/note.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({Key? key, required this.randColor}) : super(key: key);
  final Color randColor;

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: widget.randColor));
  }

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String? title;
  String? description;

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    final NotesDatabase _db = NotesDatabase.instance;

    void updateTitle(String value) {
      setState(() {
        title = value;
      });
    }

    void updateDescription(String value) {
      setState(() {
        description = value;
      });
    }

    void saveNote() async{

      final Note newNote = Note(
        title: title!,
        description: description!,
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
        backgroundColor: widget.randColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: scaffoldBackgroundColor),
          onPressed: () {
            Navigator.pop(context);
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
              onChanged: updateTitle,
              size: 26,
              hintFontWeight: FontWeight.w100,
              textFontWeight: FontWeight.w300,
              hintText: "Title",
              color: primaryColorlight,
              controller: titleController,
              autofocus: true,
              maxLines: 1,
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
              onChanged: updateDescription,
              size: 18,
              hintFontWeight: FontWeight.w100,
              textFontWeight: FontWeight.w200,
              hintText: "Description",
              color:primaryColorlight,
              controller: descriptionController,
              autofocus: false,
              maxLines: 100,
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
