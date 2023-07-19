import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notes/components/search_bar.dart';
import 'package:notes/db/notes_database.dart';
import 'package:notes/screens/note_screen.dart';
import 'package:velocity_x/velocity_x.dart';
import 'dart:math';
import '../consts/colors.dart';
import '../models/note.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Color randColor = primaryColor;
  late List<Note> notes;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    generateRandomColor();
    refreshNotes();
  }

  void generateRandomColor() {
    Random random = Random();
    int randIndex = random.nextInt(noteColors.length);
    setState(() {
      randColor = Color(noteColors[randIndex]);
    });
  }

  Future refreshNotes() async {
    setState(() {
      isLoading = true;
    });

    this.notes = await NotesDatabase.instance.readAll();

    setState(() {
      isLoading = false;
    });
  }

  void refreshHomeScreen() {
    refreshNotes();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        body: Container(
          height: double.infinity,
          child: SafeArea(
              child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                SearchBar(color: randColor),
                10.heightBox,
                isLoading == true
                    ? const CircularProgressIndicator(
                        color: primaryColor,
                      )
                    : StaggeredGrid.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        children: List.generate(notes.length, (index) {
                          int colorIndex = index % noteColors.length;
                          String title = notes[index].title;
                          String description = notes[index].description;
                          int maxL = description.length > 200
                              ? 200
                              : description.length;
                          return Padding(
                            padding: EdgeInsets.all(8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                title.text.xl2.make(),
                                5.heightBox,
                                description.substring(0, maxL).text.make(),
                              ],
                            ),
                          )
                              .box
                              .roundedSM
                              .color(Color(noteColors[colorIndex]))
                              .p8
                              .make()
                              .onTap(() {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => NoteScreen(
                                        randColor: randColor,
                                        refreshHomeScreen: refreshHomeScreen,
                                    note:notes[index])));
                          });
                        }),
                      ).box.margin(EdgeInsets.symmetric(horizontal: 10)).make(),
              ],
            ),
          )),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: randColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => NoteScreen(
                      randColor: randColor,
                      refreshHomeScreen: refreshHomeScreen,
                    )));
          },
          child: const Icon(
            Icons.add,
            color: scaffoldBackgroundColor,
          ),
        ),
      ),
    );
  }
}
