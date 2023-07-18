import 'package:flutter/material.dart';

Widget customTextField({
  required ValueChanged<String> onChanged,
  required double size,
  required FontWeight hintFontWeight,
  required FontWeight textFontWeight,
  required String hintText,
  required Color color,
  required TextEditingController controller,
  required bool autofocus,
  required int maxLines,
}) {
  return TextField(
    onChanged: onChanged,
    textCapitalization: TextCapitalization.sentences,
    maxLines: maxLines,
    autofocus: autofocus,
    controller: controller,
    style: TextStyle(
      color: color,
      fontWeight: textFontWeight,
      fontSize: size,
    ),
    decoration: InputDecoration(
      border: InputBorder.none,
      hintText: hintText,
      hintStyle: TextStyle(
        color: color,
        fontWeight: hintFontWeight,
        fontSize: size,
      ),
    ),
  );
}
