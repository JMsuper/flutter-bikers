// import 'package:flutter/material.dart';

// class TextSized {
//   static double getTextHeight(
//       String text, TextStyle textstyle, BuildContext context) {
//     final TextPainter textPainter = TextPainter(
//         text: TextSpan(text: text, style: textstyle),
//         textScaleFactor: MediaQuery.of(context).textScaleFactor,
//         textDirection: TextDirection.ltr,)
//       ..layout(maxWidth: MediaQuery.of(context).size.width);
//     final double height = textPainter.height;
//     return height;
//   }

//   static bool compareHeightWithBoxAndText(String text, TextStyle textstyle,
//       double boxHeight, BuildContext context) {
//     double textHeight = getTextHeight(text, textstyle, context);
//     print(" boxHeight:" +
//         boxHeight.toString() +
//         " textHeight:" +
//         textHeight.toString());
//     bool isTall = boxHeight < textHeight;
//     return isTall;
//   }
// }
