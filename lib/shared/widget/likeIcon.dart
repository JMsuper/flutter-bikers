import 'package:bikers/authentication/user.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LikeIcon extends StatefulWidget {
  const LikeIcon(
      {Key? key,
      required this.user,
      required this.item,
      required this.likeFunc,
      required this.unlikeFunc})
      : super(key: key);
  final Users? user;
  final dynamic item;
  final Function likeFunc;
  final Function unlikeFunc;

  @override
  _LikeIconState createState() => _LikeIconState(likeFunc, unlikeFunc);
}

class _LikeIconState extends State<LikeIcon> {
  _LikeIconState(this.likeFunc, this.unlikeFunc);
  late int isliked;
  final Function likeFunc;
  final Function unlikeFunc;

  @override
  initState() {
    super.initState();
    isliked = widget.item.isliked;
  }

  void changeIsLiked() {
    if (widget.item.isliked == 0) {
      widget.item.isliked = 1;
      widget.item.likeCount++;
    } else {
      widget.item.isliked = 0;
      widget.item.likeCount--;
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.item.isliked == 0
        ? Row(children: [
            Padding(
              padding: EdgeInsets.only(right: 13),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: InkWell(
                  onTap: () async {
                    await likeFunc(widget.user!.uid.toString(), widget.item);
                    changeIsLiked();
                    setState(() {});
                  },
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(5, 0, 5, 3),
                    child: Text("rev up",
                        style: GoogleFonts.permanentMarker(
                            fontSize: 13,
                            letterSpacing: 1,
                            color: Colors.grey)),
                  ),
                ),
              ),
            ),
            Text(widget.item.likeCount.toString(),
                style: GoogleFonts.actor(
                  color: Colors.grey,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                )),
          ])
        : Row(children: [
            Padding(
              padding: EdgeInsets.only(right: 13),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.red),
                    borderRadius: BorderRadius.circular(10)),
                child: InkWell(
                  onTap: () async {
                    await unlikeFunc(widget.user!.uid.toString(), widget.item);
                    changeIsLiked();
                    setState(() {});
                  },
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(5, 0, 5, 3),
                    child: Text("rev up",
                        style: GoogleFonts.permanentMarker(
                            fontSize: 13, letterSpacing: 1, color: Colors.red)),
                  ),
                ),
              ),
            ),
            Text(widget.item.likeCount.toString(),
                style: GoogleFonts.actor(
                  color: Colors.grey,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                )),
          ]);
  }
}
