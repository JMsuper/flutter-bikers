import 'package:flutter/material.dart';
import '/shared/imageEdit/editImagePageElement.dart';
import '/provider/imageEditProvider.dart';
import 'package:provider/provider.dart';

class CustomBottomBar extends StatefulWidget {
  const CustomBottomBar({Key? key}) : super(key: key);

  @override
  _CustomBottomBarState createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
  var imageEditorKeyList;
  late GestureNotifier gestured;
  late AspectRatiosNotifier aspectRatios;
  @override
  Widget build(BuildContext context) {
    print("BottomBar Build!");
    imageEditorKeyList =
        context.select((ImageInfoNotifier item) => item.imageEditorKeyList);
    gestured = context.watch<GestureNotifier>();
    aspectRatios = context.read<AspectRatiosNotifier>();

    return BottomAppBar(
        color: const Color(0xFF000000),
        shape: const CircularNotchedRectangle(),
        child: ButtonTheme(
          padding: EdgeInsets.zero,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              TextButton.icon(
                icon: const Icon(
                  Icons.crop,
                  color: Colors.white,
                ),
                label: const Text(
                  '편집창',
                  style: TextStyle(fontSize: 10.0, color: Colors.white),
                ),
                onPressed: () {
                  showDialog<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return Column(
                          children: <Widget>[
                            const Expanded(
                              child: const SizedBox(),
                            ),
                            SizedBox(
                              height: 100,
                              child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.all(20.0),
                                itemBuilder: (_, int index) {
                                  final AspectRatioItem item =
                                      aspectRatios.aspectRatios[index];
                                  return GestureDetector(
                                    child: AspectRatioWidget(
                                      aspectRatio: item.value,
                                      aspectRatioS: item.text,
                                      isSelected:
                                          item == aspectRatios.aspectRatio,
                                    ),
                                    onTap: () {
                                      Navigator.pop(context);
                                      aspectRatios.changeAspectRatio(item);
                                    },
                                  );
                                },
                                itemCount: aspectRatios.aspectRatios.length,
                              ),
                            ),
                          ],
                        );
                      });
                },
              ),
              TextButton.icon(
                icon: const Icon(
                  Icons.flip,
                  color: Colors.white,
                ),
                label: const Text(
                  '반전',
                  style: TextStyle(
                    fontSize: 10.0,
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  int index = context.read<CurrentIndexNotifier>().currentIndex;
                  if (imageEditorKeyList[index].currentState != null) {
                    context.read<ImageInfoNotifier>().flip(index);
                  }
                },
              ),
              TextButton.icon(
                icon: const Icon(
                  Icons.rotate_left,
                  color: Colors.white,
                ),
                label: const Text(
                  '왼쪽',
                  style: TextStyle(
                    fontSize: 8.0,
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  int index = context.read<CurrentIndexNotifier>().currentIndex;
                  if (imageEditorKeyList[index].currentState != null) {
                    context.read<ImageInfoNotifier>().rotateLeft(index);
                  }
                },
              ),
              TextButton.icon(
                icon: const Icon(
                  Icons.rotate_right,
                  color: Colors.white,
                ),
                label: const Text(
                  '오른쪽',
                  style: TextStyle(
                    fontSize: 8.0,
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  int index = context.read<CurrentIndexNotifier>().currentIndex;
                  if (imageEditorKeyList[index].currentState != null) {
                    context.read<ImageInfoNotifier>().rotateRight(index);
                  }
                },
              ),
              TextButton.icon(
                icon: const Icon(
                  Icons.restore,
                  color: Colors.white,
                ),
                label: const Text(
                  '되돌리기',
                  style: TextStyle(
                    fontSize: 10.0,
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  int index = context.read<CurrentIndexNotifier>().currentIndex;
                  if (imageEditorKeyList[index].currentState != null) {
                    context.read<ImageInfoNotifier>().reset(index);
                    aspectRatios.aspectRatiosNotifierReset();
                    gestured.gestureNotifierReset();
                  }
                },
              ),
            ],
          ),
        ));
  }
}