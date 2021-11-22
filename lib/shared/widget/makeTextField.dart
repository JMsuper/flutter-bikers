import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class MakeTextField extends StatelessWidget {
  MakeTextField(
      {required this.controller,
      required this.text,
      required this.maxLines,
      required this.maxLength,
      required this.textInputType,
      required this.textInputFormatter});
  final TextEditingController controller;
  final String text;
  final int maxLines;
  final int maxLength;
  final TextInputType textInputType;
  final List<TextInputFormatter>? textInputFormatter;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return '문자를 입력하세요';
        }
        return null;
      },
      onChanged: (value) {},
      style: TextStyle(color: Colors.white),
      controller: controller,
      keyboardType: textInputType,
      inputFormatters: textInputFormatter,
      cursorColor: Colors.white,
      autocorrect: false,
      textInputAction: (TextInputAction.newline),
      maxLength: maxLength,
      maxLines: maxLines,
      decoration: InputDecoration(
          icon: Icon(Icons.short_text, color: Colors.white),
          labelText: text,
          labelStyle: GoogleFonts.abel(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
          suffixIcon: IconButton(
            icon: Icon(Icons.close),
            color: Colors.white,
            onPressed: () {
              controller.clear();
            },
          ),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 1)),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 1))),
    );
  }
}
