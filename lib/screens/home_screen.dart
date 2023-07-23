import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notes/components/search_bar.dart';
import 'package:notes/db/notes_database.dart';
import 'package:notes/screens/note_screen.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';
import 'package:velocity_x/velocity_x.dart';
import 'dart:math';
import '../consts/colors.dart';
import '../models/note.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.notes});
  final List<Note> notes;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Color randColor = primaryColor;
  List<Note> notes=[];
  bool isLoading = false;
  bool isSelectedMode = false;
  Set<int> selectedNotes = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    generateRandomColor();
    refreshNotes();
    notes = widget.notes;
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

  void cancelSelection() {
    setState(() {
      selectedNotes.clear();
      isSelectedMode = false;
    });
  }

  void deleteSelectedNodes() async{
    final List<int> notesToDelete = selectedNotes.toList();
    for(int id in notesToDelete){
      await NotesDatabase.instance.delete(id);
    }
    setState(() {
      selectedNotes.clear();
      isSelectedMode = false;
    });

    refreshHomeScreen();
  }

  @override
  void didUpdateWidget(covariant HomePage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if(notes.length!=oldWidget.notes.length){
      cancelSelection();
    }
  }

  @override
  void dispose() {
    cancelSelection();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if(isSelectedMode){
          cancelSelection();
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: SizedBox(
          height: double.infinity,
          child: SafeArea(
              child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                isSelectedMode
                    ? Container()
                    : SearchBar(color: randColor),
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
                        final note = notes[index];
                        final isSelected = selectedNotes.contains(note.id);
                        int colorIndex = index % noteColors.length;
                        String title = note.title;
                        String description = note.description;
                        int maxL = description.length > 200
                            ? 200
                            : description.length;
                        return GestureDetector(
                          onTap: () {
                            if (isSelectedMode) {
                              setState(() {
                                  if(isSelected){
                                      selectedNotes.remove(note.id);
                                      print(selectedNotes);
                                  }else{
                                    selectedNotes.add(note.id!);
                                    print(selectedNotes);
                                  }
                                  if(selectedNotes.isEmpty){
                                    cancelSelection();
                                  }
                              });
                            } else {
                              {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => NoteScreen(
                                            randColor: randColor,
                                            refreshHomeScreen:
                                                refreshHomeScreen,
                                            note: notes[index])));
                              }
                            }
                          },
                          onLongPress: () {
                            setState(() {
                              isSelectedMode = true;
                              selectedNotes.add(note.id!);
                              print(selectedNotes);
                            });
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              title.text.xl
                                  .fontWeight(FontWeight.w500)
                                  .make(),
                              5.heightBox,
                              description
                                  .substring(0, maxL)
                                  .text
                                  .make(),
                            ],
                          )
                              .box
                              .roundedSM
                              .color(Color(noteColors[colorIndex])).border(color: isSelected?Colors.lightBlueAccent:Colors.transparent,width: isSelected?3:0)
                              .p16
                              .make(),
                        );
                      }),
                    )
                        .box
                        .margin(EdgeInsets.symmetric(horizontal: 10))
                        .make(),
              ],
            ),
          )),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: randColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          onPressed: isSelectedMode?deleteSelectedNodes:() {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => NoteScreen(
                      randColor: randColor,
                      refreshHomeScreen: refreshHomeScreen,
                    )));
          },
          child: isSelectedMode? Icon(Icons.delete,size: 26, color: scaffoldBackgroundColor):const Icon(
            Icons.add,
            size: 26,
            color: scaffoldBackgroundColor,
          ),
        ),
      ),
    );
  }
}
