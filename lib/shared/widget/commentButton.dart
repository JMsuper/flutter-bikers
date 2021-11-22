import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CommentButton extends StatelessWidget {
  const CommentButton({Key? key, required this.item, required this.routeFunc})
      : super(key: key);
  final item;
  final Function routeFunc;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Padding(
        padding: EdgeInsets.fromLTRB(13, 0, 13, 0),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10)),
          child: InkWell(
            onTap: () async {
              routeFunc(item);
            },
            child: Padding(
              padding: EdgeInsets.fromLTRB(5, 1, 5, 3),
              child: Text("comment",
                  style: GoogleFonts.permanentMarker(
                      fontSize: 12, letterSpacing: 1, color: Colors.grey)),
            ),
          ),
        ),
      ),
      Text(item.commentCount.toString(),
          style: GoogleFonts.actor(
            color: Colors.grey,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          )),
    ]);
  }
}