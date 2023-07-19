import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notes/components/csutom_textfield.dart';
import 'package:notes/db/notes_database.dart';
import 'package:velocity_x/velocity_x.dart';
import '../consts/colors.dart';
import '../models/note.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({Key? key, required this.randColor, required this.refreshHomeScreen, this.note}) : super(key: key);
  final Color randColor;
  final VoidCallback refreshHomeScreen;
  final Note? note;

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: widget.randColor));
    if(widget.note!=null){
      titleController.text=widget.note!.title;
      descriptionController.text=widget.note!.description;
    }
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

    final NotesDatabase db = NotesDatabase.instance;

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

      final String updatedTitle = titleController.text;
      final String updatedDescription = descriptionController.text;

      if(widget.note!=null){
        final updatedNote = widget.note!.copy(
          title: updatedTitle,
          description: updatedDescription
        );
        await db.update(updatedNote);
      }else{
        final Note newNote = Note(
          title: title!,
          description: description!,
          createdTime: DateTime.now(),
        );
        await db.create(newNote);
      }

      widget.refreshHomeScreen();
      Navigator.pop(context);
      // widget.method;
    }

    void showNotes() async{
      final List<Note> notes = await db.readAll();
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
