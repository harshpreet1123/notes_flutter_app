import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notes/components/textfield.dart';
import 'package:notes/screens/home_screen.dart';
import 'package:velocity_x/velocity_x.dart';

import '../consts/colors.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({super.key});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: primaryColor));
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    FocusNode descFocus = FocusNode();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 40,
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: scaffoldBackgroundColor),
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>HomePage()));
          },
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.more_vert_sharp,
                color: scaffoldBackgroundColor,
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            20.heightBox,
            customTextField(26, FontWeight.w100, FontWeight.w300, "Title", primaryColorlight,titleController,true,1).box.padding(EdgeInsets.symmetric(horizontal: 16)).make(),
            const Divider(color: primaryColorlight,indent: 16,endIndent: 16,),
            10.heightBox,
            customTextField(18, FontWeight.w100, FontWeight.w200, "Description", primaryColorlight,descriptionController,false,100).box.padding(EdgeInsets.symmetric(horizontal: 16)).make(),
          ],
        ),
      ),
    );
  }
}
