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

// IconButton(
//                       splashRadius: 20,
//                       iconSize: 20,
//                       icon: Icon(
//                         Icons.mode_comment_outlined,
//                         color: Colors.white,
//                       ),
//                       onPressed: () {
//                         Navigator.of(context).push(MaterialPageRoute(
//                             builder: (context) =>
//                                 CommentPage(feedId: item.id)));
//                       },
//                       tooltip: '댓글 달기',
//                     ),
//                     Text(
//                       '${item.commentCount}',
//                       style: GoogleFonts.actor(
//                         color: Colors.white,
//                         fontSize: 15,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),

// class CommentButton extends StatefulWidget {
//   const CommentButton(
//       {Key? key,})
//       : super(key: key);

//   @override
//   _CommentButtonState createState() => _CommentButtonState();
// }

// class _CommentButtonState extends State<CommentButton> {
//   _CommentButtonState(this.likeFunc, this.unlikeFunc);
//   late int isliked;
//   final Function likeFunc;
//   final Function unlikeFunc;

//   @override
//   Widget build(BuildContext context) {
//     return widget.item.isliked == 0
//         ? Row(children: [
//             Padding(
//               padding: EdgeInsets.only(right: 13),
//               child: Container(
//                 decoration: BoxDecoration(
//                     border: Border.all(color: Colors.white),
//                     borderRadius: BorderRadius.circular(10)),
//                 child: InkWell(
//                   onTap: () async {
//                     await likeFunc(widget.user!.uid.toString(), widget.item);
//                     changeIsLiked();
//                     setState(() {});
//                   },
//                   child: Padding(
//                     padding: EdgeInsets.fromLTRB(5, 0, 5, 3),
//                     child: Text("rev up",
//                         style: GoogleFonts.permanentMarker(
//                             fontSize: 15,
//                             letterSpacing: 1,
//                             color: Colors.white)),
//                   ),
//                 ),
//               ),
//             ),
//             Text(widget.item.likeCount.toString(),
//                 style: TextStyle(color: Colors.white)),
//           ])
//         : Row(children: [
//             Padding(
//               padding: EdgeInsets.only(right: 13),
//               child: Container(
//                 decoration: BoxDecoration(
//                     border: Border.all(color: Colors.red),
//                     borderRadius: BorderRadius.circular(10)),
//                 child: InkWell(
//                   onTap: () async {
//                     await unlikeFunc(widget.user!.uid.toString(), widget.item);
//                     changeIsLiked();
//                     setState(() {});
//                   },
//                   child: Padding(
//                     padding: EdgeInsets.fromLTRB(5, 0, 5, 3),
//                     child: Text("rev up",
//                         style: GoogleFonts.permanentMarker(
//                             fontSize: 15, letterSpacing: 1, color: Colors.red)),
//                   ),
//                 ),
//               ),
//             ),
//             Text(widget.item.likeCount.toString(),
//                 style: TextStyle(color: Colors.white)),
//           ]);
//   }
// }
