import 'package:flutter/material.dart';

import '../consts/colors.dart';

Widget customTextField(double size,FontWeight hintfontweight,FontWeight textfontweight,String hinttext,Color color,controller,autofocus,maxLines){
  return TextField(
    textCapitalization: TextCapitalization.sentences,
    maxLines: maxLines,
    autofocus: true,
    style: TextStyle(color: color,fontWeight: textfontweight,fontSize: size),
    decoration: InputDecoration(
      border: InputBorder.none,
      hintText: hinttext,
      hintStyle: TextStyle(color: color,fontWeight: hintfontweight,fontSize: size),
    ),
  );
}