import 'package:flutter/material.dart';
import 'package:notes/consts/colors.dart';
import 'package:velocity_x/velocity_x.dart';

Widget SearchBar() {
  return const TextField(
    style: TextStyle(
      color: primaryColor
    ),
    decoration: InputDecoration(
      hintText: "Search",
      hintStyle: TextStyle(
        color: primaryColor
      ),
      border: InputBorder.none,
      contentPadding: EdgeInsets.all(16),
      suffixIcon: Icon(
        Icons.search_sharp,color: primaryColor,
      ),
    ),
  ).box.roundedSM.color(const Color(0xff514983)).make().p16();
}
