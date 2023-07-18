import 'package:flutter/material.dart';
import 'package:notes/components/search_bar.dart';
import 'package:notes/screens/note_screen.dart';
import 'package:velocity_x/velocity_x.dart';
import 'dart:math';
import '../consts/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Color randColor = primaryColor;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    generateRandomColor();
  }

  void generateRandomColor() {
    Random random = Random();
    int randIndex = random.nextInt(noteColors.length);
    setState(() {
      randColor = Color(noteColors[randIndex]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        child: SafeArea(
            child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              SearchBar(),
              10.heightBox,
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10),
                itemCount: 7,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    decoration: BoxDecoration(
                        color: Color(noteColors[index]),
                        borderRadius: BorderRadius.circular(16)),
                    width: 200,
                    height: 200,
                  );
                },
              ),
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
          Navigator.of(context).push(MaterialPageRoute(builder: (_)=>NoteScreen(randColor: randColor,)));
        },
        child: const Icon(
          Icons.add,
          color: scaffoldBackgroundColor,
        ),
      ),
    );
  }
}
