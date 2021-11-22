import 'package:flutter/material.dart';

class ShowModalBottomSheetTile extends StatelessWidget {
  ShowModalBottomSheetTile({required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        dense: true,
        title: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
        ),
        onTap: () {},
      ),
    );
  }
}